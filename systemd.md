---
title: systemd
description: 
published: true
date: 2021-06-09T16:07:39.809Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:07:34.065Z
---

# Systemd

## systemctl

Abhängigkeiten Anzeigen

`systemctl list-dependencies $service`

## journalctl

Boot vorgänge auflisten

`journalctl --list-boots`

filter nach datum

`journalctl --since "2016-07-01" --until "2 minutes ago"`

Rechte Prüfen

`usermod -aG systemd-journal BENUTZERNAME`

Filter nach Datum und Fehler Level

`journalctl -p err -b --since "2019-01-11"`

## Path-Units

Mit Hilfe von systemd Path-Units können Dateien oder Verzeichnisse auf Änderungen hin überwacht werden. Tritt ein definiertes Ergebnis wie z.B. das Anlegen einer Datei ein, wird eine Service-Unit ausgeführt.
