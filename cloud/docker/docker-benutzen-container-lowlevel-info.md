---
title: docker-benutzen-container-lowlevel-info
description: 
published: true
date: 2021-06-09T15:08:15.893Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:08:10.872Z
---

# Docker low level informationen benutzen

Beim Debugging, Automatisierung und so weiter, benötigen wir die Container-Konfigurationsdetails. Docker bietet den Inspektionsbefehl, um diese leicht zu bekommen.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1.Um einen container/image zu untersuchen, führen Sie den folgenden Befehl aus:
`$ docker inspect [-f|--format="" CONTAINER|IMAGE [CONTAINER|IMAGE...]`

2.Wir beginnen einen Container und kontrollieren ihn dann:

```sh
$ ID='docker run -d -i fedora /bin/bash'
$ docker inspect $ID
[{
    "Args": [],
    "Config": {
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Cmd": [
            "/bin/bash"
        ],
    .........
    .........
}]
```

### Wie es funktioniert…

Docker schaut in die Metadaten und die Konfiguration für das gegebene Bild oder den Container und präsentiert es.

### Es gibt mehr…

Mit dem -`f | - Format`-Option können wir die Go (Programmiersprache) Vorlage verwenden, um die spezifischen Informationen zu erhalten. Der folgende Befehl gibt uns eine IP-Adresse des Containers:

```sh
$ docker inspect --format='{{.NetworkSettings.IPAddress}}'  $ID
172.17.0.2
```
