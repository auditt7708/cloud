---
title: docker-sicherheit
description: 
published: true
date: 2021-06-09T15:16:31.679Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:16:26.056Z
---

Docker-Container sind eigentlich keine Sandbox-Anwendungen, was bedeutet, dass nicht empfohlen wird, Anwendungen auf dem System als root mit Docker auszuführen. Sie sollten immer einen Container absichern, auf ein Service / Prozess als Service / Prozess läuft, wenn der auf dem Host-System läuft und alle Sicherheitsmaßnahmen in den Container, den Sie auf dem Host-System setzen, ausführen.

Wir haben [Einleitung und Installation](../docker-einleitung-und-Installation) gesehen, wie Docker Namespaces für die Isolation verwendet. Die sechs Namespaces, die Docker verwendet, sind Process, Network, Mount, Hostname, Shared Memory, und User. Nicht alles in Linux ist namespaced, z.B SELinux, Cgroups, Devices (`/dev/mem`, `/dev/sd*`) und Kernel Module. Die Dateisysteme unter `/sys`, `/proc/sys`, `/proc/sysrq-trigger`, `/proc/irq`, `/proc/bus` sind auch nicht namenpaced, sondern sie werden standardmäßig nur mit dem libcontainer executing driver als gelesen.

Um Docker eine sichere Umgebung zu machen, wurde in der jüngsten Vergangenheit viel Arbeit geleistet und mehr Arbeit ist im Gange.

* Da Docker-Images die Grundbausteine sind, ist es sehr wichtig, dass wir das richtige Basisimage auswählen. Docker hat das Konzept der offiziellen Images, die entweder von Docker, dem Entwickler oder jemand anderes gepflegt werden. Wenn Sie sich in [Arbeiten mit Docker Container](../docker-arbeiten-mit-docker) erinnern, können wir Images auf Docker Hub mit der folgenden Syntax durchsuchen:
`$ docker search <image name> `

Betrachten Sie zum Beispiel den folgenden Befehl:
`$ docker search fedora`

