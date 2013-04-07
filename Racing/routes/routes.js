/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 6/04/13
 * Time: 12:46 PM
 * To change this template use File | Settings | File Templates.
 */
var Meeting = require('./models/meeting');
function getMeetings(req, res, next) {
    // Resitify currently has a bug which doesn't allow you to set default headers
    // This headers comply with CORS and allow us to server our response to any origin
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    // .find() without any arguments, will return all results
    // the `-1` in .sort() means descending order
    Meeting.find().sort({RaceDayDate: 'DESC'}).execFind(function (arr,data) {
        res.send(data);
    });
}