---
title: kubernetes-helm
description: 
published: true
date: 2021-06-09T15:32:58.361Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:32:53.204Z
---


# Helm

Helm ist ein Kubernetes Packetmanager

## Installation auf einem Linux System

```sh
#!/bin/bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

exit 0
```

## Helm Konfigurieren

Initiale Konfigurations einstellungen anlegen.

`helm init`

### Quellen

* [Helm Quickstart](https://github.com/kubernetes/helm/blob/master/docs/quickstart.md)