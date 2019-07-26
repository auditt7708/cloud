# Docker Daten Verwalten

Alle ungebundenen Daten oder Änderungen in Containern gehen verloren, sobald Container gelöscht werden. Wenn Sie zum Beispiel die Docker-Registrierung in einem Container konfiguriert haben und einige Bilder gedrückt haben, sobald der Registry-Container gelöscht wird, werden alle Bilder verloren, wenn Sie sie nicht begangen haben. Auch wenn Sie begehen, ist es nicht die beste Praxis. Wir sollten versuchen, die Container so leicht wie möglich zu halten. Im Folgenden sind zwei primäre Möglichkeiten, Daten mit Docker zu verwalten:

* **Data volumes**: Aus der Docker-Dokumentation (https://docs.docker.com/userguide/dockervolumes/) ist ein Datenvolumen ein speziell benanntes Verzeichnis innerhalb eines oder mehrerer Container, die das Union-Dateisystem umgehen, um mehrere nützliche Funktionen für persistent zu bieten Oder geteilte Daten:

Volumes werden initialisiert, wenn ein Container erstellt wird. Wenn das Basisbild des Containers Daten am angegebenen Einhängepunkt enthält, werden diese Daten in das neue Volume kopiert.

* Datenmengen können gemeinsam genutzt und zwischen Containern wiederverwendet werden.

* Änderungen an einem Datenvolumen werden direkt vorgenommen.

* Änderungen an einem Datenvolumen werden nicht berücksichtigt, wenn Sie ein Image aktualisieren.

* Die Volumes bleiben bestehen, bis kein Container sie benutzt.

* Data volume containers: Wenn ein Datenträger fortbesteht, bis da Container verwendet wird, können wir das Volumen verwenden, um persistente Daten zwischen Containern zu teilen. So können wir einen benannten Volume Container erstellen und die Daten in einen anderen Container einbinden.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und dass Sie  über den Docker-Client eine Verbindung herstellen können.

## Wie es geht...

1.Fügen Sie ein Datenvolumen hinzu. Mit der Option `-v` und mit dem `docker run` -Befehl fügen wir dem Container ein Datenvolumen hinzu:
`$ docker run -t -d -P -v /data --name f20 fedora /bin/bash`

Wir können mehrere Datenmengen innerhalb eines Containers haben, die durch Addition von `-v` mehrfach erstellt werden können:

`$ docker run -t -d -P -v /data -v /logs --name f20 fedora /bin/bash`

## Tip

Die `VOLUME`-Anweisung kann in einer Dockerfile verwendet werden, um auch Datenvolumen hinzuzufügen, indem man etwas wie `VOLUME ["/data"]` einfügt.

Wir können den Befehl `inspect` verwenden, um die Datenmenge eines Containers zu betrachten:

```s
$ docker inspect -f "{{ .Config.Volumes }}" f20
$ docker inspect -f "{{ .Volumes }}" f20
```

Wenn das Zielverzeichnis nicht innerhalb des Containers ist, wird es erstellt.

2.Als nächstes hängen wir ein Host-Verzeichnis als Datenvolumen ein. Wir können auch ein Hostverzeichnis zu einem Datenvolumen mit der Option `-v` abbilden:

`$ docker run -i -t -v /source_on_host:/destination_on_container fedora /bin/bash`

Betrachten Sie das folgende Beispiel:
`$ docker run -i -t -v /srv:/mnt/code fedora /bin/bash`

Dies kann sehr nützlich sein in Fällen wie bei Testcode in verschiedenen Umgebungen, Sammeln von Protokollen an zentralen Standorten und so weiter. Wir können das Hostverzeichnis auch im schreibgeschützten Modus wie folgt abbilden:
`$ docker run -i -t -v /srv:/mnt/code:ro fedora /bin/bash`

Wir können das gesamte Root-Dateisystem des Hosts auch innerhalb des Containers mit folgendem Befehl einhängen:
`$ docker run -i -t -v /:/host:ro fedora /bin/bash`

Wenn das Verzeichnis auf dem Host (`/srv`) nicht existiert, wird es erstellt, da du die Berechtigung zum Erstellen eines Verzeichnises benötigtst kann es vorkommen , dass hier ein Fehler gemeldet wird. Auch auf dem Docker-Host, bei dem SELinux aktiviert ist und wenn der Docker-Daemon so konfiguriert ist, dass er SELinux (`docker -d --selinux-enabled`) verwendet, sehen Sie den `permission denied`, wenn Sie versuchen, auf Dateien auf dem eingehänten Datenträgern zuzugreifen, bis Sie Sie neu verknüpfen . Um sie zu verknüpfen, verwenden Sie einen der folgenden Befehle:

```s
$ docker run -i -t -v /srv:/mnt/code:z fedora /bin/bash
$ docker run -i -t -v /srv:/mnt/code:Z fedora /bin/bash
```

Für weitere inforationen dazu [Docker Sicherheit](../docker-sicherheit)

3.Erstellen Sie nun einen data volume container. Während wir das Host-Verzeichnis zu einem Container durch Volumen teilen, binden wir den Container an einen bestimmten Host, was nicht gut ist. Auch wird die Speicherung in diesem Fall nicht vom Docker gesteuert. Also, in Fällen, in denen wir wollen, dass Daten bestehen bleiben, auch wenn wir die Container aktualisieren, können wir Hilfe von data volume container erhalten. data volume container werden verwendet, um ein Volumen zu erstellen und nichts anderes; Sie laufen nicht einmal. Da das erstellte Volume an einen Container (nicht ausgeführt) angehängt ist, kann er nicht gelöscht werden. Zum Beispiel ist hier ein benannter Datencontainer:

`$ docker run -d -v /data --name data fedora echo "data volume container"`

Dies wird nur ein Volume erstellen, das einem von Docker verwalteten Verzeichnis zugeordnet wird. Jetzt können andere Container das Volume aus dem Datencontainer mit der Option `--volumes-from` wie folgt einrichten:

`$ docker run  -d -i -t --volumes-from data --name client1 fedora /bin/bash`

Wir können ein Volumen aus dem Datenvolumen-Container zu mehreren Containern anhängen:

`$ docker run  -d -i -t --volumes-from data --name client2 fedora /bin/bash`

Wir können auch `--volumes-from` mehrmals verwenden, um die data volumes aus mehreren Containern zu erhalten. Wir können auch eine Kette erstellen, indem wir Volumina aus dem Behälter anhängen, die von einem anderen Container eingehängt werden.

## Wie es funktioniert…

Im Fall des data volume, wenn das Host-Verzeichnis nicht geteilt wird, erstellt Docker ein Verzeichnis innerhalb `/var/lib/docker/` und teilt es dann mit anderen Containern.

## Es gibt mehr…

* Volumes werden mit `-v`-Flag zum `docker rm` gelöscht, nur wenn kein anderer Container es benutzt. Wenn ein anderer Container das Volumen benutzt, wird der Container entfernt (mit `docker rm`), aber das volume wird nicht entfernt.

* Im vorherigen Kapitel haben wir gesehen, wie man die Docker-Registry konfiguriert, die standardmäßig mit dem `dev`-Ziel beginnt. In dieser Registry wurden hochgeladene Images im `/tmp/registry` Verzeichnis im Container gespeichert, den wir gestartet haben. Wir können ein Verzeichnis aus dem Host unter `/tmp/registry` innerhalb des Registry-Containers einbinden. Wenn wir also ein Image hochladen, wird es auf dem Host gespeichert, auf dem die Docker-Registrierung ausgeführt wird. Also, um den Container zu starten, führen wir folgenden Befehl aus:

`$ docker run -d -v /data --name data fedora echo "data volume container"`

Um ein Image zu schreiben, führen wir den folgenden Befehl aus:

`$ docker push registry-host:5000/nkhare/f20`

Nachdem das Image erfolgreich gesendet wurde, können wir uns den Inhalt des Verzeichnisses anschauen, das wir in der Docker-Registrierung installiert haben. In unserem Fall sollten wir eine Verzeichnisstruktur wie folgt sehen:

```s
/srv/
├── images 
│   ├── 3f2fed40e4b0941403cd928b6b94e0fd236dfc54656c00e456747093d10157ac
│   │   ├── ancestry
│   │   ├── _checksum
│   │   ├── jso
│   │   └── layer
│   ├── 511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158
│   │   ├── ancestry
│   │   ├── _checksum
│   │   ├── json
│   │   └── layer
│   ├── 53263a18c28e1e54a8d7666cb83867865e9fa6a4b7b17385d46a7afe55bc5a94c
│   │   ├── ancestry
│   │   ├── _checksum
│   │   ├── json
│   │   └── layer
│   └── fd241224e9cf32f33a7332346a4f2ea39c4d5087b76392c1ac5490bf2ec55b68
│       ├── ancestry
│       ├── _checksum
│       ├── json
│       └── layer
├── repositories
│   └── nkhare
│       └── f20
│           ├── _index_images
│           ├── json
│           ├── tag_latest
│           └── taglatest_json
```

Siehe auch

* Die Dokumentation auf der Docker-Website unter https://docs.docker.com/userguide/dockervolumes/

* Http://container42.com/2013/12/16/persistent-volumes-with-docker-container-as-volume-pattern/

* Http://container42.com/2014/11/03/docker-indepth-volumes/
