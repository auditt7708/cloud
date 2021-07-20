---
title: docker-tips-tricks-treiber-aendern
description: 
published: true
date: 2021-06-09T15:17:31.638Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:17:26.069Z
---

Wie wir wissen, ist libcontainer der Standard-Ausführungstreiber. Es gibt Legacy-Unterstützung für LXC Userspace-Tools (https://linuxcontainers.org/). Denken Sie daran, dass LXC nicht die primäre Entwicklungsumgebung ist.

### Fertig werden

Installiere Docker auf dem System.

### Wie es geht…

1. Starten Sie den Docker-Daemon mit der Option `-e lxc` wie folgt:
`$ docker -d -e lxc`

Sie können diese Option auch in der Konfigurationsdatei des Dockers hinzufügen, abhängig von der Verteilung.

### Wie es funktioniert…

Docker verwendet LXC-Tools, um auf Kernel-Features wie Namespaces und Cgroups zuzugreifen, um Container auszuführen.

### Siehe auch

* Die Dokumentation auf der Docker-Website https://docs.docker.com/reference/commandline/cli/#docker-exec-driver-option