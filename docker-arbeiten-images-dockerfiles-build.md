Dockerfiles helfen uns bei der Automatisierung der Bilderzeugung und bekommen genau das gleiche Bild, wenn wir es wollen. Der Docker-Builder liest Anweisungen aus einer Textdatei (eine Dockerfile) und führt sie nacheinander in der Reihenfolge aus. Es kann als Vagrant-Dateien verglichen werden, mit denen Sie VMs in einer vorhersagbaren Weise konfigurieren können.
Fertig werden

Eine Dockerfile mit Bauanleitung.

* Erstellen Sie ein leeres Verzeichnis:
```
$ mkdir sample_image
$ cd sample_image
```

* Erstellen Sie eine Datei mit dem Namen Dockerfile mit folgendem Inhalt:
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

1. Führen Sie den folgenden Befehl innerhalb des Verzeichnisses aus, wo wir Dockerfile erstellt haben, um das Bild zu erstellen:
`$ docker build . `

Bei der Erstellung des Bildes haben wir kein Repository- oder Tag-Name angegeben. Wir können die mit der Option `-t` wie folgt geben:
`$ docker build -t fedora/test . `

Die vorhergehende Ausgabe unterscheidet sich von dem, was wir früher gemacht haben. Doch hier verwenden wir einen Cache nach jeder Anweisung. Docker versucht, die Zwischenbilder zu speichern, wie wir früher gesehen haben und versucht, sie in nachfolgenden Builds zu verwenden, um den Buildprozess zu beschleunigen. Wenn Sie die Zwischenbilder nicht zwischenspeichern möchten, dann fügen Sie die `--no-cache`-Option mit dem Build hinzu. Schauen wir uns jetzt die verfügbaren Bilder an:

`docker images`

### Wie es funktioniert…

Ein Kontext definiert die Dateien, die zum Erstellen des Docker-Bildes verwendet werden. Im vorherigen Befehl definieren wir den Kontext zum Build. Der Build wird vom Docker-Daemon durchgeführt und der gesamte Kontext wird auf den Daemon übertragen. Aus diesem Grund sehen wir den `Sending build context to Docker daemon 2.048 kB`-Nachricht. Wenn es eine Datei namens `.dockerignore` im aktuellen Arbeitsverzeichnis mit der Liste der Dateien und Verzeichnisse (neue Zeile getrennt) gibt, werden diese Dateien und Verzeichnisse vom Build-Kontext ignoriert. Weitere Details über `.dockerignore` finden Sie unter https://docs.docker.com/reference/builder/#the-dockerignore-file.

Nach dem Ausführen jeder Anweisung verpflichtet Docker das Zwischenbild und führt einen Container mit ihm für den nächsten Befehl aus. Nachdem die nächste Anweisung ausgeführt wurde, wird Docker den Container erneut dazu veranlassen, das Zwischenbild zu erstellen und den im vorherigen Schritt erstellten Zwischencontainer zu entfernen.

Zum Beispiel ist bei dem vorangegangenen Screenshot `eb9f10384509` ein Zwischenbild und `c5d4dd2b3db9` und `ffb9303ab124` sind die Zwischenbehälter. Nach dem letzten Befehl wird das endgültige Bild erstellt. In diesem Fall ist das endgültige Bild `4778dd1f1a7a`:

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

There can be more than one `FROM` instruction in one Dockerfile to create multiple images.

If only image names, such as Fedora and Ubuntu are given, then the images will be downloaded from the default Docker registry (Docker Hub). If you want to use private or third-party images, then you have to mention this as follows:
`[registry_hostname[:port]/][user_name/](repository_name:version_tag)`

Hier ist ein Beispiel mit der vorherigen Syntax:
`FROM registry-host:5000/nkhare/f20:httpd`

* MAINTAINER: Hiermit wird der Autor für das generierte Bild gesetzt, MAINTAINER <name>.

* RUN: Wir können die RUN-Anweisung auf zwei Arten ausführen - zuerst in der Shell laufen (sh -c):
`RUN <command> <param1> ... <pamamN>`

Zweitens führen Sie direkt eine ausführbare Datei aus:

`RUN ["executable", "param1",...,"paramN" ]`

As we know with Docker, we create an overlay—a layer on top of another layer—to make the resulting image. Through each `RUN` instruction, we create and commit a layer on top of the earlier committed layer. A container can be started from any of the committed layers.

By default, Docker tries to cache the layers committed by different `RUN` instructions, so that it can be used in subsequent builds. However, this behavior can be turned off using `--no-cache flag` while building the image.

* 331/5000
LABEL: Docker 1.6 hat dem angehängten beliebigen Key-Value-Paar ein neues Feature zu Docker-Bildern und Containern hinzugefügt. Wir haben einen Teil davon in der Beschriftung und Filterung Container Rezept in Kapitel 2, Arbeiten mit Docker Container. Um ein `LABEL` zu einem Bild zu geben, verwenden wir die `LABEL`-Anweisung im Dockerfile als LABEL distro = fedora21.