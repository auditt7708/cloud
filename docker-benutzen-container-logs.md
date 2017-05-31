Wenn der Container Protokolle ausgibt oder auf `STDOUT` / `STDERR` ausgibt, können wir sie ohne Anmeldung in den Container abrufen.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen. Sie benötigen auch einen laufenden Container, der Protokolle / Ausgabe auf `STDOUT` ausgibt.

### Wie es geht…

1. Um Protokolle aus dem Container zu erhalten, führen Sie den folgenden Befehl aus:
`docker logs [-f|--follow[=false]][-t|--timestamps[=false]] CONTAINER`

2. Nehmen wir das Beispiel aus dem früheren Abschnitt des Ausführens eines daemonisierten Containers und schauen Sie sich die Protokolle an:
`$ docker run -d  fedora /bin/bash -c  "while [ 1 ]; do echo hello docker ; sleep 1; done"`

### Wie es funktioniert…

Docker schaut auf die spezifische Protokolldatei des Containers aus `/var/lib/docker/containers/<Container ID>` und zeigt das Ergebnis an.

### Es gibt mehr…

Mit der Option `-t` können wir den Zeitstempel mit jeder Log-Linie bekommen und mit `-f` können wir ein solches Verhalten bekommen.

