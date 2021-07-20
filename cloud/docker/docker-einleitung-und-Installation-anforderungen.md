---
title: docker-einleitung-und-Installation-anforderungen
description: 
published: true
date: 2021-06-09T15:10:34.022Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:10:28.433Z
---

Docker wird auf vielen Linux-Plattformen wie RHEL, Ubuntu, Fedora, CentOS, Debian, Arch Linux und so weiter unterstützt. Es wird auch auf vielen Cloud-Plattformen wie Amazon EC2, Rackspace Cloud und Google Compute Engine unterstützt. Mit Hilfe einer virtuellen Umgebung, Boot2Docker, kann es auch auf OS X und Microsoft Windows laufen. Eine Weile zurück, sagte Microsoft, dass es native Unterstützung für Docker auf seiner nächsten Microsoft Windows-Version hinzufügen würde.

In diesem Rezept überprüfen wir die Anforderungen für die Docker-Installation. Wir werden das System mit der Installation von Fedora 21 überprüfen, obwohl die gleichen Schritte auch auf Ubuntu funktionieren sollten.

#### Fertig werden

Melden Sie sich als root auf dem System mit installiertem Fedora 21 an.

### Wie es geht…

Führen Sie die folgenden Schritte aus:

1.Docker wird nicht auf 32-Bit-Architektur unterstützt. Um die Architektur auf Ihrem System zu überprüfen, führen Sie den folgenden Befehl aus:

```s
$ uname -i
x86_64
```

2.Docker wird auf Kernel 3.8 oder höher unterstützt. Es wurde wieder auf einige der Kernel 2.6, wie RHEL 6.5 und höher portiert. Um die Kernel-Version zu überprüfen, führen Sie den folgenden Befehl aus:

```s
$ uname -r
3.18.7-200.fc21.x86_64
```

3.Der laufende Kernel sollte ein geeignetes Speicher-Backend unterstützen. Einige davon sind VFS, DeviceMapper, AUFS, Btrfs und OverlayFS.

Meistens ist das Standard-Storage-Backend oder -Treiber Devicemapper, der das Device-Mapper Thin Provisioning-Modul verwendet, um Layer zu implementieren. Es sollte standardmäßig auf der Mehrheit der Linux-Plattformen installiert werden. Um den Geräte-Mapper zu überprüfen, können Sie den folgenden Befehl ausführen:

```s
$ grep device-mapper /proc/devices
253 device-mapper
```

In den meisten Distributionen würde AUFS einen modifizierten Kernel benötigen.

4.Unterstützung für Cgroups und Namespaces sind im Kernel für irgendwann und sollte standardmäßig aktiviert sein. Um ihre Anwesenheit zu überprüfen, können Sie sich die entsprechende Konfigurationsdatei des Kernels ansehen, auf dem Sie laufen. Zum Beispiel, auf Fedora, kann ich so etwas wie folgendes tun:

```s
$ grep -i namespaces /boot/config-3.18.7-200.fc21.x86_64
CONFIG_NAMESPACES=y
$ grep -i cgroups /boot/config-3.18.7-200.fc21.x86_64
CONFIG_CGROUPS=y
```

## Wie es funktioniert…

Mit den vorangegangenen Befehlen haben wir die Anforderungen für die Docker-Installation überprüft.
