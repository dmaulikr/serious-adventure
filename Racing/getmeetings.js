/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 17/03/13
 * Time: 6:54 PM
 * To change this template use File | Settings | File Templates.
 */
var mongoose = require('mongoose'),
    util = require('util'),
    Meeting = require('./models/meeting');
//mongoose.set('debug', true);
var uri = 'mongodb://localhost/racingdata?poolSize=10';
mongoose.connect(uri);

function meetingData(data) {
    data.forEach(function (meet) {
        if (meet.$.Abandoned === 'N' && meet.$.MeetingType === 'R') {
            var d = new Date(year, month, day);
            var qry = { "Year" : year, "Month" : month, "Day" : day , "MeetingCode" : meet.$.MeetingCode };
            console.log(JSON.stringify(qry));
            var opts = { "upsert" : true };
            var update = {
                "RaceDayDate" : d,
                "Year" : year,
                "Month" : month,
                "Day" : day,
                "MeetingType" : meet.$.MeetingType,
                "Abandoned" : false,
                "VenueName" : meet.$.VenueName,
                "HiRaceNo" : meet.$.HiRaceNo,
                "MeetingCode" : meet.$.MeetingCode
            };
            var cb = function () {};
            try {
                debugger;
                Meeting.findOneAndUpdate(qry, update, opts, cb);
            } catch (e) {
                console.log(e);
            }
        }
    });
}

function getRaceMeeting(hostname, relurl, callback) {
    var http = require('http'),
        simplexml = require('xml-simple'),
        config = {
            host: hostname,//'tatts.com',
            path: relurl,//'/pagedata/racing/2013/3/10/VR1.xml',
            port: 80
        },
        body = '';
    http.get(config, function (res) {
        res.addListener('end', function () {
            simplexml.parse(body, function (e, parsed) {
                try {
                    callback(parsed.Meeting);
                } catch (e) {
                }
            });
        });
        res.setEncoding('utf8');
        res.on('data', function (d) {
            body += d;
        });
    });
}

//var year = 2013;
//var month = 3;
//var days = [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
module.exports = function getMeeting(year, month, days) {
    days.forEach(function (day) {
        var relUrl = util.format('/pagedata/racing/%s/%s/%s/RaceDay.xml', year, month, day);
        getRaceMeeting('tatts.com', relUrl, function (data) {
            data.forEach(function (meet) {
                if (meet.$.Abandoned === 'N' && meet.$.MeetingType === 'R') {
                    var d = new Date(year, month, day);
                    var qry = { "Year" : year, "Month" : month, "Day" : day , "MeetingCode" : meet.$.MeetingCode };
                    console.log(JSON.stringify(qry));
                    var opts = { "upsert" : true };
                    var update = {
                        "RaceDayDate" : d,
                        "Year" : year,
                        "Month" : month,
                        "Day" : day,
                        "MeetingType" : meet.$.MeetingType,
                        "Abandoned" : false,
                        "VenueName" : meet.$.VenueName,
                        "HiRaceNo" : meet.$.HiRaceNo,
                        "MeetingCode" : meet.$.MeetingCode
                    };
                    var cb = function () {};
                    try {
                        debugger;
                        Meeting.findOneAndUpdate(qry, update, opts, cb);
                    } catch (e) {
                        console.log(e);
                    }
                }
            });
        });
    });
};
