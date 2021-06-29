---
title: docker-sicherheit-berechtigungen-root
description: 
published: true
date: 2021-06-09T15:16:00.281Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:15:55.059Z
---

In einfachen Worten, mit Fähigkeiten, können wir brechen die Macht eines Root-Benutzer. Von der Manpage für capabilities:

"Für die Durchführung von Berechtigungsprüfungen unterscheiden traditionelle UNIX-Implementierungen zwei Kategorien von Prozessen: privilegierte Prozesse (deren effektive Benutzer-ID 0 ist, die als Superuser oder Root bezeichnet wird) und unprivilegierte Prozesse (deren effektive UID ungleich null ist). Privilegierte Prozesse umgehen alle Kernelberechtigungsprüfungen, während unprivilegierte Prozesse einer vollständigen Berechtigungsprüfung unterzogen werden, die auf den Anmeldeinformationen des Prozesses basiert (normalerweise: effektive UID, effektive GID und ergänzende Gruppenliste).

Beginnend mit Kernel 2.2 teilt Linux die Privilegien, die traditionell mit Superuser verbunden sind, in verschiedene Einheiten, bekannt als Fähigkeiten, die unabhängig aktiviert und deaktiviert werden können. Fähigkeiten sind ein Per-Thread-Attribut."

Einige fähigkeiten sind:

* `CAP_SYSLOG`: Dies ändert das Verhalten von kernel printk

* `CAP_NET_ADMIN`: Das konfiguriert das Netzwerk

* `CAP_SYS_ADMIN`: Das hilft dir, alle Fähigkeiten zu benutzen

Es gibt nur 32 Slots für Fähigkeiten im Kernel. Es gibt eine Möglichkeit, `CAP_SYS_ADMIN`, die alle Fähigkeiten abfängt; Dies wird im Zweifelsfall verwendet.

In Version 1.2 hat Docker einige Funktionen hinzugefügt, um die Fähigkeiten für einen Container hinzuzufügen oder zu entfernen. Es verwendet standardmäßig die Funktionen `chown`, `dac_override`, `fowner`, `kill`, `setgid`, `setuid`, `setpcap`, `net_bind_service`, `net_raw`, `sys_chroot`, `mknod`, `setfcap` und `audit_write` und entfernt standardmäßig die folgenden Funktionen für einen Container.

* `CAP_SETPCAP`: Dies ändert die Prozessfähigkeiten

* `CAP_SYS_MODULE`: Damit werden die Kernelmodule eingefügt / entfernt

* `CAP_SYS_RAWIO`: Dies ändert den Kernel-Speicher

* `CAP_SYS_PACCT`: Dies konfiguriert das Prozess Accounting

* `CAP_SYS_NICE`: Dies ändert die Priorität der Prozesse

* `CAP_SYS_RESOURCE`: Das überschreibt die Ressourcengrenzen

* `CAP_SYS_TIME`: Dies ändert die Systemuhr

* `CAP_SYS_TTY_CONFIG`: Hier werden tty-Geräte konfiguriert

* `CAP_AUDIT_WRITE`: Das schreibt das Audit-Protokoll

* `CAP_AUDIT_CONTROL`: Hiermit wird das Audit-Subsystem konfiguriert

* `CAP_MAC_OVERRIDE`: Dies ignoriert die Kernel-MAC-Richtlinie

* `CAP_MAC_ADMIN`: Dies konfiguriert die MAC-Konfiguration

* `CAP_SYSLOG`: Dies ändert das Verhalten von kernel printk

* `CAP_NET_ADMIN`: Das konfiguriert das Netzwerk

* `CAP_SYS_ADMIN`: Das hilft dir, alle Container zu abzufragen

Wir müssen sehr vorsichtig sein, welche Fähigkeiten wir entfernen, da Anwendungen abstürzen können, wenn sie nicht über genügend Fähigkeiten verfügen, um zu laufen. Um die Funktionen für den Container hinzuzufügen und zu entfernen, können Sie die Optionen `--cap-add` und `--cap-drop` verwenden.

### Fertig werden

Ein Host mit der neuesten Version von Docker muss installiert sein, der über einen Docker-Client muss zugegriffen werden können.

### Wie es geht...

1. Um die Fähigkeiten zu löschen, führen Sie einen Befehl ähnlich dem folgenden aus:
`$ docker run --cap-drop <CAPABILITY> <image> <command>`

Um die `setuid`- und `setgid`-Funktionen aus dem Container zu entfernen, damit es keine Binärdateien ausführen kann, die diese Bits gesetzt haben, führen Sie den folgenden Befehl aus:

`$ docker run -it --cap-drop  setuid --cap-drop setgid fedora bash`

2. Ähnlich, um Fähigkeiten hinzuzufügen, führen Sie einen Befehl ähnlich dem folgenden aus:
`$ docker run --cap-add <CAPABILITY> <image> <command>`

Um alle Fähigkeiten hinzuzufügen und einfach sys-admin zu löschen, führen Sie den folgenden Befehl aus:

`$ docker run -it --cap-add all --cap-drop sys-admin fedora bash`

### Wie es funktioniert…

Vor dem Starten des Containers richtet Docker die Funktionen für den Root-Benutzer im Container ein, der die Befehlsausführung für den Containerprozess beeinflusst.

### Es gibt mehr...

Lassen Sie uns das Beispiel, das wir am Anfang dieses Kapitels gesehen haben, noch einmal durchgehen, dadurch das wir das Host-System durch einen Container heruntergefahren haben. Wurde SELinux auf dem Host-System deaktiviert; Beim Starten des Containers aber lassen Sie die sys_choot-Fähigkeit los:

```
$ docker run -it --cap-drop  sys_chroot -v /:/host  fedora bash
$ shutdown
```

```
setenforce 0
su - dockertest
docker run -it --cap-drop sys_cgroot -v /:/host fedora bash
shutdown
```

### Siehe auch

* Dan Walshs Artikel auf opensource.com unter http://opensource.com/business/14/9/security-for-docker.

* Die Docker 1.2 Release Notes unter http://blog.docker.com/2014/08/announcing-docker-1-2-0/.

* Es gibt Anstrengungen, selektiv Systemaufrufe von Containerprozessen zu deaktivieren, um eine engere Sicherheit zu bieten. Besuchen Sie die Seccomp-Sektion von http://opensource.com/business/15/3/docker-security-future.

* Ähnlich wie benutzerdefinierte Namespaces und Funktionen mit Version 1.6 unterstützt Docker das --cgroup-parent-Flag, um bestimmte Cgroup zum Ausführen von Containern zu übergeben. Https://docs.docker.com/v1.6/release-notes/.