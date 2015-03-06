import sqlite3
import sys
import csv
from os import listdir

def is_number(s):
	try:
		float(s)
		return True
	except ValueError:
		return False

if len(sys.argv) < 3:
	print('Usage: csv2db.py csvfolder file.db')
	sys.exit(0)

csvfolder = sys.argv[1]
dbfile = sys.argv[2]
csvfiles = listdir(csvfolder)

conn = sqlite3.connect(dbfile)
c = conn.cursor()

# Get headers and types
col_type = [];
with open(csvfolder + csvfiles[0],'r') as f:
	headers = f.readline()
	headers = headers.rstrip('\n')
	headers = headers.split(',')
	print(headers)
	testrow = f.readline()
	testrow = testrow.rstrip('\n')
	testrow = testrow.split(',')
	for s in testrow:
		if is_number(s):
			col_type.append('real')
		else:
			col_type.append('text')



# Create table
query = 'CREATE TABLE data\n('
for idx in range(len(headers)):
	query += headers[idx] + ' ' + col_type[idx]
	if idx < len(headers)-1:
		query += ', '
	else:
		query += ')'
c.execute(query)

for csvfilename in csvfiles:
	print(csvfilename)
	with open(csvfolder + csvfilename) as csvfile:
		reader = csv.reader(csvfile)
		next(reader,None) # skip headers
		for row in reader:
			r = []
			query = 'INSERT INTO data VALUES ('
			try:
				for idx in range(len(headers)):
					if col_type[idx] == 'text':
						r.append(row[idx])
					else:
						r.append(float(row[idx]))
					if idx < len(headers)-1:
						query += '?,'
					else:
						query += '?)'
				r = tuple(r)
				c.execute(query,r)
			except ValueError:
				continue
		conn.commit()

conn.close();