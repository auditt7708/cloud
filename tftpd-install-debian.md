---
title: tftpd-install-debian
description: 
published: true
date: 2021-06-09T16:08:29.653Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:08:24.508Z
---


# tftpd Installation unter Debian

Die Konfiguration sollte  in der Datei `/etc/default/tftpd-hpa` wie folgt aussehen:

```s
  TFTP_USERNAME="tftp"
  TFTP_DIRECTORY="/srv/tftp"
  TFTP_ADDRESS="0.0.0.0:69"
  TFTP_OPTIONS="--secure"

```

In vielen Beschreibungen zur Installation steht noch etwas von `RUN_DAEMON="yes"` was man einfach Ignorieren darf.

## Info

meist must noch mit
`systemctl enable tftpd-hpa`
der deamon zum automatischen starten bewegt werden.