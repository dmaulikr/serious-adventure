/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 17/04/13
 * Time: 8:52 AM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    Horse = require('./models/horse'),
    Rider = require('./models/rider');

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

RunnerSchema.pre('save', function (next) {
    Horse.find({name : this.RunnerName}, 'rating', function (err, doc){
         this.RunnerRating = doc || 0;
    });
    Rider.find({name: this.RiderName.split('(')[0]}, 'rating', function (err, doc){
         this.RiderRating = doc || 0;
    });
    this.Rtng = this.RiderRating + this.RunnerRating / 2;
    next();
});

module.exports = mongoose.model('Runner', RunnerSchema);