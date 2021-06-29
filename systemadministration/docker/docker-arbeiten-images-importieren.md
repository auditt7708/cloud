---
title: docker-arbeiten-images-importieren
description: 
published: true
date: 2021-06-09T15:06:18.576Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:06:14.139Z
---

# Docker arbeiten mit Images: Importiren

Um eine lokale Kopie des image zu erhalten, müssen wir sie entweder aus der zugänglichen Registrierung kopiren oder aus dem bereits exportierten image importieren, wie wir im früheren Rezept gesehen haben. Mit dem Befehl `docker import` wir ein exportiertes Bild.

## Fertig werden

Sie benötigen ein zugängliches exportiertes Docker-image.

### Wie es geht…

1. Um ein image zu importieren, können wir folgende Syntax verwenden:
`$ docker import URL|- [REPOSITORY[:TAG]]`

Hier ist ein Beispiel mit der vorherigen Syntax:
`$ cat fedora-latest.tar | docker import - fedora:latest`

Alternativ können Sie folgendes Beispiel beachten:
`$ docker import http://example.com/example.tar example/image`

Das vorhergehende Beispiel wird zunächst ein leeres Dateisystem erstellen und dann den Inhalt importieren.
