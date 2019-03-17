# Docker API Client Remote

In den letzten Rezepten haben wir die von Docker bereitgestellten APIs untersucht, um den entfernten Docker-Daemon anzuschließen und Operationen durchzuführen. Die Docker-Community hat Bindungen für verschiedene Programmiersprachen hinzugefügt, um auf diese APIs zuzugreifen.
 [remote_api_client](https://docs.docker.com/reference/api/remote_api_client_libraries/) aufgeführt.

Beachten Sie, dass Docker Maintainer diese Bibliotheken nicht pflegen.
Lassen Sie uns Python-Bindungen mit ein paar Beispielen erkunden und sehen, wie es die Docker-Remote-API verwendet.

## Fertig werden

* Installiere docker-py auf Fedora:

`sudo yum install python-docker-py`

Alternativ verwenden Sie Pip, um das Paket zu installieren:

`sudo pip install docker-py`

## Importiren das Modul

```python
python
>>> import docker
```

## Wie es geht

1.Erstellen Sie den Client mit den folgenden Schritten:
1.1Verbinden Sie durch die Unix-Sockel:

`>>> client = docker.Client(base_url='unix://var/run/docker.sock', version='1.18',  timeout=10)`

1.2Connect über HTTP:

`>>> client = docker.Client(base_url='http://dockerhost.example.com:2375', version='1.18',  timeout=10)`

Hier ist base_url der Endpunkt zu verbinden, Version ist die API-Version, die der Client verwenden wird, und Timeout ist der Timeout-Wert in Sekunden.

2.Suche nach einem Image mit folgendem Code:

`>>> client.search ("fedora")`

3.Führen Sie ein Pull des Images mit folgendem Code durch:
`>>> client.pull("fedora", tag="latest")`

4.Starten Sie einen Container mit folgendem Code:

```sh
>>> client.create_container("fedora", command="ls", hostname=None, user=None, detach=False, stdin_open=False, tty=False, mem_limit=0, ports=None, environment=None, dns=None, volumes=None, volumes_from=None,network_disabled=False, name=None, entrypoint=None, cpu_shares=None, working_dir=None,memswap_limit=0)
```

## Wie es funktioniert

In allen vorangegangenen Fällen sendet das Docker-Python-Modul RESTful-Anfragen an den Endpunkt mit der von Docker bereitgestellten API. Schauen Sie sich die Methoden wie Suche, Pull, und starten Sie in den folgenden Code von [Docker-py](https://github.com/docker/docker-py/blob/master/docker/client.py).

## Es gibt mehr

Sie können verschiedene Benutzeroberflächen, die für Docker geschrieben wurden, erkunden. Einige von ihnen sind wie folgt:

* [Shipyard](http://shipyard-project.com/)- geschrieben in Python

* [DockerUI](https://github.com/crosbymichael/dockerui) - geschrieben in JavaScript mit AngularJS