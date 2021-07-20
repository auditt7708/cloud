---
title: docker-arbeiten-images-debootstrap
description: 
published: true
date: 2021-06-09T15:05:41.621Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:05:36.717Z
---

# Docker Arbeiten mit Images: debootstrap

Debootstrap ist ein Tool zum Installieren eines Debian-basierten Systems in einem Verzeichnis eines bereits installierten Systems.

## Fertig werden

Installiere debootstrap auf dem Debian-basierten System mit folgendem Befehl:
`$ apt-get install debootstrap`

### Wie es geht…

Mit dem folgenden Befehl können Sie das Basisbild mit Debootstrap erstellen:
`$ debootstrap [OPTION...]  SUITE TARGET [MIRROR [SCRIPT]]`

`SUITE` bezieht sich auf den Release-Code-Namen und `MIRROR` ist das jeweilige Repository.
Wenn Sie das Basisbild von Ubuntu 14.04.1 LTS (Trusty Tahr) erstellen möchten, dann gehen Sie wie folgt vor:

1.Erstellen Sie ein Verzeichnis, auf dem Sie das Betriebssystem installieren möchten. Debootstrap schafft auch die Chroot-Umgebung, um ein Paket zu installieren, wie wir früher mit supermin gesehen haben.
`$ mkdir trusty_chroot`

2.Jetzt, mit `debootstrap`, installiere Trusty Tahr in dem Verzeichnis, das wir früher erstellt haben:

`$ debootstrap trusty ./trusty_chroot http://in.archive.ubuntu.com/ubuntu/`

3.Sie sehen den Verzeichnisbaum ähnlich einem Linux-Root-Dateisystem, in dem Verzeichnis, in dem Trusty Tahr installiert ist.

```sh
$ ls ./trusty_chroot
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

4.Jetzt können wir das Verzeichnis als Docker-Image mit folgendem Befehl exportieren:
`$ tar -C trusty_chroot/ -c . |  docker import - nkhare/trusty_base`

5.Schauen Sie sich die `docker images` an. Du solltest ein neues Bild mit `nkhare/trusty_base` als den Namen haben.

### Siehe auch

* Es gibt noch ein paar Möglichkeiten, [Basisbilder zu erstellen.](https://docs.docker.com/articles/baseimages/).
