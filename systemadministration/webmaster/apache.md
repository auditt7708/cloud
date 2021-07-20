---
title: apache
description: 
published: true
date: 2021-06-09T14:57:12.566Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:57:07.356Z
---

# Apache starten als unprviligierter Benutzer

```sh
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2
sudo /etc/init.d/apache2 stop
sudo chown -R www-data: /var/{log,run}/apache2/
sudo -u www-data apache2ctl start
```

## Apache Reverse Proxy Server

**Quelle**

`https://askubuntu.com/questions/694036/apache-as-non-root`
