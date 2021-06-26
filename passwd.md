---
title: passwd
description: 
published: true
date: 2021-06-09T15:44:10.107Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:44:05.103Z
---

# Änderung des Passworts eines Benutzers

Infos zu allen Benutzen

`passwd -S $USER`

> Info:**L** = gesperrtes Passwort **NP** = kein Passwort **P** =  gültiges Passwort

Nur abgelaufene tokensanpassen

`passswd -k`

Pw Änderung via stin

`passwd --stin | echo $PW`

