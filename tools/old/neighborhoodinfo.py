import urllib.request
import urllib.parse
import json
import csv

# Descend streeteasy json structure
def descend(jsonobj,depth=0,maxdepth=3):
	result = {}
	parent = jsonobj['path']
	if ('boundary_encoded_points_string' in jsonobj):
		print(depth)
		result[jsonobj['path']] = {}
		result[jsonobj['path']]['path'] = parent
		result[jsonobj['path']]['title'] = jsonobj['title']
		result[jsonobj['path']]['subtitle'] = jsonobj['subtitle']
		result[jsonobj['path']]['name'] = jsonobj['name']
		result[jsonobj['path']]['boundary'] = jsonobj['boundary_encoded_points_string']
	elif depth < maxdepth:
		for descendent in jsonobj['descendents']:
			deeper = descend(descendent,depth=(depth+1),maxdepth=maxdepth)
			result.update(deeper)
	return result

with open('keys/streeteasy.key', 'r') as f:
	apikey = f.read().replace('\n','')

url = "http://streeteasy.com/nyc/api/areas/deep_info?id=1&key=" + apikey + "&format=json"
response = urllib.request.urlopen(url)
response_str = response.readall().decode('utf-8')
data = json.loads(response_str)
neighborhoods = descend(data,maxdepth=4)

for key in neighborhoods:
	neighborhoods[key]['id'] = list(neighborhoods.keys()).index(key)

with open('boundaries.csv','w') as csvfile:
	csvwriter = csv.writer(csvfile)
	csvwriter.writerow(['id', 'path', 'title', 'subtitle', 'name'])
	for key in neighborhoods:
		csvwriter.writerow([ neighborhoods[key]['id'], neighborhoods[key]['path'], neighborhoods[key]['boundary'], neighborhoods[key]['title'], neighborhoods[key]['subtitle'], neighborhoods[key]['name']])