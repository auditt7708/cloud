---
title: journalctl
description: 
published: true
date: 2021-06-09T15:27:23.819Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:27:18.777Z
---

# journalctl

Zeitzonen

`timedatectl list-timezones`

Zeitzone setzen

`timedatectl set-timezone zone`

Log in UTC

`journalctl --utc`

Boot vorgang

`journalctl -b`

Boot Vorgänge

`journalctl --list-boots`

Dach Datum

`journalctl --since "2015-01-10 17:15:00"`

Von bis

`journalctl --since "2015-01-10" --until "2015-01-11 03:00"`

Seit

`journalctl --since yesterday`

Via Unit seit

`journalctl -u nginx.service --since today`

Über Process

`journalctl _PID=8088`

Log Daten älter als 1 Monat Löschen

`journalctl --vacuum-time=1month`

Speicher verbrauch

`journalctl --disk-usage`

