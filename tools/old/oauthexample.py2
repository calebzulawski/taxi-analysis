import httplib2

from apiclient.discovery import build

from oauth2client.client import SignedJwtAssertionCredentials


with open('keys/bigqueryid.key', 'r') as f:
	PROJECT_ID = f.read().replace('\n','')
with open('keys/service.email', 'r') as f:
	SERVICE_ACCOUNT_EMAIL = f.read().replace('\n','')

with open('keys/googlekey.p12','rb') as f:
	key = f.read()

credentials = SignedJwtAssertionCredentials(
    SERVICE_ACCOUNT_EMAIL,
    key,
    scope='https://www.googleapis.com/auth/bigquery')

http = httplib2.Http()
http = credentials.authorize(http)

service = build('bigquery', 'v2')
datasets = service.datasets()
response = datasets.list(projectId=PROJECT_ID).execute(http)

print('Dataset list:\n')
for dataset in response['datasets']:
  print("%s\n" % dataset['id'])