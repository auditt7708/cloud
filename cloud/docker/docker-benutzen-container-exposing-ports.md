---
title: docker-benutzen-container-exposing-ports
description: 
published: true
date: 2021-06-09T15:07:47.189Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:07:42.246Z
---

# Docker Container exposing Ports benutzen

Es gibt eine Reihe von Möglichkeiten, mit denen Ports auf dem Container ausgesetzt werden können. Einer von ihnen ist durch den Run-Befehl, den wir in diesem Kapitel abdecken werden. Die anderen Möglichkeiten sind durch die Docker-Datei und den Befehl --link. Wir werden sie in den anderen Kapiteln erforschen.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

## Wie es geht…

1.Die Syntax zum Freigeben eines Ports ist wie folgt:
`$ docker run --expose=PORT [ OPTIONS ]  IMAGE[:TAG]  [COMMAND]  [ARG...]`

Um zum Beispiel Port 22 beim Starten eines Containers freizulegen, führen Sie den folgenden Befehl aus:
`$ docker run --expose=22 -i -t fedora /bin/bash`

### Es gibt mehr…

Es gibt mehrere Möglichkeiten, die Ports für einen Container freizulegen. Jetzt werden wir sehen, wie wir den Port beim Starten des Containers aussetzen können. Wir werden andere Optionen aussehen, um die Ports in späteren Kapiteln auszusetzen.
