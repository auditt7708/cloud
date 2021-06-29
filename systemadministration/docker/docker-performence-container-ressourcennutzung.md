---
title: docker-performence-container-ressourcennutzung
description: 
published: true
date: 2021-06-09T15:14:06.115Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:14:00.555Z
---

# Docker Performence und ressourcennutzung

Mit dem Release von Version 1.5 hat Docker eine Funktion hinzugefügt, um Containerressourcenverbrauch aus eingebauten Befehlen zu erhalten.

## Fertig werden

Ein Docker-Host mit Version 1.5 oder höher installiert, auf den über den Docker-Client zugegriffen werden kann. Starten Sie auch ein paar Container, um Stats zu bekommen.

### Wie es geht…

1. Führen Sie den folgenden Befehl aus, um Statistiken aus einem oder mehreren Containern zu erhalten:
`$ docker stats [CONTAINERS]`

Zum Beispiel, wenn wir zwei Container mit den Namen `some-mysql` und `backstabbing_turing` haben, dann führen Sie den folgenden Befehl, um die Stats zu erhalten:
$ docker stats some-mysql backstabbing_turing
![stats](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_07_02.jpg)

## Wie es funktioniert…

Der Docker-Daemon holt die Ressourceninformationen aus den Cgroups und bedient ihn über die APIs.

## Siehe auch

* Beachten Sie die Release Notes von Docker 1.5 unter https://docs.docker.com/v1.5/release-notes/