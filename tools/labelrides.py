import http.client
import urllib.parse

from apiclient.discovery import build
from oauth2client.client import SignedJwtAssertionCredentials

with open('keys/bigqueryid.key', 'r') as f:
	PROJECT_ID = f.read().replace('\n','')

with open('keys/service.email', 'r') as f:
	SERVICE_ACCOUNT_EMAIL = f.read().replace('\n','')

with open('keys/googlekey.p12', 'rb') as f:
	key = f.read();

credentials = SignedJwtAssertionCredentials(
	SERVICE_ACCOUNT_EMAIL,
	key,
	scope='https://www.googleapis.com/auth/bigquery')

url = 'www.googleapis.com'
queryurl = '/bigquery/v2/projects/' + PROJECT_ID + '/queries'
conn = http.client.HTTPSConnection(url)
conn = credentials.authorize(conn)

#headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
#params = {'projectId' : PROJECT_ID}
#params = urllib.parse.urlencode(params)
#body = 'SELECT * FROM [taxi_dataset:squares] LIMIT 100'

#conn.request("POST", queryurl, params, headers)
#response = conn.getresponse()
#print(response.status, response.reason)
#print(response.read())