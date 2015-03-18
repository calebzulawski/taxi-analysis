import urllib.request
import urllib.parse
import json
import csv

# Descend streeteasy json structure
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
		result[jsonobj['path']]['boundary'] = jsonobj['boundary_encoded_points_string']
	for descendent in jsonobj['descendents']:
		deeper = descend(descendent)
		result.update(deeper)
	return result

with open('keys/streeteasy.key', 'r') as f:
	apikey = f.read().replace('\n','')

url = "http://streeteasy.com/nyc/api/areas/deep_info?id=1&key=" + apikey + "&format=json"
response = urllib.request.urlopen(url)
response_str = response.readall().decode('utf-8')
data = json.loads(response_str)
neighborhoods = descend(data)

with open('neighborhoods-boundarys.csv','w') as csvfile:
	csvwriter = csv.writer(csvfile)
	csvwriter.writerow(['id', 'path', 'title', 'subtitle', 'name', 'city', 'state'])
	for key in neighborhoods:
		csvwriter.writerow([ neighborhoods[key]['id'], neighborhoods[key]['path'], neighborhoods[key]['boundary'], neighborhoods[key]['title'], neighborhoods[key]['subtitle'], neighborhoods[key]['name'], neighborhoods[key]['city'], neighborhoods[key]['state'] ])