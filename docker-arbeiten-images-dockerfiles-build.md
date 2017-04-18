Dockerfiles helfen uns bei der Automatisierung der Imagezeugung und bekommen genau das gleiche Image, wenn wir es wollen. Der Docker-Builder liest Anweisungen aus einer Textdatei (eine Dockerfile) und führt sie nacheinander in der Reihenfolge aus. Es kann als Vagrant-Dateien verglichen werden, mit denen Sie VMs in einer vorhersagbaren Weise konfigurieren können.

### Fertig werden

Eine Dockerfile mit Bauanleitung.

* Erstellen Sie ein leeres Verzeichnis:
```
$ mkdir sample_image
$ cd sample_image
```

* Erstellen Sie eine Datei mit dem Namen `Dockerfile` mit folgendem Inhalt:
```
$ cat Dockerfile
# Pick up the base image 
FROM fedora 
# Add author name 
MAINTAINER Neependra Khare 
# Add the command to run at the start of container 
CMD date
```

### Wie es geht…

1. Führen Sie den folgenden Befehl innerhalb des Verzeichnisses aus, wo wir das `Dockerfile` erstellt haben, um das Image zu erstellen:
`$ docker build . `

Bei der Erstellung des Images haben wir kein Repository- oder Tag-Name angegeben. Wir können das mit der Option `-t` wie folgt nachhollen:
`$ docker build -t fedora/test . `

Die vorhergehende Ausgabe unterscheidet sich von dem, was wir früher gemacht haben. Doch hier verwenden wir einen Cache nach jeder Anweisung. Docker versucht, die Zwischenbilder zu speichern, wie wir früher gesehen haben und versucht, sie in nachfolgenden Builds zu verwenden, um den Buildprozess zu beschleunigen. Wenn Sie die Zwischenbilder nicht zwischenspeichern möchten, dann fügen Sie die `--no-cache`-Option mit dem Image hinzu. Schauen wir uns jetzt die verfügbaren Images an:

`docker images`

### Wie es funktioniert…

Ein Kontext definiert die Dateien, die zum Erstellen des Docker-Images verwendet werden. Im vorherigen Befehl definieren wir den Kontext zum Build. Der Build wird vom Docker-Daemon durchgeführt und der gesamte Kontext wird auf den Daemon übertragen. Aus diesem Grund sehen wir den `Sending build context to Docker daemon 2.048 kB`-Nachricht. Wenn es eine Datei namens `.dockerignore` im aktuellen Arbeitsverzeichnis mit der Liste der Dateien und Verzeichnisse (durch eine neue Zeile getrennt) gibt, werden diese Dateien und Verzeichnisse vom Build-Kontext ignoriert. Weitere Details über `.dockerignore` finden Sie unter https://docs.docker.com/reference/builder/#the-dockerignore-file.

Nach dem Ausführen jeder Anweisung aktualisiert Docker das Zwischenbild und führt einen Container mit ihm für den nächsten Befehl aus. 
Nachdem die nächste Anweisung ausgeführt wurde, wird Docker den Container erneut dazu veranlassen, das Zwischenbild zu erstellen und den den im vorherigen Schritt erstellten Zwischencontainer zu entfernen.

Zum Beispiel ist bei dem vorangegangenen Beispiel `eb9f10384509` ein Zwischenbild und `c5d4dd2b3db9` und `ffb9303ab124` sind die Zwischenbehälter. Nach dem letzten Befehl wird das endgültige Bild erstellt. In diesem Fall ist das endgültige Bild `4778dd1f1a7a`:

`docker images`


Die Option -a kann mit dem Befehl docker images angegeben werden, um nach Zwischenschichten zu suchen:
`$ docker images -a`

### Es gibt mehr…

Das Format der Dockerfile lautet:
`INSTRUCTION arguments`

Im Allgemeinen werden Anweisungen in Großbuchstaben angegeben, aber es wird nicht zwischen Groß- und Kleinschreibung unterschieden. Sie werden in der Reihenfolge ausgewertet. Ein `#` am Anfang wird wie ein Kommentar behandelt.

Schauen wir uns die verschiedenen Arten von Anweisungen an:

* FROM: Dies muss die erste Anweisung einer Dockerfile sein, die das Basisbild für nachfolgende Anweisungen festlegt. Standardmäßig wird das letzte Tag angenommen:
`FROM  <image>`

Alternativ betrachten wir folgendes Tag:
`FROM  <images>:<tag>`

Es kann mehr als eine `FROM` Anweisung in einer Dockerfile geben, um mehrere Bilder zu erstellen.

Wenn nur Bildnamen wie Fedora und Ubuntu gegeben sind, werden die Bilder aus der Standard-Docker-Registrierung (Docker Hub) heruntergeladen. Wenn Sie private oder Drittanbieterbilder verwenden möchten, dann müssen Sie dies wie folgt bekannt machen:
`[registry_hostname[:port]/][user_name/](repository_name:version_tag)`

Hier ist ein Beispiel mit der vorherigen Syntax:
`FROM registry-host:5000/nkhare/f20:httpd`

* `MAINTAINER`: Hiermit wird der Autor für das generierte Bild gesetzt, MAINTAINER <name>.

* `RUN`: Wir können die RUN-Anweisung auf zwei Arten ausführen - zuerst in der Shell laufen (sh -c):
`RUN <command> <param1> ... <pamamN>`