Wir sehen eine Spalte `OFFIZIELL`, und wenn die Images offiziell sind, wirst du `[OK]` gegen dieses Image in dieser Spalte sehen. Es gibt eine experimentelle Funktion hinzugefügt in Docker 1.3 (http://blog.docker.com/2014/10/docker-1-3-signed-images-process-injection-security-options-mac-shared-directories/), Was die digitale Signaturüberprüfung der offiziellen Bilder nach dem Download des Images macht. Wenn das Ilage manipuliert wurde, wird der Benutzer benachrichtigt, aber es wird nicht verhindern, dass der Benutzer es ausführt. Gegenwärtig funktioniert diese Funktion nur mit offiziellen Images. Weitere Details über offizielle Images finden Sie unter https://github.com/docker-library/official-images. Das Bild Signier- und Verifikationsmerkmal ist nicht fertig, so dass es jetzt nicht ganz darauf angewiesen ist.

* [Docker APIs und Programmierspach bindungen](../docker-api-programmierung) haben wir gesehen, wie wir die Docker-Remote-API sichern können, wenn der Docker-Daemon-Zugriff über TCP konfiguriert ist.

* Wir können auch die Default-Intercontainer-Kommunikation über das Netzwerk mit `--icc=false` auf dem Docker-Host ausschalten. Obwohl Container immer noch über Links kommunizieren können, die die Standard-DROP-Richtlinie von iptables überschreiben, werden sie mit der Option `--icc=false` gesetzt.

* Wir können auch Cgroups Ressourcenbeschränkungen durchführen, die wir nutzen können um Denial of Service (DoS) Angriffe durch Systemressourcen Beschränkungen zu verhindern.

* Docker nutzt das spezielle Gerät, Cgroups, mit dem wir festlegen können, welche Geräteknoten im Container verwendet werden können. Es blockiert die Prozesse von der Erstellung und Verwendung von Geräteknoten, die zum zugriff auf den Host verwendet werden könnten.

* Nicht Jeder Geräteknoten, der auf dem Image vorbereitet ist, kann verwendet werden, um mit dem Kernel zu sprechen, da Images mit der Option nodev verbunden sind.

Im Folgenden sind einige Richtlinien (möglicherweise nicht vollständig), die man folgen kann, um eine sichere Docker-Umgebung zu haben:

* Führen Sie Dienste als nonroot aus und behandeln Sie die Wurzel im Container sowie außerhalb des Containers als root.

* Verwenden Sie Images von vertrauenswürdigen Parteien, um den Container auszuführen. Vermeiden Sie die Option `-insecure-registry=[]`.

* Führen Sie nicht den zufälligen Container aus dem Docker Registry oder irgendwo anders. Red Hat trägt Patches zum Hinzufügen und Blockieren von Registern, um mehr Kontrolle für Unternehmen zu geben (http://rhelblog.redhat.com/2015/04/15/verständnis-die-veränderung-to-docker-search-and-docker-pull- In-red-hut-enterprise-linux-7-1 /).

* Halte deine Host-Kernel auf dem Laufenden.

* Vermeiden Sie es, soweit wie möglich - Privilegierte ausführungen, und verlassen Sie die Container-Privilegien so schnell wie möglich.

* Konfigurieren Sie die obligatorische Zugriffskontrolle (MAC) über SELinux oder AppArmor.

* Sammeln Sie Protokolle für die Auditierung.

* Regelmäßige Auditierung durchführen

* Führen Sie Container auf Hosts, die speziell für den Betrieb von Containern konzipiert sind. Betrachten Sie die Verwendung von Project Atomic, CoreOS oder ähnlichen Lösungen.

* Mounten Sie die Geräte mit der Option `--device`, anstatt die `--privilegierte` Option zu verwenden, um Geräte im Container zu verwenden.

* Probieren Sie SUID und SGID innerhalb des Containers.

Vor kurzem hat Docker und das Center for Internet Security (http://www.cisecurity.org/) einen Best Practices Guide für die Docker-Sicherheit veröffentlicht, der die meisten der vorstehenden Richtlinien und weitere Richtlinien unter https://blog.docker.com/2015/05/understanding-docker-security-and-best-practices/.

Um den Kontext für einige der Rezepte in diesem Kapitel festzulegen, versuchen wir ein Experiment auf der Standardinstallation auf Fedora 21 mit installiertem Docker.

1. Deaktiviere SELinux mit folgendem Befehl:
`$ sudo setenforce 0`

2. Erstellen Sie einen Benutzer und fügen Sie ihn der Standard-Docker-Gruppe hinzu, damit der Benutzer Docker-Befehle ohne `sudo` ausführen kann:
```
$ sudo useradd dockertest
$ sudo passwd dockertest
$ sudo groupadd docker
$ sudo gpasswd -a dockertest docker
```

3. Melden Sie sich mit dem Benutzer an, den wir früher erstellt haben, und starten Sie einen Container wie folgt:
```
$ su - dockertest
$ docker run -it -v /:/host fedora bash
```

4. Vom Container chroot zum `/host` und führen Sie den Befehl `shutdown` aus:
```
$ chroot /host
$ shutdown
```

`su - dockertest`

Wie wir sehen können, kann ein Benutzer in der Docker-Gruppe das Host-System herunterfahren. Docker verfügt derzeit nicht über eine Berechtigungssteuerung. Wenn du also mit dem Docker-Socket kommunizieren kannst, kannst du jeden Docker-Befehl ausführen. Es ist ähnlich zu `/etc/sudoers`.

`USERNAME ALL=(ALL) NOPASSWD: ALL`

Das ist wirklich nicht gut Mal sehen, wie wir uns im weiteren Verlauf des Kapitels schützen können.

### Übersicht

* [Einstellung der obligatorischen Zugriffskontrolle (MAC) mit SELinux](../docker-sicherheit-selinux-mac)
* [Mit SELinux ON schreiben in volumes vom Hosts erlauben](../docker-sicherheit-selinux-volume)
* [Entfernen von Fähigkeiten, um die Berechtigungen eines Root-Benutzers im Container anzupassen](../docker-sicherheit-berechtigungen-root)
* [Teilen von Namespaces zwischen dem Hosts und dem Container](../docker-sicherheit-namespaces-hosts-container)