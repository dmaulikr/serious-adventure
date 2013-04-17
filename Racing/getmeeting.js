/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 2:37 PM
 * To change this template use File | Settings | File Templates.
 */
 var app = module.exports.app;

var mongoose = require('mongoose'),
    util = require('util'),
    Meeting = require('./models/meeting');


function meetingData(data, year, month, day) {
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
            try {
                Meeting.findOneAndUpdate(qry, update, opts, function() {

                });
            } catch (e) {
                console.log(e);
            }
        }
    });
}

module.exports = function getMeetings(year, month, day) {
    var relUrl = util.format('/pagedata/racing/%s/%s/%s/RaceDay.xml', Number(year), Number(month), Number(day));
    var http = require('http'),
        simplexml = require('xml-simple'),
        config = {
            host: 'tatts.com',
            path: relUrl,
            port: 80
        },
        body = '';
    http.get(config, function (res) {
        res.addListener('end', function () {
            simplexml.parse(body, function (e, parsed) {
                try {
                    meetingData(parsed.Meeting, Number(year), Number(month), Number(day));
                } catch (e) {
                }
            });
        });
        res.setEncoding('utf8');
        res.on('data', function (d) {
            body += d;
        });
    });

};
