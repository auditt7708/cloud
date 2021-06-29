---
title: docker-benutzen-container-labeling-filtering
description: 
published: true
date: 2021-06-09T15:07:53.983Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:07:48.841Z
---

# Docker Container labels und filter benutzen

Mit Docker 1.6 wurde ein Feature zu Label-Containern und Bildern hinzugefügt, mit denen wir beliebige Key-Value-Metadaten anfügen können. Sie können sie als Umgebungsvariablen denken, die für die Ausführung von Anwendungen in Containern nicht verfügbar sind, aber sie sind für Programme (Docker CLI) verfügbar, die Bilder und Container verwalten. Etiketten, die an Bilder angebracht sind, werden auch auf Container angewendet, die über sie gestartet werden. Wir können auch Etiketten zu den Behältern anbringen.

Docker bietet auch [Filter für Container, Bilder und Events](https://docs.docker.com/reference/commandline/cli/#filtering), die wir in Verbindung mit Etiketten verwenden können, um unsere Suche einzuschränken.

Für dieses Rezept nehmen wir an, dass wir ein Bild mit dem Label haben, `distro=fedora21`. Im nächsten Kapitel werden wir sehen, wie man ein label einem Image zuweist.

Wie Sie aus dem vorigen Screenshot sehen können, wenn wir Filter mit dem Befehl `docker images` verwenden, erhalten wir nur ein Bild, in dem das entsprechende Label in den Metadaten des Bildes gefunden wird.

## Fertig werden

Stellen Sie sicher, dass der Docker-Daemon 1.6 und höher auf dem Host läuft und Sie können über den Docker-Client verbinden.

## Wie es geht…

1.Um den Container mit der Option `--label/-l` zu starten, führen Sie den folgenden Befehl aus:
`$ docker run --label environment=dev f21 date`

2.Lassen Sie uns einen Container ohne Etikett starten und starten Sie zwei andere mit dem gleichen Label:
`docker run --name cintainer1 f21 date`

Wenn wir alle Container ohne Etikett auflisten, sehen wir alle Container, aber wenn wir Etikett verwenden, dann bekommen wir nur Container, die mit dem Label übereinstimmen.

## Wie es funktioniert…

Docker fügt Etikettenmetadaten in Container ein, während sie sie starten und mit dem Etikett übereinstimmen, während sie sie auflisten oder andere verwandte Operationen.

## Es gibt mehr…

* Wir können alle Etiketten, die an einem Container befestigt sind, durch den `inspect` befehl auflisten, den wir in einem früheren Rezept gesehen haben. Wie wir sehen können, gibt der Befehl `inspect` sowohl das Bild als auch die Container-Labels zurück.

* Sie können Etiketten aus einer Datei anwenden (mit der Option `--from-file`), die eine Liste von Etiketten hat, die durch eine neue EOL getrennt sind.

* Diese Etiketten unterscheiden sich von dem Kubernetes-Label, das wir in [Docker Orchestration und Hosting](../docker-Orchestration-hosting) sehen werden.
