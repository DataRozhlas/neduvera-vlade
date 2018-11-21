var svgContainer = d3.select("#graf1").append("svg")
    .attr("width", "48vmax")
    .attr("height", "24vmax");

var circles = svgContainer.selectAll("circle")
    .data(data[1])
    .enter()
    .append("circle");

var circleAttributes = circles
    .attr("cx", function(d, i) {return Math.floor(i/10) * 2.4 + 1.2 + "vmax"})
    .attr("cy", function(d, i) {return (i % 10) * 2.4 + 1.2 + "vmax"})
    .attr("r", "1vmax")
    .style("fill", "black");

var trojuhelnicek = svgContainer
    .append("defs")
    .append("marker")
    .attr("id", "triangle")
    .attr("viewBox", "0 0 10 10")
    .attr("refX", 5)
    .attr("refY", 5)
    .attr("markerUnits", "strokeWidth")
    .attr("markerWidth", "0.85vmax")
    .attr("markerHeight", "0.85vmax")
    .attr("orient", "auto")
    .append("path")
    .attr("d", "M 0,0 L 10,5 L 0,10 z")
    .attr("fill", "#f00")

var puliciCara = svgContainer
    .append("polyline")
    .attr("points", function() {return svgContainer._groups[0][0].clientWidth/2 +  "," + (svgContainer._groups[0][0].clientHeight-5) + " " + svgContainer._groups[0][0].clientWidth/2 + ",5"})
    .attr("stroke", "black")
    .attr("fill", "none")
    .attr("marker-start", "url(#triangle)")
    .attr("stroke-dasharray", 2)