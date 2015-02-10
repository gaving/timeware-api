# timeware-api

Manipulate Timeware

## Installation

- `npm install`
- `cp config/default.yml.example config/default.yml`
- configure `default.yml`
- `coffee server.coffee`

## Usage

- curl --header "X-Auth-Pass: 1234" -X GET `http://localhost:8080/history/john+smith`
- curl --header "X-Auth-Pass: 1234" -X GET `http://localhost:8080/balance/john+smith`
- curl --header "X-Auth-Pass: 1234" -X POST `http://localhost:8080/clock/john+smith`
