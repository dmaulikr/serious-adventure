function getResults(race) {
var processPlacing = require('./processplacing'),
    simpleXml = require('xml-simple'),
    mongoose = require('mongoose');
	var pos = [];
	try {
		var runners = race.Runner;
		var results = race.ResultPlace;
		results.forEach(function(res) {
			//console.log(result);
			switch (res.$.PlaceNo) {
				case '1':
					pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '1'});
					break;
				case '2':
					pos.push({'runnerNo':res.Result[0].$.RunnerNo, 'place': '2'});
					break;
				case '3':
					pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '3'});
					break;
				case '4':
					pos.push({ 'runnerNo':res.Result[0].$.RunnerNo, 'place': '4' });					 
					break;
			}
		});
		
		runners.forEach(function(runner){
			var place = null;
			var r = runner.$.RunnerNo;
			for(var i = 0; i < pos.length ; i++) {
				var p = pos[i].runnerNo ;
				found = true;
				if(r === p ) {
					place = pos[i];
					break;
				}
			};
			processPlacing(runner, place);

		});
	}
	catch (e) {
		console.log(e);
		
	}
	
}
