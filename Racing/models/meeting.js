/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 17/03/13
 * Time: 6:40 PM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;
    //Race = require('./race');

var MeetingSchema = new Schema({
    RaceDayDate : {type : Date, index : true },
    Year : Number,
    Month : Number,
    Day : Number,
    DayOfTheWeek : String,
    MonthLong : String,
    MeetingType : String,
    Abandoned : Boolean,
    VenueName : String,
    SortOrder : String,
    HiRaceNo : Number,
    MeetingCode : { type : String, index : true }
});


module.exports = mongoose.model('Meeting', MeetingSchema);


