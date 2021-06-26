---
title: crmsh-v3-getting-started
description: 
published: true
date: 2021-06-09T15:03:10.130Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:03:04.899Z
---

# crmsh

So Sie haben erfolgreich crmsh auf einer oder mehreren Maschinen installiert und nun möchten jetzt einen Basiscluster konfigurieren.
Diese Anleitung soll Schritt-für-Schritt-Anleitungen zur Konfiguration von Herzschrittmacher mit einer einzigen Ressource bereitstellen, die in der Lage ist, zwischen einem Paar von Knoten zu scheitern, und baut dann auf dieser Basis auf, um einige fortgeschrittenere Themen des Clustermanagements abzudecken.

Noch nicht installiert? Bitte folgen Sie den Installationsanweisungen, bevor Sie diese Anleitung fortsetzen. 
Nur Crmsh und seine Abhängigkeiten müssen installiert werden, bevor Sie diese Anleitung folgen.

Bevor Sie fortfahren, stellen Sie sicher, dass dieser Befehl auf allen Knoten erfolgreich ausgeführt wird und gibt eine Versionsnummer zurück, die 3.0 oder höher ist:
Crm - version

In crmsh 3 wurden die Cluster-Init-Befehle durch die SLE HA-Bootstrap-Skripte ersetzt. Diese verlassen sich auf csync2 für die Konfigurationsdateimanagement, also stellen Sie sicher, dass Sie den Befehl csync2 installiert haben, bevor Sie fortfahren. Diese Anforderung kann in Zukunft entfernt werden.

## Arbeiten mit der crmsh

* [Technische Übersicht](../crmsh)

### Übersicht

* [Crmsh Home Page](http://crmsh.nongnu.org/)
* [start-guide](http://crmsh.github.io/start-guide/)
* [crmsh v3 Manpage](http://crmsh.github.io/man-3/)
