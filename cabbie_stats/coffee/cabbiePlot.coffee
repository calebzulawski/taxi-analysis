define [
	'd3'
], (D3) ->

	plot = (cabbie, avg, attr, container) ->
		buffer = 20
		svgContainer = d3.select(container).append("svg").attr("width", attr.width).attr("height", attr.height)
		circles = {}
		lines = {}
		extents =
			agility: 
				min:
					x: attr.width/2
					y: attr.height/2
				max:
					x: 0 + buffer
					y: 0 + buffer
			experience:
				min:
					x: attr.width/2
					y: attr.height/2
				max:
					x: attr.width - buffer
					y: 0 + buffer
			endurance:
				min:
					x: attr.width/2
					y: attr.height/2
				max:
					x: 0 + buffer
					y: attr.height - buffer
			satisfaction:
				min:
					x: attr.width/2
					y: attr.height/2
				max:
					x: attr.width - buffer
					y: attr.height - buffer

		lineFunction = d3.svg.line().x((d) ->
			d.x
		).y((d) ->
			d.y
		).interpolate('linear')

		keys = ["agility", "experience", "satisfaction", "endurance"]

		extentPoints = [
			{x: 0, y: 0},
			{x: attr.width, y: 0},
			{x: attr.width, y: attr.height},
			{x: 0, y: attr.height}
		]
		#background = svgContainer.append("path").attr("d", lineFunction(extentPoints)).attr("fill", "white")

		avgPoints = []
		for k in keys
			lines["axis_" + k] = svgContainer.append("line").attr("x1", extents[k].min.x).attr("x2", extents[k].max.x).attr("y1", extents[k].min.y).attr("y2", extents[k].max.y).attr("stroke-width", 2).attr("stroke", "black");
			x = extents[k].min.x + .5 * (extents[k].max.x - extents[k].min.x)
			y = extents[k].min.y + .5 * (extents[k].max.y - extents[k].min.y)
			avgPoints.push( {x: x, y: y} )
			circles["cabbie_" + k] = svgContainer.append("circle").attr("cx", x).attr("cy", y).attr("r",2)

		cabbiePolyAvg = svgContainer.append("path").attr("d", lineFunction(avgPoints)).attr("stroke", "black").attr("stroke-width", 2).attr("fill", D3.rgb 0,0,0).attr("opacity", 0.2)

		points = []
		for k in keys
			x = extents[k].min.x + cabbie[k] * (extents[k].max.x - extents[k].min.x)
			y = extents[k].min.y + cabbie[k] * (extents[k].max.y - extents[k].min.y)
			points.push( {x: x, y: y} )
			circles["cabbie_" + k] = svgContainer.append("circle").attr("cx", x).attr("cy", y).attr("r",2)

		cabbiePoly = svgContainer.append("path").attr("d", lineFunction(points)).attr("stroke", "black").attr("stroke-width", 2).attr("fill", D3.rgb 0,0,255).attr("opacity", 0.6)
	plot: plot