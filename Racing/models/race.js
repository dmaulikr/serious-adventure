/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 19/03/13
 * Time: 5:54 PM
 * To change this template use File | Settings | File Templates.
 */
var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;
   // Result = require('./result');

var RaceSchema = new Schema({
    RaceNo : { type : Number, index : true },
    Month : Number,
    Day : Number,
    Time : Number,
    CloseTime : Date,
    MeetingCode: String,
    RaceName : String,
    Distance : Number,
    SubFav : Number,
    RaceDisplayStatus: String,
    WeatherChanged : Boolean,
    WeatherCond : Number,
    WeatherDesc : String,
    TrackChanged : Boolean,
    TrackCond : Number,
    TrackDesc : String,
    TrackRating : Number,
    TrackRatingChanged : Boolean,
    RunnerNo : { type : Number, index : true },
    RunnerName : { type: String, index: true },
    Scratched : Boolean,
    Rider : String,
    RiderChanged : Boolean,
    Barrier : Number,
    Handicap : String,
    Weight : Number,
    Form : String,
    LastResult : String,
    Rtng : Number
});

mongoose.model('Race', RaceSchema);
exports.Race = mongoose.model('Race');