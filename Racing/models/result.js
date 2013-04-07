/**
 * Created with JetBrains WebStorm.
 * User: stry41802
 * Date: 20/03/13
 * Time: 5:53 AM
 * To change this template use File | Settings | File Templates.
 */

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var ResultSchema = new Schema({
    PlaceNo : Number,
    RunnerNo : Number,
    PoolType : String
});

module.exports = mongoose.model('result', ResultSchema);