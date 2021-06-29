---
title: docker-arbeiten-images-von-container
description: 
published: true
date: 2021-06-09T15:07:10.451Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:07:05.349Z
---

# Docker arbeiten mit Images: Images von Containern

Es gibt ein paar Möglichkeiten, um Bilder zu erstellen, man ist von manuell begehen Schichten und der andere Weg ist durch Dockerfiles. In diesem Rezept sehen wir das ehemalige und Blick auf Dockerfiles später im Kapitel.

Wenn wir einen neuen Container starten, wird eine read/write an sie angeschlossen. Diese Schicht wird zerstört, wenn wir sie nicht retten. In diesem Rezept werden wir sehen, wie wir diese Ebene speichern und ein neues Bild aus dem laufenden oder gestoppten Container mit dem Befehl docker commit erstellen.
Fertig werden

Um ein Docker-Image zu erhalten, füge einen `docker commit` an.

## Wie es geht…

1.Um das Commit auszuführen, führen Sie den folgenden Befehl aus:
`docker commit -a|--author[=""] -m|--message[=""] CONTAINER [REPOSITORY[:TAG]]`

2.Lassen Sie uns einen Container starten und einige Dateien mit dem `install httpd` Paket erstellen/modifizieren:
`docker run -i -t fedora /bin/bash`

3.Dann öffnen Sie ein neues Terminal und erstellen Sie ein neues Image, indem Sie das Commiten:
`$ docker commit -a "Neependra Khare" -m "Fedora with HTTPD package" 0a15686588ef nkhare/fedora:httpd`

Wie Sie sehen können, wird das neue Image nun mit `nkhare/fedora` als name und `httpd` als Tag an das lokale Repository weitergegeben.

### Wie es funktioniert…

In [Einleitung und Installation](../docker-einleitung-und-Installation) haben wir gesehen, dass beim Starten eines Containers eine Lese- / Schreib-Dateisystemebene über die vorhandenen Image schichten erstellt werden, aus denen der Container gestartet wurde, und bei der Installation eines Pakets hatten wir einige Dateien in dieser Schicht hinzugefügt / modifiziert. Alle diese Änderungen befinden sich derzeit in der kurzlebigen Lese- / Schreib-Dateisystem-Schicht, die dem Container zugeordnet ist. Wenn wir den Container stoppen und löschen, gehen alle zuvor erwähnten Änderungen verloren.

Mit Commit erstellen wir eine neue Ebene mit den Änderungen, die seit dem Start des Containers aufgetreten sind, die im Backend-Storage-Treiber gespeichert werden.

### Es gibt mehr…

* Um nach Dateien zu suchen, die seit dem Beginn des Containers geändert wurden können wir folgendes ausführen:
`$ docker diff CONTAINER`

In unserem Fall sehen wir so etwas wie den folgenden Code:

```sh
$ docker diff 0a15686588ef
.....
C /var/log
A /var/log/httpd
C /var/log/lastlog
.....
```

Wir können vor jedem Eintrag der Ausgabe ein Präfix sehen. Im Folgenden finden Sie eine Liste der möglichen Präfixe:

* A: Wird gesetzt, wenn eine Datei / ein Verzeichnis hinzugefügt wurde

* C: Wird gesetzt, wenn ein Datei- / Verzeichnis geändert wurde

* D: Wird gesetzt, wenn eine Datei / ein Verzeichnis gelöscht wurde

Standardmäßig wird ein Container pausiert, während er das Commit ausführt. Sie können sein Verhalten ändern, indem Sie `--pause=false` benutzen.
