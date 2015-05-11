#!/usr/bin/env python

import json
import sys
import csv

def driver_csv_to_json(fname):
	with open(fname,'r') as fp:
		with open(fname+'.json', 'w') as op:
			jsonObj = {}
			csvReader = csv.reader(fp, delimiter=',', quotechar='"')
			for row in csvReader:
				jsonObj[row[0]] = {'licensee': row[1], 'plate': row[4], 'vin': row[5], 'access': row[6], 'year': row[7], 'model': row[8], 'fleetType': row[9], 'agentNum': row[10], 'agentName': row[11], 'agentPhone': row[12]}
			op.write(json.dumps(jsonObj))
if __name__ == '__main__':
    driver_csv_to_json(sys.argv[1])