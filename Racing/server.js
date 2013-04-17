/**
 * Created with JetBrains WebStorm.
 * User: jstrydom
 * Date: 14/04/13
 * Time: 5:41 PM
 * To change this template use File | Settings | File Templates.
 */

var restify = require('restify');
var app = restify.createServer();
app.use(restify.acceptParser(['json', 'text/plain']));
app.use(restify.dateParser());
app.use(restify.queryParser());
app.use(restify.bodyParser());

var mongoose = require('mongoose');
var config = require('./config');
db = mongoose.connect(config.creds.url);
// Set up our routes and start the server


app.listen(8080, function() {
    console.log('%s listening at %s, love & peace', app.name, app.url);
});


module.exports.app = app;
routes = require('./routes');