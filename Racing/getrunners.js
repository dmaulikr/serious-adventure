/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 2:37 PM
 * To change this template use File | Settings | File Templates.
 */

app = module.exports.app;


var Horse = require('./models/horse'),
    Rider = require('./models/rider'),
    Meeting = require('./models/meeting'),
    restify = require('restify');
var client = restify.createJsonClient({
    url: 'http://localhost:8080',
    accept: {'Content-type': '*/*'},
    headers:{'Content-type': 'application/json'}
});


function processPlacing(r, p) {
    var horse, rider;

    if (p !== null) {
        if (p.place === '1') {
            horse = { "name" : r.$.RunnerName, "placing": 1 };
            rider = { "name" : r.$.Rider, "placing": 1 };
        } else if (p.place === '2') {
            horse = { "name" : r.$.RunnerName, 'placing': 2 };
            rider = { "name" : r.$.Rider, 'placing': 2 };
        } else if (p.place === '3') {
            horse = { "name" : r.$.RunnerName, 'placing': 3 };
            rider = { "name" : r.$.Rider, 'placing': 3 };
        } else if (p.place === '4') {
            horse = { "name" : r.$.RunnerName, 'placing': 4 };
            rider = { "name" : r.$.Rider, 'placing': 4 };
        }
     else {
        if (r.$.Scratched === 'N') {
            horse = { "name" : r.$.RunnerName, 'placing': 0 };
            rider = { "name" : r.$.Rider, 'placing': 0 };
        }
    }
        try {

            client.post('/horses', horse, function(err, req, res, obj) {
                if (err) console.log(err);
                //console.log('%d -> %j', res.statusCode, res.headers);
                console.log('%j', obj);
            });


            client.post('/riders',rider,  function (err, req, res, obj) {
                if (err) console.log(err);
                //console.log('%d -> %j', res.statusCode, res.headers);
                console.log('%j', obj);
            });

        } catch (e) {
            console.log('processPlacing' + e);
        }
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
    var util = require('util');
    var year = meet.Year;
    var month = meet.Month;
    var day = meet.Day;
    var mcode = meet.MeetingCode;
    var noRaces = meet.HiRaceNo;
    for (var r = 1; r <= noRaces; r++) {
        try {
            var relurl = util.format('/pagedata/racing/%d/%d/%d/%s%d.xml', year, month, day, mcode, r);
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
            // lean().
            stream();
        leanStream.on('data', processMeets)
            .on('error', function (err) {
                console.log(err);
            });
};
