/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 7/04/13
 * Time: 12:38 PM
 * To change this template use File | Settings | File Templates.
 */
var mongoose = require('mongoose'),
    util = require('util');
mongoose.set('debug', true);
var Horse = require('./models/horse'),
    Rider = require('./models/rider'),
    Race = require('./models/race'),
    RaceRunner = require('./models/racerunner');

var uri = 'mongodb://localhost/racingdata?poolSize=10';
var db = mongoose.connect(uri);

var  Meeting = require('./models/meeting');

function raceDat(race) {
    try {
        var rac = new Race({
            MeetingCode : race.Meeting.$.MeetingCode,
            Year: race.$.Year,
            Month: race.$.Month,
            Day: race.$.Day,
            RaceNo: race.Meeting.Race.$.RaceNo,
            Distance: race.Meeting.Race.$.Distance,
            RaceName: race.Meeting.Race.$.RaceName,
            CloseTime: race.Meeting.Race.$.RaceTime,
            Runners: []
        });
      var  runners = race.Meeting.Race.Runner;
        runners.forEach(function (runner) {
            rac.markModified('Runners');
           rac.Runners.push(new RaceRunner({
                Barrier : runner.$.Barrier,
                Handicap: runner.$.Handicap,
                LastResult: runner.$.LastResult,
                RiderName: runner.$.Rider ,
                RiderRating: 0,
                Rtng: race.$.Rtng,
                RunnerName: runner.$.RunnerName,
                RunnerRating: 0,
                RunnerNo: runner.$.RunnerNo,
                Scratched: runner.$.Scratched,
                Weight: runner.$.Weight
            }));
            //rac.Runners.push([racerunner]);
        })

       rac.save();
    } catch (e) {
        console.log('raceData ' + e);
    }
}

function getRac(hostname, relurl, callback) {
    var http = require('http'),
        simplexml = require('xml-simple'),
        config = {
            host: hostname,//'tatts.com',
            path: relurl,//'/pagedata/racing/2013/3/10/VR1.xml',
            port:80
        },
        body= '';
    http.get(config, function ( res ) {
        res.addListener('end', function() {
            simplexml.parse(body, function(e, parsed) {

                try {
                    callback(parsed);
                } catch (e) {
                    console.log('http.get ' + e)
                }
            });
        });
        res.setEncoding('utf8');
        res.on('data', function(d) {
            body+=d;
        });
    });
}

function processMeet(meet) {
    if (meet !== null) {
        var year = meet.Year;
        var month = meet.Month;
        var day = meet.Day;
        var mcode = meet.MeetingCode;
        var noRaces = meet.HiRaceNo;
        for (var r = 1; r <= noRaces; r++) {
            try {
                var relurl = util.format('/pagedata/racing/%d/%d/%d/%s%d.xml', year, month, day, mcode, r);
                getRac('tatts.com', relurl, raceDat);
            } catch (e) {
                console.log('processMeets ' + e);
            }
        }
    }
}

module.exports = function getRaces(year, month, days) {
    days.forEach(function (day) {
       var lstream =  Meeting.find({Year: year, Month: month, Day : day},'Year Month Day MeetingCode HiRaceNo VenueName').
           lean().
           stream();
        lstream.on('data', processMeet).
            on('error', function (err) {
                console.log(err);
            })
    });
};
