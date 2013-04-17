/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 14/04/13
 * Time: 6:23 PM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var HorseSchema = new Schema({
    name : { type: String, index: { unique : true }},
    totalRuns : { type : Number, default : 0 },
    firsts : { type : Number, default : 0 },
    seconds : { type : Number, default : 0 },
    thirds : { type : Number, default : 0 },
    fourths : { type : Number, default : 0 },
    rating : { type : Number, default : 0, index: {unique: false}}
});

HorseSchema.methods.calcRating = function() {
    var runs = this.totalRuns,
        wins = this.firsts,
        secs = this.seconds,
        thrd = this.thirds,
        frth = this.fourths,
        rating = 0;
    if (wins > 0) rating = ( wins / runs  * 100);
    if (secs > 0) rating = rating + (secs / runs * 90);
    if (thrd > 0) rating = rating + (thrd / runs * 60);
    if (frth > 0) rating = rating + (frth / runs * 30);
    this.rating = rating;
};


module.exports = mongoose.model('Horse', HorseSchema);