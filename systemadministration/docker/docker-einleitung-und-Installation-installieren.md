---
title: docker-einleitung-und-Installation-installieren
description: 
published: true
date: 2021-06-09T15:10:58.619Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:10:53.918Z
---

# Docker Installation

Da gibt es viele Distributionen, die Docker unterstützen, schauen wir uns die Installationsschritte auf Fedora 21 in diesem Rezept an. Für andere können Sie sich auf die Installationsanweisungen beziehen, die im Abschnitt "Siehe auch" dieses Rezepts erwähnt werden. Mit Docker Machine können wir Docker-Hosts auf lokalen Systemen, auf Cloud-Providern und anderen Umgebungen ganz einfach einrichten. Wir werden das in einem anderen Rezept abdecken.
Fertig werden

Überprüfen Sie die im vorherigen Rezept erwähnten Voraussetzungen.

Wie es geht…

1.Install Docker mit yum:

`$  yum -y install docker`

## Wie es funktioniert...

Der vorherige Befehl installiert Docker und alle benötigten Pakete.

## Es gibt mehr…

Die Standard-Docker-Daemon-Konfigurationsdatei befindet sich unter `/etc/sysconfig/docker`, die beim Starten des Daemons verwendet wird. Hier sind einige grundlegende Operationen:

* Um den Service zu starten:

`$ Systemctl start docker`

* Um die Installation zu überprüfen:

`$ Docker info`

* So aktualisieren Sie das Paket:

`$ Yum -y Update Docker`

* Um den Dienststart beim Start zu aktivieren:

`$ Systemctl aktivieren Docker`

* Um den Service zu stoppen:

`$ Systemctl stop docker`
