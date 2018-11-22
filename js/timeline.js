var testData = [
	{class: "circ",
		times: [
			// neuspesne neduvery
			{"starting_time": 1064534400000, "display": "circle", "desc": "26. září 2003 – neúspěšný pokus"},
			{"starting_time": 1112313600000, "display": "circle", "desc": "1. dubna 2005 – neúspěšný pokus"},
			{"starting_time": 1182297600000, "display": "circle", "desc": "20. června 2007 – neúspěšný pokus"},
			{"starting_time": 1196812800000, "display": "circle", "desc": "5. prosince 2007 – neúspěšný pokus"},
			{"starting_time": 1209513600000, "display": "circle", "desc": "30. dubna 2008 – neúspěšný pokus"},
			{"starting_time": 1224633600000, "display": "circle", "desc": "22. října 2008 – neúspěšný pokus"},
			{"starting_time": 1292889600000, "display": "circle", "desc": "21. prosince 2010 – neúspěšný pokus"},
			{"starting_time": 1303776000000, "display": "circle", "desc": "26. dubna 2011 – neúspěšný pokus"},
			{"starting_time": 1332201600000, "display": "circle", "desc": "20. března 2012 – neúspěšný pokus"},
			{"starting_time": 1342569600000, "display": "circle", "desc": "18. července 2012 – neúspěšný pokus"},
			{"starting_time": 1358380800000, "display": "circle", "desc": "17. ledna 2013 – neúspěšný pokus"},
			{"starting_time": 1432598400000, "display": "circle", "desc": "26. května 2015 – neúspěšný pokus"},
            {"starting_time": 1542927600000, "display": "circle", "id": "nevime", "desc": "23. listopadu 2018 – dnešní pokus"},
			// uspesna
			{"starting_time": 1237852800000, "display": "circle", "id": "succ", "desc": "24. března 2009 – úspěšný pokus"}]}
	,
	{class: "vlady",
		times: [
			{"starting_time": 710035200000, "ending_time": 836438400000, "color": d3.schemeCategory10[0], "desc": "první vláda Václava Klause"},
			{"starting_time": 836438400000, "ending_time": 883699200000, "color": d3.schemeCategory10[0], "desc": "druhá vláda Václava Klause"},
			{"starting_time": 883699200000, "ending_time": 901065600000, "color": d3.schemeCategory10[1], "desc": "vláda Josefa Tošovského"},
			{"starting_time": 901065600000, "ending_time": 1026691200000, "color": d3.schemeCategory10[2], "desc": "vláda Miloše Zemana"},
			{"starting_time": 1026691200000, "ending_time": 1081382400000, "color": d3.schemeCategory10[3], "desc": "vláda Vladimíra Špidly"},
			{"starting_time": 1081382400000, "ending_time": 1114387200000, "color": d3.schemeCategory10[4], "desc": "vláda Stanislava Grosse"},
			{"starting_time": 1114387200000, "ending_time": 1157328000000, "color": d3.schemeCategory10[5], "desc": "vláda Jiřího Paroubka"},
			{"starting_time": 1157328000000, "ending_time": 1168300800000, "color": d3.schemeCategory10[6], "desc": "první vláda Mirka Topolánka"},
			{"starting_time": 1168300800000, "ending_time": 1249430400000, "color": d3.schemeCategory10[6], "desc": "druhá vláda Mirka Topolánka"},
			{"starting_time": 1249430400000, "ending_time": 1278979200000, "color": d3.schemeCategory10[7], "desc": "vláda Jana Fischera"},
			{"starting_time": 1278979200000, "ending_time": 1373414400000, "color": d3.schemeCategory10[8], "desc": "vláda Petra Nečase"},
			{"starting_time": 1373414400000, "ending_time": 1390953600000, "color": d3.schemeCategory10[9], "desc": "vláda Jiřího Rusnoka"},
			{"starting_time": 1390953600000, "ending_time": 1513123200000, "color": d3.schemeCategory10[0], "desc": "vláda Bohuslava Sobotky"},
			{"starting_time": 1513123200000, "ending_time": 1530057600000, "color": d3.schemeCategory10[1], "desc": "vrvní vláda Andreje Babiše"},
			{"starting_time": 1530057600000, "ending_time": 1542927600000, "color": d3.schemeCategory10[1], "desc": "druhá vláda Andreje Babiše"}
		]}
];

var chart = d3.timelines().stack().mouseover(function (d) {
	tooltip.transition()
		.style("opacity", .9)
		.style("background", "#ddd")
		.style("font-family", "sans-serif")
		.style("font-size", "12px")
		.style("font-weight", "bold")
		.style("pointer-events", "none")
		.text(d.desc)
		.style("left", (d3.event.pageX - 35) + "px")
		.style("top", (d3.event.pageY - 30) + "px")
		.duration(100);
}).mouseout(function(){
	tooltip.transition()
		.style("opacity", "0")
		.duration(50);
});

var svg = d3.select("#timeline1").append("svg").attr("width", "100%")
	.datum(testData).call(chart);