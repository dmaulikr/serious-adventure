/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 8:42 AM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var RaceSchema = new Schema({
    RaceNo : { type : Number, index : true },
    Month : Number,
    Day : Number,
    Time : Number,
    CloseTime : Date,
    MeetingCode: String,
    RaceName : String,
    Distance : Number,
    Runners: [{type: Schema.ObjectId, ref: 'Runner'}]
});

module.exports = mongoose.model('Race', RaceSchema);
