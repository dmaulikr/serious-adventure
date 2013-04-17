/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 6:51 AM
 * To change this template use File | Settings | File Templates.
 */

app = module.parent.exports.app;

var Horse = require('./models/horse'),
    Rider = require('./models/rider'),
    Meeting = require('./models/meeting');

// This function is responsible for returning all entries for the Message model
function getHorses(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    Horse.find().skip(req.params.skip),limit(req.params.limit).execFind(function (arr,data) {
        res.send(data);
    });
}

function getHorseByName (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    Horse.find({name:req.params.name}).execFind(function (err,data) {
        if(err)
            res.send(401,"Horse not found");
        res.send(data);
    });
}

function getRiders(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    Rider.find().skip(req.params.skip).limit(req.params.limit).execFind(function (arr,data) {
        res.send(data);
    });
}


function getRiderByName (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    Rider.find({name:req.params.name}).execFind(function (err,data) {
        if(err)
            res.send(401,"Rider not found");
        res.send(data);
    });
}
function postHorse(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    // Create a new message model, fill it up and save it to Mongodb
    var options = { "upsert": true };
    var query = { "name" : req.params.name };
    var update = {};
    switch (req.params.placing) {
        case 1:
            update = { $inc : { "totalRuns": 1, "firsts" : 1 }};
            break;
        case 2:
            update = { $inc : { "totalRuns": 1, "seconds" : 1 }};
            break;
        case 3:
            update = { $inc : { "totalRuns": 1, "thirds" : 1 }};
            break;
        case 4:
            update = { $inc : { "totalRuns": 1, "fourths" : 1 }};
            break;
        default :
            update = { $inc : { "totalRuns": 1 }};
            break;
    }


    Horse.findOneAndUpdate(query, update, options, function (err, horse) {
        if (err) throw err;
        if (horse) {
            horse.calcRating();
            horse.save();
        }

        res.send(req.body);
    });

}


function postRider(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    // Create a new message model, fill it up and save it to Mongodb
    var options = { "upsert": true };
    var appy = false;
    var name = req.params.name;

    if (name.indexOf('(') > 0);
      appy = true;
    var query = { "name" : name.split('(')[0] };
    var update = {};
    switch (req.params.placing) {
        case 1:
            update = {apprentice : appy, $inc : { "totalRuns": 1, "firsts" : 1 }};
            break;
        case 2:
            update = {apprentice : appy,  $inc : { "totalRuns": 1, "seconds" : 1 }};
            break;
        case 3:
            update = {apprentice : appy,  $inc : { "totalRuns": 1, "thirds" : 1 }};
            break;
        case 4:
            update = {apprentice : appy,  $inc : { "totalRuns": 1, "fourths" : 1 }};
            break;
        default :
            update = {apprentice : appy,  $inc : { "totalRuns": 1 }};
            break;
    }


    Rider.findOneAndUpdate(query, update, options, function (err, rider) {
        if (err) throw err;
        if (rider) {
            rider.calcRating();
            rider.save();
        }

        res.send(req.body);
    });

}

function loadMeetingsFromUrl (req, res, next) {
    var getMeetings =require('./getmeeting');
    getMeetings(req.params.year, req.params.month, req.params.day);
    res.send(200, "Meetings processing");
    next();
}

function loadRacesFromUrl (req, res, next) {
    var getRunners =require('./getrunners');
    getRunners(req.params.year, req.params.month, req.params.day);
    res.send(200, "Races processing");
    next();
}

function getMeetings (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    Meeting.find().skip(req.params.skip).limit(req.params.limit).execFind(function (err,data) {
        if(err)
            res.send(401,"Horse not found");
        res.send(data);
    });
}

function getMeetingsDay (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    var qry = {Year: req.params.year, Month: req.params.month, Day: req.params.day};
    Meeting.find(qry).skip(req.params.skip).limit(req.params.limit).execFind(function (err,data) {
        if(err)
            res.send(401,"meetings not found");
        res.send(data);
    });
}

app.get('/meetings/:skip/:limit', getMeetings);
app.get('/meetings/:year/:month/:day/:skip/:limit', getMeetingsDay);

app.get('/horses/:name', getHorseByName);
app.get('/horses/:skip/:limit', getHorses);
app.post('/horses', postHorse);
app.put('/horses', postHorse);

app.get('/riders/:name', getRiderByName);
app.get('/riders/:skip/:limit', getRiders);
app.post('/riders', postRider);
app.put('/riders', postRider);

app.get('/loadmeeting/:year/:month/:day', loadMeetingsFromUrl);

app.get('/loadraces/:year/:month/:day', loadRacesFromUrl);