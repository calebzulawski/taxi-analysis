import sys
import urllib.request
import urllib.parse
import json
import polyline
import csv
import numpy as np

# Check if point is in polygon
def point_in_polygon(x,y,poly):
	n = len(poly)
	inside = False
	p1x,p1y = poly[0]
	for i in range(n+1):
		p2x,p2y = poly[i % n]
		if y > min(p1y,p2y):
			if y <= max(p1y,p2y):
				if x <= max(p1x,p2x):
					if p1y != p2y:
						xinters = (y-p1y)*(p2x-p1x)/(p2y-p1y)+p1x
					if p1x == p2x or x <= xinters:
						inside = not inside
		p1x,p1y = p2x,p2y
	return inside

## MAIN ##
#lat_spacing = float(sys.argv[1])
#long_spacing = float(sys.argv[2])
lat_spacing = 0.001
long_spacing = 0.001

# with open('keys/streeteasy.key', 'r') as f:
# 	apikey = f.read().replace('\n','')

# url = "http://streeteasy.com/nyc/api/areas/deep_info?id=1&key=" + apikey + "&format=json"
# response = urllib.request.urlopen(url)
# response_str = response.readall().decode('utf-8')
# data = json.loads(response_str)
# neighborhoods = descend(data)

# Give neighborhoods unique numeric ids
# for key in neighborhoods:
# 	neighborhoods[key]['id'] = list(neighborhoods.keys()).index(key)

with open('../webapp/json/community_districts.geojson','r') as fp:    
    districtsJson = json.load(fp)

min_lat = 40.65
max_lat = 40.65
min_long = -73.9
max_long = -73.9
for feature in districtsJson['features']:
	if feature['geometry']['type'] is 'Polygon':
		for pos in feature['geometry']['coordinates'][0]:
			if pos[1] < min_lat:
				min_lat = pos[1]
			if pos[1] > max_lat:
				max_lat = pos[1]
			if pos[0] < min_long:
				min_long = pos[0]
			if pos[0] > max_long:
				max_long = pos[0]
	elif feature['geometry']['type'] is 'MultiPolygon':
		for polygon in feature['geometry']['coordinates']:
			for pos in polygon[0]:
				if pos[1] < min_lat:
					min_lat = pos[1]
				if pos[1] > max_lat:
					max_lat = pos[1]
				if pos[0] < min_long:
					min_long = pos[0]
				if pos[0] > max_long:
					max_long = pos[0]

min_lat = round(min_lat,3) - 0.0015
max_lat = round(max_lat,3) + 0.0015
min_long = round(min_long,3) - 0.0015
max_long = round(max_long,3) + 0.0015

squares = []
square_id = 0;
squaresArray
for slat in np.arange(min_lat-lat_spacing,max_lat,lat_spacing):
	for slong in np.arange(min_long-long_spacing,max_long,long_spacing):
		for feature in districtsJson['features']:
			numpts = 0	
			if feature['geometry']['type'] is 'Polygon':
				# Check center only
				if point_in_polygon(slong+(long_spacing/2),slat+(lat_spacing/2),feature['geometry']['coordinates'][0]):
					numpts += 1
			elif feature['geometry']['type'] is 'MultiPolygon':
				for polygon in feature['geometry']['coordinates']:
					if point_in_polygon(slong+(long_spacing/2),slat+(lat_spacing/2),polygon[0]):
						numpts += 1
			if numpts >= 1:
					squares.append({'id':square_id, 'min_lat': slat, 'max_lat': slat+lat_spacing, 'min_long': slong, 'max_long': slong+long_spacing, 'center_lat': slat+(lat_spacing/2), 'center_long': slong+(long_spacing/2) 'neighborhood': feature['properties']['BoroCD']})
					square_id += 1
					break
with open('squares.json','w') as fp
	json.dump({'squares': squaresArray},fp)

# Make CSVs
# print('Making CSV files')
# with open('neighborhoods.csv','w') as csvfile:
# 	csvwriter = csv.writer(csvfile)
# 	csvwriter.writerow(['id', 'path', 'title', 'subtitle', 'name', 'city', 'state'])
# 	for key in neighborhoods:
# 		csvwriter.writerow([ neighborhoods[key]['id'], neighborhoods[key]['path'], neighborhoods[key]['title'], neighborhoods[key]['subtitle'], neighborhoods[key]['name'], neighborhoods[key]['city'], neighborhoods[key]['state'] ])

# with open('squares.csv','w') as csvfile:
# 	csvwriter = csv.writer(csvfile)
# 	csvwriter.writerow(['id', 'min_lat', 'max_lat', 'min_long', 'max_long', 'neighborhood'])
# 	for ind in range(len(squares)):
# 		csvwriter.writerow([squares[ind]['id'], squares[ind]['min_lat'], squares[ind]['max_lat'], squares[ind]['min_long'], squares[ind]['max_long'], squares[ind]['neighborhood']])