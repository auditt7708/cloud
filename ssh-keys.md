---
title: ssh-keys
description: 
published: true
date: 2021-06-09T16:06:33.160Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:06:28.011Z
---

# Arbeiten mit nicht Standart ssh keys

If you used a non-default file path for your GitLab SSH key pair, you must configure your SSH client to find your GitLab SSH private key for connections to your GitLab server (perhaps gitlab.com).

For OpenSSH clients this is configured in the ~/.ssh/config file. Below are two example host configurations using their own key:

Add dir /home/$HOME/.ssh/config if not exists

```s
#!/bin/bash
if [ ! -d /home/$HOME/.ssh/config ]; then
   mkdir /home/$HOME/.ssh/config
fi

```

Inhalt der `config` datei:

```s
# GitLab.com server
Host gitlab.com
RSAAuthentication yes
IdentityFile ~/.ssh/config/private-key-filename-01

# Private GitLab server
Host gitlab.company.com
RSAAuthentication yes
IdentityFile ~/.ssh/config/private-key-filename

```

> Für [Github und Gitlab etc.](../arbeiten-mit-gitlab.md) kann man wie beschrieben die Datei _~/.netrc_ benutzen.
