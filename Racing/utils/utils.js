/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 7/04/13
 * Time: 9:33 AM
 * To change this template use File | Settings | File Templates.
 */

module.exports = function calculateRating(data, callback) {
    try {
        var runs = data.totalRuns;
        var first = data.firsts,
            second = data.seconds,
            third = data.thirds,
            fourth = data.fourths;
    } catch (e) {

    }
    var    rating = 0;

    if (first > 0) rating = ( first / runs  * 100);
    if (second > 0) rating = rating + (second / runs * 90);
    if (third > 0) rating = rating + (third / runs * 60);
    if (fourth > 0) rating = rating + (fourth / runs * 30);

    return callback(rating);
};