Zweitens führen Sie direkt eine ausführbare Datei aus:

`RUN ["executable", "param1",...,"paramN" ]`

Wie wir von Docker wissen, erstellen wir eine Overlay - eine Schicht auf einer anderen Ebene - um das resultierende Image zu machen. Durch jede `RUN`-Anweisung erstellen und begehen wir eine Schicht auf der vorherigen begangenen Schicht. Ein Container kann von jedem der engagierten Ebenen gestartet werden.

Standardmäßig versucht Docker, die von verschiedenen `RUN`-Anweisungen belegten Ebenen zwischenzuspeichern, damit sie in nachfolgenden Builds verwendet werden können. Allerdings kann dieses Verhalten mit `--no-cache flag` deaktiviert werden, während das Image gebaut wird.

* `LABEL`: Docker 1.6 hat dem angehängten beliebigen Key-Value-Paar ein neues Feature zu Docker-Bildern und Containern hinzugefügt. Wir haben einen Teil davon in der Beschriftung und Filterung Container Rezept in [Arbeiten mit Docker Container] (../ docker-arbeiten-mit-docker) bearbeitet. Um ein `LABEL` zu einem Image hinzuzufügen verwenden wir die` LABEL`-Anweisung im Dockerfile als` LABEL distro = fedora21`.

* `CMD`: Die `CMD`-Anweisung bietet eine Standard-ausführbare Datei beim Starten eines Containers. Wenn die CMD-Anweisung keine ausführbare Datei hat (Parameter 2), dann wird es Argumente für `ENTRYPOINT` geben.
```
CMD  ["executable", "param1",...,"paramN" ]
CMD ["param1", ... , "paramN"]
CMD <command> <param1> ... <pamamN>
```
In einer Dockerfile ist nur eine `CMD`-Anweisung erlaubt. Wenn mehr als eine angegeben ist, dann wird nur die letzte benutzt.

* `ENTRYPOINT`: Dies hilft uns, den Container als ausführbare Datei zu konfigurieren. Ähnlich wie bei `CMD` gibt es bei max eine Anweisung für `ENTRYPOINT`; Wenn mehr als eine angegeben ist, dann wird nur die letzte benutzt:
```
ENTRYPOINT  ["executable", "param1",...,"paramN" ]
ENTRYPOINT <command> <param1> ... <pamamN>
```

Sobald die Parameter mit der `ENTRYPOINT`-Anweisung definiert sind, können sie zur Laufzeit nicht überschrieben werden. Allerdings kann ENTRYPOINT als `CMD` verwendet werden, wenn wir verschiedene Parameter zu `ENTRYPOINT` verwenden wollen.

* EXPOSE: Das macht die Netzwerk-Ports auf dem Container, auf dem es zur Laufzeit lauschen wird:
`EXPOSE  <port> [<port> ... ]`
Wir können auch einen Port beim Starten des Containers anbieten.

* `ENV`: Damit wird die Umgebungsvariable `<key>` auf `<value>` gesetzt. Es wird alle zukünftigen Anweisungen weitergegeben und wird bestehen bleiben, wenn ein Container aus dem resultierenden Image ausgeführt wird:
`ENV <key> <value>`

* ADD: Das kopiert Dateien von der Quelle zum Ziel:
`ADD <src> <dest> `

Die folgende ist für den Weg mit weißen Räumen:
`ADD ["<src>"... "<dest>"]`

* `<src>`: Dies muss die Datei oder das Verzeichnis innerhalb des Build-Verzeichnisses sein, aus dem wir ein Bild erstellen, das auch als Kontext des Builds bezeichnet wird. Eine Quelle kann auch eine entfernte URL sein.

* `<dest>`: Dies muss der absolute Pfad innerhalb des Containers sein, in dem die Dateien / Verzeichnisse aus der Quelle kopiert werden.

* `COPY`: Das ist ähnlich wie `ADD.COPY <src> <dest>`
`COPY  ["<src>"... "<dest>"]`

* VOLUME: Diese Anweisung erzeugt einen Mountpunkt mit dem gegebenen Namen und markiert ihn als das externe Volume mit der folgenden Syntax:
`VOLUME ["/data"]`

Alternativ können Sie den folgenden Code verwenden:

`VOLUME /data`

* USER: Hiermit wird der Benutzername für eine der folgenden Run-Anweisungen unter Verwendung der folgenden Syntax gesetzt:
`USER  <username>/<UID>`

* WORKDIR: Hiermit wird das Arbeitsverzeichnis für die Anweisungen `RUN`, `CMD` und `ENTRYPOINT` eingestellt. Es kann mehrere Einträge in der gleichen Dockerfile haben. Es kann ein relativer Pfad gegeben werden, der relativ zu der früheren `WORKDIR`-Anweisung mit der folgenden Syntax sein wird:
`WORKDIR <PATH>`

* ONBUILD: Dies fügt Trigger-Anweisungen zu dem Bild hinzu, das später ausgeführt wird, wenn dieses Bild als Basisbild eines anderen Bildes verwendet wird. Dieser Trigger wird als Teil der FROM-Anweisung in Downstream Dockerfile mit der folgenden Syntax ausgeführt:
`ONBUILD [INSTRUCTION]`