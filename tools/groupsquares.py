import json
import csv

with open('../webapp/json/squares.json','r') as fp:    
    squaresJson = json.load(fp)

districts = [0]*600

with open('squaresBigQuery.csv','w') as csvfile:
	csvwriter = csv.writer(csvfile)
	csvwriter.writerow(['id', 'neighborhood, center_lat, center_long'])
	for square in squaresJson['squares']:
		row = [square['id'], square['neighborhood'], square['center_lat'], square['center_long']]
		csvwriter.writerow(row)
		path = [{'latitude': square['min_lat'], 'longitude': square['min_long']}, {'latitude': square['min_lat'], 'longitude': square['max_long']},{'latitude': square['max_lat'], 'longitude': square['max_long']},{'latitude': square['max_lat'], 'longitude': square['min_long']}]
		if districts[square['neighborhood']] == 0:
			districts[square['neighborhood']] = { 'neighborhood': square['neighborhood'], 'squares': [{'id': square['id'], 'path': path }] }
		else:
			districts[square['neighborhood']]['squares'].append({'id': square['id'], 'path': path })

with open('squaresByDistrict.json','w') as fp:
	json.dump({'districts': districts},fp)