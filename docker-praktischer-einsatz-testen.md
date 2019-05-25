Während der Entwicklung oder QA, wird es hilfreich sein, wenn wir unseren Code gegen verschiedene Umgebungen überprüfen können. Zum Beispiel können wir unseren Python-Code zwischen verschiedenen Versionen von Python oder auf verschiedenen Distributionen wie Fedora, Ubuntu, CentOS und so weiter überprüfen. Für dieses Rezept, werden wir Pick-Code aus Flask's GitHub Repository, das ist ein Mikroframework für Python (http://flask.pocoo.org/). Ich wählte dieses, um die Dinge einfach zu halten, und es ist einfacher, für andere Rezepte auch zu verwenden.

Für dieses Rezept werden wir Bilder erstellen, um einen Container mit Python 2.7 und anderen mit Python 3.3 zu haben. Wir verwenden dann einen Beispiel-Python-Testcode, der gegen jeden Container ausgeführt wird.

### Fertig werden

* Da wir den Beispielcode aus dem GitHub-Repository von Flask verwenden, lass uns es klonen:
`$ git clone https://github.com/mitsuhiko/flask`

* Erstellen Sie eine Dockerfile_2.7-Datei wie folgt und erstellen Sie dann ein Bild:
```
$ cat /tmp/ Dockerfile_2.7
FROM python:2.7 
RUN pip install flask 
RUN pip install pytest 
WORKDIR /test 
CMD ["/usr/local/bin/py.test"] 
```

* Um das `python2.7test` Bild zu erstellen, führen Sie den folgenden Befehl aus:
`$ docker build -t python2.7test - < /tmp/Dockerfile_2.7`

* Ebenso erstellen Sie eine Dockerfile mit `python:3.3` als Basisbild und bauen das `python3.3test` Bild:
```
$ cat /tmp/Dockerfile_3.3
FROM python:3.3 
RUN pip install flask 
RUN pip install pytest 
WORKDIR /test 
CMD ["/usr/local/bin/py.test"]
```

* Um das Bild zu erstellen, führen Sie den folgenden Befehl aus:
`$ docker build -t python3.3test  - < /tmp/Dockerfile_3.3`

* Stellen Sie sicher, dass beide Bilder erstellt werden.

`docker images`


## Wie es geht…

Nun, mit Docker's Volume-Funktion, werden wir das externe Verzeichnis, das den Quellcode und Testfälle enthält montieren. Um mit Python 2.7 zu testen, gehen Sie wie folgt vor:

1. Gehen Sie zu dem Verzeichnis, das die Flask-Beispiele enthält:
`$ cd /tmp/flask/examples/`

2. Starten Sie einen Container mit dem `python2.7` Testbild und montieren Sie `blueprintexample` unter `/test`:
`$ docker run -d -v `pwd`/blueprintexample:/test python2.7test`
`pwd`

3. Ähnlich, um mit Python 3.3 zu testen, führen Sie den folgenden Befehl aus:
`$ docker run -d -v `pwd`/blueprintexample:/test python3.3test`

4. Beim Ausführen des vorherigen Tests auf `Fedora/RHEL/CentOS`, bei dem SELinux aktiviert ist, erhältst du einen `Permission Denied-Fehler`. Um es zu reparieren, muss das Host-Verzeichnis zugewiesen , es kann in dem Container wie folgt eingerichtet wird:
```
$ docker run -d -v `pwd`/blueprintexample:/test:z python2.7test
```

### Wie es funktioniert…

Wie Sie aus der Dockerfile sehen können, bevor Sie CMD laufen, das die `py.test` binary läuft, ändern wir unser Arbeitsverzeichnis zu `/test`. Und beim Starten des Containers ändern wir unseren Quellcode zu `/testen`. Also, sobald der Container beginnt, wird die `py.test` Binär datei laufen und Tests ausführen.

### Es gibt mehr…

* In diesem Rezept haben wir gesehen, wie wir unseren Code mit verschiedenen Versionen von Python testen können. Ebenso können Sie verschiedene Basisbilder von Fedora, CentOS, Ubuntu abholen und sie auf verschiedenen Linux-Distributionen testen.

* Wenn du Jenkins in deiner Umgebung einsetzt, kannst du sein Docker-Plugin verwenden, um einen Slave dynamisch bereitzustellen, einen Build auszuführen und ihn auf den Docker-Host zu auszuführen. Weitere Details dazu finden Sie unter https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin.

