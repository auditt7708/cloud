---
title: docker-benutzen-image-pulling
description: 
published: true
date: 2021-06-09T15:09:14.656Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:09:09.520Z
---

# Docker Image Pulling

Nach dem Durchsuchen des Bildes können wir es mit dem Docker-Daemon an das System ziehen. Mal sehen, wie wir das machen können.
Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

## Wie es geht…

1. Um ein Bild auf der Docker-Registry zu ziehen, führen Sie den folgenden Befehl aus:
`docker pull NAME[:TAG]`

Das folgende ist ein Beispiel, um das Fedora-Bild zu ziehen:
`$ docker pull fedora`

## Wie es funktioniert…

Der `Pull`-Befehl lädt alle Layer aus der Docker-Registry herunter, die erforderlich sind, um dieses Bild lokal zu erstellen. Wir werden im nächsten Kapitel Details zu den Ebenen sehen.

## Es gibt mehr…

* Bild-Tags Gruppenbilder vom gleichen Typ. Zum Beispiel kann CentOS Bilder mit Tags wie centos5, centos6 und so weiter haben. Um beispielsweise ein Bild mit dem spezifischen Tag zu ziehen, führen Sie den folgenden Befehl aus:
`$ docker pull centos:centos7`

* Standardmäßig wird das Bild mit dem letzten Tag gezogen. Um alle Bilder zu entfernen, die allen Tags entsprechen, verwenden Sie den folgenden Befehl:
`$ docker pull --all-tags centos`

* Mit Docker 1.6 (https://blog.docker.com/2015/04/docker-release-1-6/) können wir Bilder aufbauen und auf Bilder von einem neuen Inhaltsadressen identifizieren, der als `digest` bezeichnet wird. Es ist eine sehr nützliche Eigenschaft, wenn wir mit einem bestimmten Bild arbeiten wollen, anstatt Tags. Um ein Bild mit einem bestimmten Digest zu ziehen, können wir die folgende Syntax berücksichtigen:
`$ docker pull  <image>@sha256:<digest>`

Hier ist ein Beispiel für einen Befehl:
`$ docker pull debian@sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf`

Digest wird nur mit dem Docker Registry V2 unterstützt.

* Sobald ein Bild gezogen wird, befindet es sich auf dem lokalen Cache (Storage), so dass nachfolgende Zugriffe sehr schnell sein werden. Diese Funktion spielt eine sehr wichtige Rolle beim Aufbau von Docker-Layer-Bildern.

## Siehe auch

* Schauen Sie sich die `hilfe`-Option von Docker `pull`:

`$ docker pull --help`

* Die Dokumentation auf der Docker-Website https://docs.docker.com/reference/commandline/cli/#pull
