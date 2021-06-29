---
title: ssh
description: 
published: true
date: 2021-06-09T16:06:40.194Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:06:35.545Z
---

# SSH Server Einrichten

ssh agent für Passphrase benutzen

1. ssh agent im hintergrund starten

    `eval "$(ssh-agent -s)"`

2. SSH Private Key zum SSH Agent hinzufügen

   `ssh-add ~/.ssh/id_rsa`

danch prüfen ob das Zielsystem funktioniert