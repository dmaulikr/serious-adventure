/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 8:40 AM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

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
    MeetingCode : { type : String, index : true },
    Races : [{type: Schema.ObjectId, ref: 'Race'}]
});


module.exports = mongoose.model('Meeting', MeetingSchema);