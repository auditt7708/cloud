---
title: firewalld
description: 
published: true
date: 2021-06-09T15:21:04.391Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:20:58.940Z
---

# Administration mit firewalld


**default Zone ausgeben**

`firewall-cmd --get-active-zones`

**Services einer Zone ausgeben**

`firewall-cmd --zone=public --list-all`

**TCP Port freigeben**

`firewall-cmd --permanent --zone=public --add-port=80/tcp`

**UDP Port freigeben**

`firewall-cmd --permanent --zone=public --add-port=123/udp`

**Aktuelle Konfiguration schreiben**

`firewall-cmd --runtime-to-permanent`

**Änderungen anwenden**

`firewall-cmd --reload`

**Interface wechseln**

`firewall-cmd --permanent --zone=trusted --change-interface=docker0`

**Mehere Services hinzufügen**

`firewall-cmd --zone=internal --add-service={http,https,dns} --permanent`

**Services auflisten**

`firewall-cmd --list-services`

**all zonen auflisten**

`firewall-cmd --get-zones`

**Active zonen auflisten**

`firewall-cmd --get-active-zones`

****