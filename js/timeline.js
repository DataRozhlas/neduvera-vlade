var testData = [
    // neuspesne neduvery
    {class: "succ",
    times: [{"starting_time": 1237852800000, "display": "circle"}]},
    {class: "fail",
    times: [
        {"starting_time": 1064534400000, "display": "circle"},
        {"starting_time": 1112313600000, "display": "circle"},
        {"starting_time": 1182297600000, "display": "circle"},
        {"starting_time": 1196812800000, "display": "circle"},
        {"starting_time": 1209513600000, "display": "circle"},
        {"starting_time": 1224633600000, "display": "circle"},
        {"starting_time": 1292889600000, "display": "circle"},
        {"starting_time": 1303776000000, "display": "circle"},
        {"starting_time": 1332201600000, "display": "circle"},
        {"starting_time": 1358380800000, "display": "circle"},
        {"starting_time": 1432598400000, "display": "circle"},
    ]},
    {times: [{"starting_time": 1355761910000, "ending_time": 1356863910000}]},
  ];

var chart = d3.timelines().beginning(725846400000);

var svg = d3.select("#timeline1").append("svg").attr("width", 500)
	.datum(testData).call(chart);