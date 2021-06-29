---
title: docker-fehler
description: 
published: true
date: 2021-06-09T15:11:22.721Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:11:17.558Z
---

# Doker fehlerbehebung

## Docker compose

Fehler: 
> ERROR: Pool overlaps with other one on this address space

Mit 

`find docker-compose.yml data/ helper-scripts/ -type f -exec sed 's/172.22/172.50/' '{}' \;`

kann dann explizit eine IP geändert werden.

Es kommt aber auch vor, dass es so auch nicht geht und die angeblich in Benutzung befindliche IP nicht in Benutzung ist.
Wenn dem so ist kann man versuchen, dass man versuchen im Quellverzeichnis folgende befehle zu benutzen um die Konfiguration zu bereinigen.

```s
docker-compose down
docker-compose rm
```
