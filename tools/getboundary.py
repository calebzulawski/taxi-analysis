import urllib
import polyline
import json

def get(location,apikey):
	url = 'http://streeteasy.com/nyc/api/areas/info?id=' + location + '&key=' + apikey + '&format=json'
	response = urllib.urlopen(url)
	response_str = response.read().decode('utf-8')
	print(response_str)
	data = json.loads(response_str)
	print(data)
	return polyline.decode(data['boundary_encoded_points_string'])