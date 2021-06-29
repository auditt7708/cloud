---
title: docker-tips-tricks-debug-mode
description: 
published: true
date: 2021-06-09T15:16:55.099Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:16:50.026Z
---

Wir können Docker im Debug-Modus starten, um Protokolle zu debuggen.

### Fertig werden

Installiere Docker auf dem System.

### Wie es geht...

1. Starten Sie den Docker-Daemon mit der Debug-Option `-D`. Um von der Befehlszeile aus zu starten, können Sie den folgenden Befehl ausführen:
`$ docker -d -D`

2. Sie können auch die Option `--debug/-D` in der Docker-Konfigurationsdatei hinzufügen, um im Debug-Modus zu starten.

### Wie es funktioniert…

Der vorherige Befehl würde den Docker im Daemon-Modus starten. Sie sehen viele nützliche Nachrichten, wenn Sie den Dämon starten, wie das Laden von vorhandenen Images, Einstellungen für Firewalls (iptables) und so weiter. Wenn Sie einen Container starten, sehen Sie Nachrichten wie die folgenden:
```
[info] POST /v1.15/containers/create
[99430521] +job create() 
......
......
```