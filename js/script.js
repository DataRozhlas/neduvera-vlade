var barvicky = {
    "KDU-ČSL": "#FFD700",
    "KSČM": "#ff0000",
    "ČSSD": "#E87B00",
    "ODS": "#034EA2",
    "US-DEU": "#006400",
    "Nezařaz": "#A9A9A9",
    "SZ": "#5C9C00",
    "VV": "#007FFF",
    "TOP09-S": "#551A8B",
    "ANO": "#ADD8E6",
    "Úsvit": "#c2910d"
};

var vyroky = {
    "A": "pro návrh",
    "B": "proti návrhu",
    "N": "proti návrhu",
    "C": "zdržel(a) se",
    "F": "nehlasoval(a)",
    "@": "nepřihlášen(a)",
    "M": "omluven(a)",
    "K": "zdržel(a) se/nehlasoval(a)"
};

var vmax = Math.max(window.innerWidth, window.innerHeight)/100;

var tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style('opacity', 0)
    .style('position', 'absolute')
    .style('padding', '0 10px');

var svgContainer = d3.select("#graf1").append("svg")
    .attr("width", 52.2 * vmax)
    .attr("height", 27 * vmax)
    .attr("class", "snemovnasvg");

function dataSort(data) {
    var dataNewOrder = poslSort( data.filter(function(el){return el.v === "A"}) )
    .concat( poslSort(data.filter(function(el){return !(/[NBA]/.test(el.v))})) )
    .concat( poslSort(data.filter(function(el){return /[NB]/.test(el.v)})).reverse() );

    function poslSort(arr) {
        var subgrpsizes = {};
        arr.forEach(function(el) {
            subgrpsizes.hasOwnProperty(el.k) ? subgrpsizes[el.k]++ : subgrpsizes[el.k] = 1
        });

        var sizeOrder = Object.keys(subgrpsizes).sort(function(a,b){
            return subgrpsizes[a] < subgrpsizes[b] ? 1 : -1
        });

        arr.sort(function(a,b) {
            return sizeOrder.indexOf(a.k) > sizeOrder.indexOf(b.k) ? 1 : -1
        });

        return arr
    }

    return dataNewOrder
}

var circles = svgContainer.selectAll("circle")
    .data(dataSort(data[1]))
    .enter()
    .append("circle")
    .attr("cx", function(d, i) {return (Math.floor(i/10) * 2.6 + 1.4) * vmax})
    .attr("cy", function(d, i) {return ((i % 10) * 2.6 + 1.4) * vmax})
    .attr("r", 1 * vmax)
    .attr("stroke", function(d, i) {return barvicky[d.k]})
    .attr("stroke-width", 0.35 * vmax)
    .attr("fill", function(d, i) {if (d.v=="A") {return "black"} else if (d.v=="B"|d.v=="N") {return "white"} else {return "silver"}})
    .on("mouseover", function(d) {
        tooltip.transition()
            .style('opacity', .9)
            .style('background', '#ddd')
            .style('font-family', 'sans-serif')
            .style('font-size', '12px')
            .style('font-weight', 'bold')
            .style('pointer-events', 'none')
            .text(d.p + ' ' + d.j + ", " + d.k + ": " + vyroky[d.v])
            .style('left', (d3.event.pageX - 35) + 'px')
            .style('top', (d3.event.pageY - 30) + 'px')
            .duration(100);
        })
    .on("mouseout",function(d) {
        tooltip.transition()
            .style("opacity", "0")
            .duration(50);
        });

var trojuhelnicek = svgContainer
    .append("defs")
    .append("marker")
    .attr("id", "triangle")
    .attr("viewBox", "0 0 10 10")
    .attr("refX", 5)
    .attr("refY", 5)
    .attr("markerUnits", "strokeWidth")
    .attr("markerWidth", 0.85 * vmax)
    .attr("markerHeight", 0.85 * vmax)
    .attr("orient", "auto")
    .append("path")
    .attr("d", "M 0,0 L 10,5 L 0,10 z")
    .attr("fill", "#f00")

var svgWidth = document.getElementsByClassName('snemovnasvg')[0].getAttribute("width");
var svgHeight = document.getElementsByClassName('snemovnasvg')[0].getAttribute("height");

var puliciCara = svgContainer
    .append("polyline")
    .attr("points", function() {return svgWidth/2 +  "," + (svgHeight-5) + " " + svgWidth/2 + ",5"})
    .attr("stroke", "black")
    .attr("fill", "none")
    .attr("marker-start", "url(#triangle)")
    .attr("stroke-dasharray", 2)