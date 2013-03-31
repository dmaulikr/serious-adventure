module.exports = function postUpdates(hq, rq, hupd, rupd) {
	var mongoose = require('mongoose');
	try {
		var opts = { upsert: true };
		var done = function(){}; 
		var done1 = function(){}; 
		if(hq !== null)
			Horse.findOneAndUpdate(hq, hupd, opts, done);
		if(rq !== null)
			Rider.findOneAndUpdate(rq, rupd, opts, done1); 
	} catch (e) {
		console.log(e);
	} 
};