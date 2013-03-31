var mongoose = require('mongoose');

var Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var RiderSchema = new Schema({
    name : { type: String, index: { unique : true }},
    apprentice : Boolean,
    totalRuns : { type : Number, default : 0 },
    firsts : { type : Number, default : 0 },
    seconds : { type : Number, default : 0 },
    thirds : { type : Number, default : 0 },
    fourths : { type : Number, default : 0 },
    rider_id : ObjectId
});

mongoose.model('Rider', RiderSchema);
exports.Rider = mongoose.model('Rider');