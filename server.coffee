request = require('request')
cheerio = require('cheerio')
url = require('url')
Q = require('q')
cfg = require('config').config
express = require('express')
bodyParser = require('body-parser')

app = express()

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()

router = express.Router()

router.use (req, res, next) ->
  next()

fetch = (req, res) ->
  dfd = Q.defer()
  request = request.defaults({proxy: false, jar: true})
  request.post url.resolve(cfg.url, 'log_in.html'),
    form:
      txtUserName: req.params.id.replace('+',' ')
      txtPassword: req.headers['x-auth-pass'] || req.query.pass
  , (error, response, body) ->
    dfd.reject(error) if error or response.statusCode is not 200
    request url.resolve(cfg.url, 'attendance_booking.html'), (error, response, body) ->
      dfd.reject(error) if error or response.statusCode is not 200
      dfd.resolve(body)
  dfd.promise

router.route('/balance/:id').get (req, res) ->
  fetch(req, res).then (body) ->
    $ = cheerio.load(body)
    $table = $('#content table:nth-child(2)')
    res.json $table.find('tr:last-child').find('td:last-child').text()
  .fail (e) ->
    res.send(e)

router.route('/clock/:id').post (req, res) ->
  fetch(req, res).then (body) ->
    res.json success: true
  .fail (e) ->
    res.send(e)
    res.json success: false

app.use '/api', router

app.listen process.env.PORT or 8080
console.log "Running on #{process.env.PORT or 8080}"
