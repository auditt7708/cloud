---
title: ansible-mazer
description: 
published: true
date: 2021-06-09T14:55:51.457Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:55:45.494Z
---

# Installation

Die installation wird mit [Python pip](../python-pip) durchgeführt.

`pip install mazer`

## Konfiguration

Zur konfiguration wird die Datei `~/.ansible/mazer.yml` benutzt die solte im qullverzeichnis stehen. 

Heir eine Beispielkonfiguration vom Hersteller:

```sh
version: 1
server:
  ignore_certs: false
  url: https://galaxy-qa.ansible.com
content_path: ~/.ansible/content
options:
  local_tmp: ~/.ansible/tmp
  role_skeleton_ignore:
     - ^.git$
     - ^.*/.git_keep$
  role_skeleton_path: null
  verbosity: 0
```

Die Optionnen bedeuten folgendes:

### version

Die Konfiguration des benutzen formarts. Default ist 1

### server

Gibt Galaxy Server verbindungs informationen an hier ignore Zertifikate und eine url
Der wert für den  Galaxy server wird hier gesetzt,und der wert von **ignore_certs** wird auf **true** der **false** gesetzt.

### content_path

Geben Sie einen Pfad zu einem Verzeichnis im lokalen Dateisystem an, in dem Ansible-Inhalte installiert werden. Der Standardwert ist `~/ .ansible/content`

### options

Verschiedene Konfigurationsoptionen werden hier festgelegt, einschließlich: local_tmp, role_skeleton, role_skeleton_path, verbosity.

### local_tmp

Pfad, den Mazer für temporären Arbeitsbereich verwenden kann, um beispielsweise Archivdateien zu erweitern.

### role_skeleton_path

Pfad zu einer Rollenstruktur, die mit dem Befehl init verwendet werden soll. Überschreibt die Standardrollenstruktur.

### role_skeleton_ignore

Liste der Dateinamensmuster, die beim Kopieren des Inhalts des Rollen-Skelettpfads ignoriert werden sollen.

### verbosity

Steuert den Standardwert der von Mazer zurückgegebenen Ausgabe.
