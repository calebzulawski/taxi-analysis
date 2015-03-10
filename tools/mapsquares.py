import sys
import urllib.request
import urllib.parse
import json
import polyline

## Descend streeteasy json structure ##
def descend(jsonobj):
	result = {}
	parent = jsonobj['path']

	if (len(jsonobj['descendents']) == 0) and ('boundary_encoded_points_string' in jsonobj):
		result[jsonobj['path']] = {}
		result[jsonobj['path']]['path'] = parent
		result[jsonobj['path']]['title'] = jsonobj['title']
		result[jsonobj['path']]['subtitle'] = jsonobj['subtitle']
		result[jsonobj['path']]['name'] = jsonobj['name']
		result[jsonobj['path']]['city'] = jsonobj['city']
		result[jsonobj['path']]['state'] = jsonobj['state']
		result[jsonobj['path']]['boundary'] = polyline.decode(jsonobj['boundary_encoded_points_string'])
	for descendent in jsonobj['descendents']:
		deeper = descend(descendent)
		result.update(deeper)
	return result

## MAIN ##
lat_spacing = sys.argv[1]
long_spacing = sys.argv[2]
filename = sys.argv[3]

url = "http://streeteasy.com/nyc/api/areas/deep_info?id=1&key=ba43ddbbde3634728c16ebda0190d62c74ff8dd7&format=json"
response = urllib.request.urlopen(url)
response_str = response.readall().decode('utf-8')
data = json.loads(response_str)
neighborhoods = descend(data)

print(len(neighborhoods))