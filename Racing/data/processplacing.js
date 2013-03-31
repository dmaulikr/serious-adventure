
module.exports = function processPlacing(r, p) {
	var postUpdates = require('./postupdates');
	try {
		var rider = '';
		var isapprentice = false;
	    
	    var j = r.$.Rider || '';
	    var hupd;
	    var rupd;

	   	if(j && j.indexOf("(") === -1) {
			rider =  j ;
			isapprentice = false;
		} else if(j && j.indexOf("(") > 0) {
			rider = j.substr(0,j.indexOf('('));
			isapprentice : true ;
		}
		var hq = { name : r.$.RunnerName };
	 	var rq = { name : rider };


		if(p !== null) {
			if(p.place === '1') {
		    	hupd = { name : r.$.RunnerName, $inc :{ totalRuns: 1, firsts : 1 }}; 
		    	rupd = { name : rider, apprentice: isapprentice, $inc : { totalRuns: 1, firsts : 1 }};
		    } else if(p.place === '2') {	
				hupd = { name : r.$.RunnerName, $inc :{ totalRuns: 1, seconds : 1 }}; 
		    	rupd = { name : rider, apprentice: isapprentice, $inc : { totalRuns: 1, seconds : 1 }};
			} else if(p.place === '3') {
				hupd = { name : r.$.RunnerName, $inc :{ totalRuns: 1, thirds : 1 }}; 
		    	rupd = { name : rider, apprentice: isapprentice, $inc : { totalRuns: 1, thirds : 1 }};
			} else if(p.place === '4') {
				hupd = { name : r.$.RunnerName, $inc :{ totalRuns: 1, fourths : 1 }}; 
		    	rupd = { name : rider, apprentice: isapprentice, $inc : { totalRuns: 1, fourths : 1 }};
			}
		} else {
			if(r.$.Scratched === 'N') {
				hupd = { name : r.$.RunnerName, $inc :{ totalRuns: 1 }}; 
		    	rupd = { name : rider, apprentice: isapprentice, $inc : { totalRuns: 1 }};
			} else {
				hq = null;
				rq = null;
				//console.log(r.$.RunnerName+' not a runner');
			}
		}
		if (hq !== null && rq !== null)
			postUpdates(hq, rq, hupd, rupd);	
	} catch (e) {
		console.log(e);
	}				
};
