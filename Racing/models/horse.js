var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var HorseSchema = new Schema({
    name : { type: String, index: { unique : true }},
    totalRuns : { type : Number, default : 0 },
    firsts : { type : Number, default : 0 },
    seconds : { type : Number, default : 0 },
    thirds : { type : Number, default : 0 },
    fourths : { type : Number, default : 0 },
    horse_id : ObjectId
});


mongoose.model('Horse', HorseSchema);
exports.Horse = mongoose.model('Horse');