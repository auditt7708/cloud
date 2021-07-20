---
title: docker-benutzen-container-stoppen
description: 
published: true
date: 2021-06-09T15:08:52.312Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:08:47.255Z
---

Wir können sofort einen oder mehrere Container stoppen. In diesem Rezept werden wir zunächst einen Container starten und dann aufhören.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen. Sie benötigen auch einen oder mehrere Laufende container.

### Wie es geht…

1. Um den Container zu stoppen, führen Sie den folgenden Befehl aus:
`docker stop [-t|--time[=10]] CONTAINER [CONTAINER...]`

2. Wenn du schon einen laufenden Container hast, dann kannst du weiter gehen und ihn aufhalten; Wenn nicht, können wir einen erstellen und dann wie folgt aufhören:

```s
$ ID='docker run -d -i fedora /bin/bash'
$ docker stop $ID
```

### Wie es funktioniert…

Dadurch wird der Zustand des Containers gespeichert und aufhören. Es kann bei Bedarf wieder gestartet werden.

### Es gibt mehr…

* Um einen Container nach dem Warten auf einige Zeit zu stoppen, verwenden Sie die Option `--time/-t`.

* Um alle laufenden Container zu stoppen, führen Sie den folgenden Befehl aus:
`$ docker stop 'docker ps -q'`
