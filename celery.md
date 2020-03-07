# celery

Task Manager und scheduler

## Installation

Installation mit pip

`pip install Celery`

## Celery Benutzen

Datei _tasks.py_ erstellen.

```py
from celery import Celery

app = Celery('tasks', broker='pyamqp://guest@localhost//')

@app.task
def add(x, y):
    return x + y
```

Worker server Starten

`celery -A tasks worker --loglevel=info`


* [](http://www.celeryproject.org/)