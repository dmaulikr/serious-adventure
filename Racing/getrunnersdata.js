
var mongoose = require('mongoose'),
    util = require('util');
//mongoose.set('debug', true);
var Horse = require('./models/horse').Horse,
    Rider = require('./models/rider').Rider,
    Meeting = require('./models/meeting').Meeting;

var uri = 'mongodb://localhost/racingdata?poolSize=10';
var db = mongoose.connect(uri);
//var db = mongoose.createConnection();


function postUpdates(hq, rq, hupd, rupd) {
    try {
        var opts = { "upsert": true };
        var done = function(){};
        var done1 = function(){};
        if (hq !== null)
            Horse.findOneAndUpdate(hq, hupd, opts, done);
        if (rq !== null)
            Rider.findOneAndUpdate(rq, rupd, opts, done1);
    } catch (e) {
        console.log('postUpdates' + e);
    }
}

function processPlacing(r, p) {
    try {
        var rider = '';
        var isapprentice = false;
        var j = r.$.Rider || '';
        var hupd;
        var rupd;
        rider =  j ;
        if (j && j.indexOf("(") > 0) {
            rider = j.substr(0,j.indexOf('('));
            isapprentice = true;
        }
        var hq = { "name" : r.$.RunnerName };
        var rq = { "name" : rider };

        if (p !== null) {
            if (p.place === '1') {
                hupd = { "name" : r.$.RunnerName, $inc :{ "totalRuns": 1, "firsts" : 1 }};
                rupd = { "name" : rider, "apprentice": isapprentice, $inc : { "totalRuns": 1, "firsts" : 1 }};
            } else if (p.place === '2') {
                hupd = { "name" : r.$.RunnerName, $inc :{ "totalRuns": 1, "seconds" : 1 }};
                rupd = { "name" : rider, "apprentice": isapprentice, $inc : { "totalRuns": 1, "seconds" : 1 }};
            } else if (p.place === '3') {
                hupd = { "name" : r.$.RunnerName, $inc :{ "totalRuns": 1, "thirds" : 1 }};
                rupd = { "name" : rider, "apprentice": isapprentice, $inc : { "totalRuns": 1, "thirds" : 1 }};
            } else if (p.place === '4') {
                hupd = { "name" : r.$.RunnerName, $inc :{ "totalRuns": 1, "fourths" : 1 }};
                rupd = { "name" : rider, "apprentice": isapprentice, $inc : { "totalRuns": 1, "fourths" : 1 }};
            }
        } else {
            if (r.$.Scratched === 'N') {
                hupd = { "name" : r.$.RunnerName, $inc :{ "totalRuns": 1 }};
                rupd = { "name" : rider, "apprentice": isapprentice, $inc : { "totalRuns": 1 }};
            } else {
                hq = null;
                rq = null;
                //console.log(r.$.RunnerName+' not a runner');
            }
        }
        if (hq !== null && rq !== null)
            postUpdates(hq, rq, hupd, rupd);
        console.log(hq);
    } catch (e) {
        console.log('processPlacing' + e);
    }
}

function getResults(race) {
    var pos = [];
    var runners = race.Runner;
    var results = race.ResultPlace;
    try {
        results.forEach(function(res) {
            switch (res.$.PlaceNo) {
                case '1':
                    pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '1'});
                    break;
                case '2':
                    pos.push({'runnerNo':res.Result[0].$.RunnerNo, 'place': '2'});
                    break;
                case '3':
                    pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '3'});
                    break;
                case '4':
                    pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '4' });
                    break;
            }
        });
    } catch (e) {
        console.log('getResults no result '+ e);
    }
    try {
        runners.forEach(function(runner){
            var place = null;
            var r = runner.$.RunnerNo;
            for (var i = 0; i < pos.length ; i++) {
                var p = pos[i].runnerNo ;
                found = true;
                if(r === p ) {
                    place = pos[i];
                    break;
                }
            }
            processPlacing(runner, place);

        });
    } catch (e) {
        console.log('getResults no runners ' + e);
    }
}

function raceData(race) {
    try {
        var pools = race.Pool;
        var paying = false;
        pools.forEach(function (pool) {
            if (pool.$.PoolType === 'WW' && pool.$.Available === 'Y') {
                paying = true;
                if (paying) {
                    debugger;
                    getResults(race);
                }
            }
        });
    } catch (e) {
        console.log('raceData ' + e);
    }
}

function getRace(hostname, relurl, callback) {
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
                debugger;
                try {
                    callback(parsed.Meeting.Race);
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

function processMeets(meet) {
    var year = meet.Year;
    var month = meet.Month;
    var day = meet.Day;
    var mcode = meet.MeetingCode;
    var noRaces = meet.HiRaceNo;
    for (var r = 1; r <= noRaces; r++) {
        try {
            var relurl = util.format('/pagedata/racing/%d/%d/%d/%s%d.xml', year, month, day, mcode, r);
            debugger;
            getRace('tatts.com', relurl, raceData);
        } catch (e) {
            console.log('processMeets ' + e);
        }
    }
}
module.exports = function getRunners(year, month, day) {
    var leanStream = Meeting.
    find({Year: year, Month: month, Day : day}, 'Year Month Day VenueName MeetingCode HiRaceNo').
    sort({Year: 'ASC', Month: 'ASC', Day: 'ASC', MeetingCode: 'ASC' }).
    lean().
    stream();
    leanStream.on('data', processMeets)
        .on('error', function (err) {
            console.log(err);
        });
};
	//mongoose.disconnect;