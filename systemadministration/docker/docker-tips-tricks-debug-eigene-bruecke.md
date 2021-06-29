---
title: docker-tips-tricks-debug-eigene-bruecke
description: 
published: true
date: 2021-06-09T15:16:39.936Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:16:34.678Z
---

Wie wir wissen, wenn der Docker-Dämon beginnt, schafft es eine Brücke namens `docker0` und alle Container würden die IP davon bekommen. Manchmal möchten wir diese Einstellungen anpassen. Mal sehen, wie wir das in diesem Rezept machen können.

### Fertig werden

Ich gehe davon aus, dass Sie bereits einen Docker eingerichtet haben. Auf dem Docker-Host den Docker-Dämon anhalten. Verwenden Sie auf Fedora den folgenden Befehl:
`$ systemctl stop docker`

### Wie es geht…

Um die Standard-Docker0-Brücke zu entfernen, verwenden Sie den folgenden Befehl:
```
$ sudo ip link set dev docker0 down 
$ sudo brctl delbr docker0
```

2. Um die benutzerdefinierte Bridge zu erstellen, verwenden Sie den folgenden Befehl:
```
$ sudo brctl addbr br0 
$ sudo ip addr add 192.168.2.1/24 dev br0 
$ sudo ip link set dev bridge0 up
```

3. Aktualisieren Sie die Docker-Konfigurationsdatei, um mit der zuvor erstellten Bridge zu beginnen. Auf Fedora können Sie die Konfigurationsdatei wie folgt aktualisieren:
`$ sed -i '/^OPTIONS/ s/$/ --bridge br0/' /etc/sysconfig/docker`

4. Um den Docker-Daemon zu starten, verwenden Sie den folgenden Befehl:
`$ systemctl start docker`

### Wie es funktioniert…

Die vorherigen Schritte werden eine neue Brücke erstellen und es wird die IP von 192.168.2.0 Subnetz zu den Containern zuweisen.

### Es gibt mehr…

Sie können sogar eine Schnittstelle zur Brücke hinzufügen.
Siehe auch

* Die Dokumentation auf der Docker-Website unter https://docs.docker.com/articles/networking/