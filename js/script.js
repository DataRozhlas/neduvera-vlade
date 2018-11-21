var svgContainer = d3.select("#graf1").append("svg")
                                    .attr("width", "48vmax")
                                    .attr("height", "24vmax");

var circles = svgContainer.selectAll("circle")
    .data(data[1])
    .enter()
    .append("circle");

var circleAttributes = circles
    .attr("cx", function(d, i) {return Math.floor(i/10) * 2.4 + 1 + "vmax"})
    .attr("cy", function(d, i) {return (i % 10) * 2.4 + 1 + "vmax"})
    .attr("r", "1vmax")
    .style("fill", "black");