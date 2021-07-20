---
title: deluser
description: 
published: true
date: 2021-06-09T15:03:47.918Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:03:42.826Z
---

# Deluser

Den Benutzer anton entfernen, aber das Homeverzeichnis aber auf dem System belassen:

`sudo deluser anton`

Den Benutzer berta löschen. Mit der Option --remove-home wird das komplette Homeverzeichnis sowie der Mail-Spool des Benutzers gelöscht:

`sudo deluser --remove-home berta`

Den Benutzer caesar löschen. Mit der Option --backup wird das komplette Homeverzeichnis sowie der Mail-Spool des Benutzers in die Datei /BENUTZERNAME.tar.bz2 oder /BENUTZERNAME.tar.gz gesichert, bevor gelöscht wird:

`sudo deluser --backup caesar`

Den Benutzer dora löschen. Mit der Option --remove-all-files werden alle Dateien des Benutzers gelöscht:

`sudo deluser --remove-all-files dora`
