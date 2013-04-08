var restify = require('restify');
var config = require('./config');

var server = restify.createServer();

server.use(restify.acceptParser(server.acceptable));
server.use(restify.queryParser());
server.use(restify.bodyParser());


var mongoose = require('mongoose/');
db = mongoose.connect('mongodb://localhost/racingdata?poolSize=10');

var Rider = require('./models/rider');
var calculateRating = require('./utils/utils');

//var Horse = require('./models/horse');
//var Rider = require('./models/rider');

//var Race = require('/models/race');

var Meeting = require('./models/meeting');

function getMeetings(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");

    // .find() without any arguments, will return all results
    // the `-1` in .sort() means descending order
    var criteria = {};
    var year = req.params.Year;
    var month = req.params.Month;
    var day = req.params.Day;
    if (year !== undefined && month !== undefined && day !== undefined) {
     criteria = {Year: year, Month: month, Day: day};
    }
    console.log(criteria);
    Meeting.
        find(criteria).
        sort({RaceDayDate: 'DESC'}).
        execFind(function (arr,data) {
            res.send(data);
        });
}


var Horse = require('./models/horse');

function getRunner(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    if (req.params.name !== undefined) {
        var criteria = {name: req.params.name.toUpperCase() };
    } else res.send(500);
    console.log(criteria);
    Horse.
        findOne(criteria).
        exec(function (err, data) {
            if (err) res.send(err, 500);
            if (data) {
                calculateRating(data, function (rating) {
                    data._doc.rating = rating;
                });
                res.send(data);
            } else {
                 res.send(404);
            }
        });
}
function getRider(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    if (req.params.name !== undefined) {
        var criteria = {name: req.params.name.toUpperCase() };
    } else res.send(500);
    console.log(criteria);
    Rider.
        findOne(criteria).
        exec(function (err, data) {
            if (err) res.send(err, 500);
            if (data) {
                calculateRating(data, function (rating) {
                    try {
                        data._doc.rating = rating;
                    } catch (e) {
                        res.send(e, 500);
                    }
                });
                res.send(data);
            } else {
                res.send(404);
            }
        });
}


// Set up our routes and start the server
server.get('/api/meetings', getMeetings);
server.get('/api/horse/:name', getRunner);
server.get('/api/rider/:name', getRider);
server.listen(8080);