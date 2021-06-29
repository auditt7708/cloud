---
title: docker-benutzen-container-starten
description: 
published: true
date: 2021-06-09T15:08:45.447Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:08:40.241Z
---

Sobald wir Bilder haben, können wir sie benutzen, um die Container zu starten. In diesem Rezept werden wir einen Container mit der `fedora:latest` neues image und sehen, was alle Dinge hinter der Szene passieren.
Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Die Syntax, die zum Starten eines Containers verwendet wird, lautet wie folgt:
`docker run [ OPTIONS ]  IMAGE[:TAG]  [COMMAND]  [ARG...]`

Hier ist ein Beispiel für einen Befehl:

`$ docker run -i -t --name=f21 fedora /bin/bash`

Standardmäßig wählt Docker das Bild mit dem neuesten Tag:
* Die Option `-i` startet den Container im interaktiven Modus
* Die Option `-t` weist eine Pseudo-tty zu und verbindet sie mit der Standard-Eingabe

Also, mit dem vorangehenden Befehl, starten wir einen Container aus der `fedora:latest`, `pseudo-tty`, nennen es `f21`, und führen Sie die `/bin/bash` Befehl. Wenn der Name nicht angegeben ist, wird eine zufällige Zeichenfolge als Name zugewiesen.

Auch wenn das Image nicht lokal verfügbar ist, dann wird es aus der Registry zuerst heruntergeladen und dann laufen. Docker führt die `search`- und `pull`-Befehle aus, bevor der Befehl `run` ausgeführt wird.

### Wie es funktioniert…

Unter dem Hut, Docker:

* Wird alle Ebenen zusammenführen, die dieses Image mit UnionFS machen.

* Weist einem Container eine eindeutige ID zu, die als Container ID bezeichnet wird.

* Weist ein Dateisystem zu und platziert eine Lese- / Schreibschicht für den Container. Alle Änderungen auf dieser Ebene werden vorübergehend sein und werden verworfen, wenn sie nicht verpflichtet sind.

* Weist eine Netzwerk- / Brückenschnittstelle zu.

* Weist dem Container eine IP-Adresse zu.

* Führt den vom Benutzer angegebenen Prozess aus.

Außerdem erstellt es mit der Standard-Docker-Konfiguration ein Verzeichnis mit der Container-ID innerhalb `/var/lib/docker/container`, das die spezifischen Informationen des Containers wie Hostname, Konfigurationsdetails, Protokolle und `/etc/hosts` enthält.

### Es gibt mehr…

* Um den Container zu verlassen, drücken Sie **Strg + D** oder geben Sie den `exit` ein. Es ist ähnlich wie aus einer Schale, aber das wird den Container stoppen.

* Der Befehl run erstellt und startet den Container. Mit Docker 1.3 oder höher ist es möglich, den Container einfach mit dem Befehl create zu erstellen und später mit dem Startbefehl auszuführen, wie im folgenden Beispiel gezeigt:

```s
$ ID=$(docker create -t -i fedora bash)
$ docker start -a -i $ID
```

* Der Container kann im Hintergrund gestartet werden und dann können wir ihn bei Bedarf anbringen. Wir müssen die Option `-d` verwenden, um den Container im Hintergrund zu starten:

```s
$ docker run -d -i -t fedora /bin/bash 
0df95cc49e258b74be713c31d5a28b9d590906ed9d6e1a2dc756 72aa48f28c4f
```

Der vorherige Befehl gibt die Container-ID des Containers zurück, an den wir später anhängen können:

```s
$ ID = 'Docker laufen -d -t -i Fedora / bin / bash'
$ Docker anhängen $ ID
```

Im vorigen Fall wählten wir `/bin/bash`, um innerhalb des Containers zu laufen. Wenn wir uns an den Container anschließen, erhalten wir eine interaktive Shell. Wir können einen nicht interaktiven Prozess ausführen und ihn im Hintergrund ausführen, um einen daemonisierten Container wie folgt zu machen:

`$ docker run -d  fedora /bin/bash -c  "while [ 1 ]; do echo hello docker ; sleep 1; done"`

* Um den Container nach dem Ausfahren zu entfernen, starten Sie den Container mit der Option --rm wie folgt:

`$ docker run --rm fedora date`

Sobald der `date` befehl beendet ist, wird der Container entfernt.

* Die Option `--read-only` des `run`-Befehls wird das Root-Dateisystem im `read-only` Modus installieren:

`$ docker run --read-only -d -i -t fedora /bin/bash`

Denken Sie daran, dass diese Option nur dafür sorgt, dass wir nichts auf dem Root-Dateisystem ändern können, aber wir schreiben auf Bände, die wir später im Buch abdecken werden. Diese Option ist sehr nützlich, wenn wir nicht möchten, dass Benutzer versehentlich Inhalte in den Container schreiben, die verloren gehen, wenn der Container nicht begangen oder auf nicht-kurzlebige Speicherung wie Volumes kopiert wird.

* Sie können auch benutzerdefinierte Etiketten auf Container setzen, mit denen die Container auf Etiketten gruppiert werden können. Werfen Sie einen Blick auf die Beschriftung und Filterung Behälter Rezept in diesem Kapitel für weitere Details.

### Tip

Ein Container kann auf drei Arten bezogen werden: nach Name, nach Container-ID (0df95cc49e258b74be713c31d5a28b9d590906ed9d6e1a2dc75672 aa48f28c4f) und durch kurze Container-ID (0df95cc49e25)
