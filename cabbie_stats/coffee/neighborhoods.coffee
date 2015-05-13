define ['jquery', 'd3'], ($, d3) ->
    baseUrl = '/taxi-analysis/cabbie_stats/data'

    neighborhoodPlot = () ->
        w = 1280
        h = 800
        projection = d3.geo.mercator().center([
          -98
          38
        ]).scale(700).translate([
          640
          360
        ])
        path = d3.geo.path().projection(projection)
        svg = d3.select('body').insert('svg:svg', 'h2').attr('width', w).attr('height', h)
        states = svg.append('svg:g').attr('id', 'states')
        circles = svg.append('svg:g').attr('id', 'circles')
        cells = svg.append('svg:g').attr('id', 'cells')
        d3.select('input[type=checkbox]').on 'change', ->
          cells.classed 'voronoi', @checked
          return
        d3.json 'http://mbostock.github.io/d3/talk/20111116/us-states.json', (collection) ->
          states.selectAll('path').data(collection.features).enter().append('svg:path').attr 'd', path
          return
        d3.csv '/taxi-analysis/cabbie_stats/data/flights-airport.csv', (flights) ->
          linksByOrigin = {}
          countByAirport = {}
          locationByAirport = {}
          positions = []
          arc = d3.geo.greatArc().source((d) ->
            locationByAirport[d.source]
          ).target((d) ->
            locationByAirport[d.target]
          )
          flights.forEach (flight) ->
            origin = flight.origin
            destination = flight.destination
            links = linksByOrigin[origin] or (linksByOrigin[origin] = [])
            links.push
              source: origin
              target: destination
            countByAirport[origin] = (countByAirport[origin] or 0) + 1
            countByAirport[destination] = (countByAirport[destination] or 0) + 1
            return
          d3.csv "#{baseUrl}/airports.csv", (airports) ->
            # Only consider airports with at least one flight.
            airports = airports.filter((airport) ->
              if countByAirport[airport.iata]
                location = [
                  +airport.longitude
                  +airport.latitude
                ]
                locationByAirport[airport.iata] = location
                positions.push projection(location)
                return true
              return
            )
            # Compute the Voronoi diagram of airports' projected positions.
            polygons = d3.geom.voronoi(positions)
            g = cells.selectAll('g').data(airports).enter().append('svg:g')
            g.append('svg:path').attr('class', 'cell').attr('d', (d, i) ->
              'M' + polygons[i].join('L') + 'Z'
            ).on 'mouseover', (d, i) ->
              d3.select('h2 span').text d.name
              return
            g.selectAll('path.arc').data((d) ->
              linksByOrigin[d.iata] or []
            ).enter().append('svg:path').attr('class', 'arc').attr 'd', (d) ->
              path arc(d)
            circles.selectAll('circle').data(airports).enter().append('svg:circle').attr('cx', (d, i) ->
              positions[i][0]
            ).attr('cy', (d, i) ->
              positions[i][1]
            ).attr('r', (d, i) ->
              Math.sqrt countByAirport[d.iata]
            ).sort (a, b) ->
              countByAirport[b.iata] - (countByAirport[a.iata])
            return
          return

        # ---
        # generated by js2coffee 2.0.4

    neighborhoodPlot()