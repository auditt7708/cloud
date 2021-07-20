---
title: docker-networking-plugins
description: 
published: true
date: 2021-06-09T15:11:37.586Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:11:32.576Z
---

## Docker Netzwerk Plugins

Folgende Plugins sind einsetzbar :

* [weave](https://gitlab.com/tobkern1980/home-net4-environment/wikis/docker-networking-weave-net-install-konfiguration) 
* Project Calico
* Nuage Networks
* Cisco
* VMware
* Microsoft
* Midokura

Um ein Networking plugin zu nutzen müssen wir es folgender massen einbinden

```s
$ docker run -it --publish-service=service.network.cisco ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.vmware ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.microsoft ubuntu:latest /bin/bash
```

