request = require('request')
cheerio = require('cheerio')
url = require('url')
cfg = require('config').config
express = require('express')
bodyParser = require('body-parser')

app = express()

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()

router = express.Router()

router.use (req, res, next) ->
  next()

router.route('/balance/:id').get (req, res) ->
  request = request.defaults({proxy: false, jar: true})
  request.post url.resolve(cfg.url, 'log_in.html'),
    form:
      txtUserName: req.params.id.replace('+',' ')
      txtPassword: req.headers['x-auth-pass'] || req.query.pass
  , (error, response, body) ->
    res.send(error) if error or response.statusCode is not 200
    request url.resolve(cfg.url, 'attendance_booking.html'), (error, response, body) ->
      res.send(error) if error or response.statusCode is not 200
      $ = cheerio.load(body)
      $table = $('#content table:nth-child(2)')
      res.json $table.find('tr:last-child').find('td:last-child').text()

router.route('/clock/:id').post (req, res) ->
  request = request.defaults({proxy: false, jar: true})
  request.post url.resolve(cfg.url, 'log_in.html'),
    form:
      txtUserName: req.params.id.replace('+',' ')
      txtPassword: req.headers['x-auth-pass'] || req.query.pass
  , (error, response, body) ->
    res.send(error) if error or response.statusCode is not 200
    request.post url.resolve(cfg.url, 'attendance_booking.html'), (error, response, body) ->
      res.send(error) if error or response.statusCode is not 200
      res.json success: true

app.use '/api', router

app.listen process.env.PORT or 8080
console.log "Running on #{process.env.PORT or 8080}"
