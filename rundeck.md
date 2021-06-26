---
title: rundeck
description: 
published: true
date: 2021-06-09T16:04:04.255Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:03:58.727Z
---

# Datein, Benutzer  und Verzeichnisse

Basisverzeichnis = /var/lib/rundeck
Projektverzeichnis = /var/lib/rundeck/projects

ssh keypath = /var/lib/rundeck/.ssh/id_rsa
ssh User = rundeck

## Administration

User anlegen in Datei _/etc/rundeck/realm.properties_

```sh
admin:YOUR_NEW_PASSWORD,user,admin,architect,deploy,build
```

Quellen

* https://outsideit.net/ssl-rundeck/
* https://docs.rundeck.com/docs/administration/security/authentication.html
* http://rundeck.org/downloads.html
* https://thedataguy.in/rundeck-install-configure-centos-with-mysql/
* 
