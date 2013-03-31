module.exports = function getRaceMeeting(hostname, relurl, callback) {
	var http = require('http'), 
	simplexml = require('xml-simple'),
	config = { 
		host: hostname,//'tatts.com', 
	    path: relurl,//'/pagedata/racing/2013/3/10/VR1.xml',
	    port:80
	 }, 
	 body= '';

	http.get(config, function( res ) {
		res.addListener('end', function() {
				simplexml.parse(body, function(e, parsed) {
					callback(parsed.Meeting);		
				});
		});
		res.setEncoding('utf8');
		res.on('data', function(d) {
			body+=d;
		});
	});

}