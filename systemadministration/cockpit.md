---
title: cockpit
description: 
published: true
date: 2021-06-09T15:01:48.045Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:01:42.998Z
---

# Konfiguration 

Systemctl activiren

```sh
sudo systemctl start cockpit
​sudo systemctl enable cockpit.socket
```



firewalld

```sh
sudo firewall-cmd --add-service=cockpit
​sudo firewall-cmd --add-service=cockpit --permanent
​sudo firewall-cmd --reload
```


[resolv proxy](https://cockpit-project.org/guide/172/cockpit.conf.5.html)

```
[WebService]
Origins = https://somedomain1.com https://somedomain2.com:9090
ProtocolHeader = X-Forwarded-Proto
LoginTitle = 
LoginTo = 
MaxStartups = 
AllowUnencrypted = 
UrlRoot=/secret
```