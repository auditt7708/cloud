---
title: adduser
description: 
published: true
date: 2021-06-09T16:13:08.554Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:13:03.471Z
---

# Benutzer hinzufügen

Das Kommando `_adduser_` dient zum Hinzufügen von Benutzern mit einigen Unterscheidungen
es gibt nämlich Systembenutzer, locale Benutzer und externe Benutze die dann nicht mit adduser verwaltet werden.

User anlegen mit uid 1500

`useradd -u 1500 username`

User mit angepastem Kommentar "GECOS"

`sudo useradd -c "Test User Account" username`

 Benutzer mit einem User Expiry Date anlegen

`sudo useradd -e 2019-01-22 username`

Systemnutzer anlegen

`sudo useradd -r username`

Defaults ausgeben

`useradd -D`