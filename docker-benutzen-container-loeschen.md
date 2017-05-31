We can delete a container permanently, but before that we have to stop the container or use the force option. In this recipe, we'll start, stop, and delete a container.
Getting ready

Make sure the Docker daemon is running on the host and you can connect through the Docker client. You will also need some containers in a stopped or running state to delete them.

### How to do it…

1. Verwenden Sie den folgenden Befehl:
`$ docker rm [ OPTIONS ] CONTAINER [ CONTAINER ]`

2. Lassen Sie uns zuerst einen Container starten, stoppen Sie ihn und löschen Sie ihn dann mit den folgenden Befehlen:
```
$ ID='docker run -d -i fedora /bin/bash '
$ docker stop $ID
$ docker rm $ID
```

Wie wir aus dem vorherigen Screenshot sehen können, ist der Container nicht aufgetaucht, der gerade nach dem Stoppen des `docker-ps` Befehls eingetreten ist. Wir mussten die Option `-a` zur Verfügung stellen. Nachdem der Container gestoppt ist, können wir ihn löschen.

### Es gibt mehr…

* Um einen Behälter ohne Zwischenstopp endgültig zu löschen, verwenden Sie die Option `-f`.

* Um alle Container zu löschen, müssen wir zunächst alle laufenden Container stoppen und diese dann entfernen. Sei vorsichtig vor dem Ausführen der Befehle, da diese sowohl die laufenden als auch die gestoppten Container löschen werden:
```
$ docker stop 'docker ps -q'
$ docker rm 'docker ps -aq'
```
* Es gibt Optionen, um einen bestimmten Link und die mit dem Container verknüpften Volumes zu entfernen, die wir später erforschen werden.

### Wie es funktioniert…

Der Docker-Daemon entfernt die  read/write Schicht, die beim Starten des Containers erstellt wurde.