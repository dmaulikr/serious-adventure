/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 7/04/13
 * Time: 3:34 PM
 * To change this template use File | Settings | File Templates.
 */
var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var RunnerSchema = new Schema({
    Barrier : Number,
    Handicap: String,
    LastResult: String,
    RiderName: String ,
    RiderRating: Number,
    Rtng: Number,
    RunnerName: String,
    RunnerRating: Number,
    RunnerNo: Number,
    Scratched: Boolean,
    Weight: String
});

module.exports = mongoose.model('Runner', RunnerSchema);
