---
title: jupyterhub
description: 
published: true
date: 2021-06-09T15:27:46.194Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:27:41.342Z
---

# Jupyhter Hub für bis zu 100 Benutzer

Hier eine Server Lösung für bis zu 100 Benutzer:

```s
curl https://raw.githubusercontent.com/jupyterhub/the-littlest-jupyterhub/master/bootstrap/bootstrap.py | sudo -E python3 - --admin <admin-user-name>
```