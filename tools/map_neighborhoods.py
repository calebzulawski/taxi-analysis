import csv
import json
import polyline

with open('boundaries.csv', mode='r') as csvfile:
	reader = csv.reader(csvfile)
	neighborhood_dict = {rows[0]:rows[1:] for rows in reader}

polygons = []
for key, value in neighborhood_dict.items():
	polygon = []
	boundary = polyline.decode(value[1])
	for coords in boundary:
		polygon.append({'latitude': coords[1], 'longitude': coords[0]})
	polygons.append({'id': key, 'label': value[2], 'fill': { 'color': '#000000', 'opacity': 0}, 'stroke': {'color': '#000000', 'weight': 3, 'opacity': 1}, 'path': polygon})

jsonobj = {'title': 'Neighborhood Boundaries', 'polygons': polygons}

with open('boundaries.json', 'w') as fp:
	json.dump(jsonobj, fp)
