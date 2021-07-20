---
title: docker-arbeiten-images-loeschen
description: 
published: true
date: 2021-06-09T15:06:33.432Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:06:28.206Z
---

# Docker arbeiten mit Images: Löschen

Um das Image vom Host zu entfernen, können wir den Befehl `docker rmi` verwenden. Allerdings entfernt dies keine Images aus der Registrierung.

## Fertig werden

Stellen Sie sicher, dass ein oder mehrere Docker-Images lokal verfügbar sind.

### Wie es geht…

1. Um das Bild zu entfernen, betrachten Sie die folgende Syntax:
`$ docker rmi [ OPTIONS ] IMAGE [IMAGE...]`

In unserem Fall ist hier ein Beispiel mit der vorherigen Syntax:
`$ docker rmi nkhare/fedora:httpd`

### Es gibt mehr…

Wenn du alle containers und images entfernen möchtest, dann mache folgendes; Aber sei sicher , was du tust, da das sehr zerstörerisch ist:

* Um alle Container zu stoppen, verwenden Sie den folgenden Befehl:
`$ docker stop 'docker ps -q'`

* Um alle Container zu löschen, verwenden Sie den folgenden Befehl:
`$ docker rm 'docker ps -a -q'`

* Um alle images zu löschen, verwenden Sie den folgenden Befehl:
`$ docker rmi 'docker images -q'`
