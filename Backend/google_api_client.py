from apiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import datetime
from datetime import date


 
CLIENT_SECRET_FILE = "C:\\Users\\hp\\Desktop\\Flutter\\Backend\\client_secret_file.json"
API_NAME = 'tasks'
API_VERSION = 'v1'
SCOPES = ['https://www.googleapis.com/auth/tasks']

store = file.Storage('storage.json')
credz = store.get()
if not credz or credz.invalid:
    flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
    credz = tools.run_flow(flow, store)
 
service = build(API_NAME, API_VERSION, http = credz.authorize(Http()))
mainTasklistId = 'dVdwVlR0YmN4SlQzckQxRQ'
#retrive my tasks list 
def retrieve_list():
    response = service.tasklists().list().execute()
    lstItems = response.get('items')
    return lstItems

mainTasklistId = retrieve_list()[0]['id']
 
def convert_to_RFC_datetime(year=2021, month=1, day=1, hour=0, minute=0):
    dt = datetime.datetime(year, month, day, hour, minute, 0, 000).isoformat() + 'Z'
    return dt

def construct_request_body(title, notes=None, due=None, status='needsAction', deleted=False):
    try:
        request_body = {
        'title': title,
        'notes': notes,
        'due': due,
        'deleted': deleted,
        'status': status
        }
        return request_body
    except Exception:
        return None

def get_tasks(tasklist = mainTasklistId):
    tasks = {'past' : [], "due": []}
    response = service.tasks().list(
        tasklist=tasklist,
        dueMax=convert_to_RFC_datetime(2021, 12, 31),
        showCompleted=False).execute()
    lstItems = response.get('items')
    for i in lstItems:
        day = i['due'][:len(i['due']) -1][:10].split('-')
        bc = datetime.date(int(day[0]), int(day[1]),int(day[2]))
        if bc > date.today():
            tasks["due"].append(i)
        else:
            tasks['past'].append(i)
    return tasks

def add_task(title, month, day, year = 2021, tasklist = mainTasklistId):
    service.tasks().insert(
        tasklist=mainTasklistId,
        body=construct_request_body(title, due = convert_to_RFC_datetime(int(year), int(month), int(day)))
    ).execute()


def remove_task(task, tasklist = mainTasklistId):
    service.tasks().delete(
        tasklist = tasklist,
        task = task
    ).execute()

def complete_task(task, tasklist = mainTasklistId):
    service.tasks().update(
        tasklist = tasklist,
        task = task,
      )









