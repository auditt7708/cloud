---
title: podman
description: 
published: true
date: 2021-06-09T15:44:46.763Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:44:41.682Z
---

# Podman

deamonlose container engine die ohne root Berechtigungen ausgeführt werden.

## Kommandos

Pull eines Images

`podman pull docker.io/library/alpine:latest`

Rootles Container

`podman run -d alpine top`

Top für container

`podman exec 5f421b01faa ps -ef`

Pod erstellen

`podman pod create --name mypod`

Container einem Pod hinzufügen

`podman run --detach --pod=mypd alpine:latest top`

`podman ps --all --pod`

Einen einfachencontainer starten

```s
podman run -dt -p 8080:8080/tcp -e HTTPD_VAR_RUN=/var/run/httpd -e HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
                  -e HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
                  -e HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ \
                  registry.fedoraproject.org/f27/httpd /usr/bin/run-httpd
```

## Container Migration

Quell System

```
sudo podman container checkpoint <container_id> -e /tmp/checkpoint.tar.gz
scp /tmp/checkpoint.tar.gz <destination_system>:/tmp
```

Ziel System

```
sudo podman container restore -i /tmp/checkpoint.tar.gz
```

## Quellen

* [pdman Homepage](https://podman.io/)
