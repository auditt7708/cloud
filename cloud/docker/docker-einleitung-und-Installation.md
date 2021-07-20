---
title: docker-einleitung-und-Installation
description: 
published: true
date: 2021-06-09T15:11:14.123Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:11:08.477Z
---

# Docker Einleitung und INstallation

Zu Beginn der IT-Revolution wurden die meisten Anwendungen direkt auf der physischen Hardware, über das Host-Betriebssystem eingesetzt. Wegen dieses einzelnen Benutzerraums wurde die Laufzeit zwischen den Anwendungen geteilt. Der Einsatz war stabil, hardware-centric und hatte einen langen Wartungszyklus. Es wurde überwiegend von einer IT-Abteilung geleitet und hat den Entwicklern viel weniger Flexibilität gegeben. In solchen Fällen wurden Hardwareressourcen regelmäßig nicht ausgelastet.

Das folgende Diagramm zeigt eine solche Einrichtung:

![docker-stack](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_01.jpg)

Traditionelle Anwendungsbereitstellung (https://rhsummit.files.wordpress.com/2014/04/rhsummit2014-application-centric_packaging_with_docker_and_linux_containers-20140412riek7.pdf)

Um die Einschränkungen des traditionellen Einsatzes zu überwinden, wurde die Virtualisierung erfunden. Mit Hypervisoren wie KVM, XEN, ESX, Hyper-V und so weiter emulierten wir die Hardware für virtuelle Maschinen (VMs) und setzten ein Gastbetrieb auf jeder virtuellen Maschine ein. VMs können ein anderes Betriebssystem als ihr Host haben; Das heißt, wir sind verantwortlich für die Verwaltung der Patches, Sicherheit und Leistung dieser VM. Bei der Virtualisierung werden die Applikationen auf VM-Ebene isoliert und durch den Lebenszyklus von VMs definiert. Dies führt zu einem besseren Return on Investment und einer höheren Flexibilität auf Kosten der erhöhten Komplexität und Redundanz. Das folgende Diagramm zeigt eine typisierte virtualisierte Umgebung:

![docker-stack2](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_02.jpg)

Anwendungsbereitstellung in einer virtualisierten Umgebung (https://rhsummit.files.wordpress.com/2014/04/rhsummit2014-application-centric_packaging_with_docker_and_linux_containers-20140412riek7.pdf)

Nach der Virtualisierung bewegen wir uns nun auf eine anwendungsorientierte IT. Wir haben die Hypervisor-Schicht entfernt, um Hardware-Emulation und Komplexität zu reduzieren. Die Anwendungen werden mit ihrer Laufzeitumgebung verpackt und werden mit Containern eingesetzt. OpenVZ, Solaris Zones und LXC sind ein paar Beispiele für Containertechnik. Container sind weniger flexibel im Vergleich zu VMs; Zum Beispiel können wir Microsoft Windows nicht auf einem Linux-Betriebssystem ausführen. Container gelten auch als weniger sicher als VMs, denn bei Containern läuft alles auf dem Host-Betriebssystem. Wenn ein Container kompromittiert wird, dann ist es möglich, den vollen Zugriff auf das Host-Betriebssystem zu erhalten. Es kann ein bisschen zu komplex sein, um aufzubauen, zu verwalten und zu automatisieren. Das sind ein paar Gründe, warum wir in den letzten Jahren die Massenübernahme von Containern nicht gesehen haben, obwohl wir die Technik hatten.

![docker-stack3](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_03.jpg)
Anwendungsbereitstellung mit Containern (https://rhsummit.files.wordpress.com/2014/04/rhsummit2014-application-centric_packaging_with_docker_and_linux_containers-20140412riek7.pdf)

Mit Docker wurden die Container plötzlich erstklassige Bürger. Alle großen Unternehmen wie Google, Microsoft, Red Hat, IBM und andere arbeiten jetzt, um Container Mainstream zu machen.

Docker wurde als internes Projekt von Solomon Hykes gestartet, der die aktuelle CTO von Docker, Inc., bei dotCloud ist. Es wurde als Open Source im März 2013 unter der Apache 2.0 Lizenz veröffentlicht. Mit der dotCloud-Plattform als Serviceerfahrung waren die Gründer und Ingenieure von Docker auf die Herausforderungen von Containern aufmerksam. So mit Docker, sie entwickelten eine Standard-Weg, um Container zu verwalten.

Docker verwendet Linux's zugrunde liegende Kernel-Features, die die Containerisierung ermöglichen. Das folgende Diagramm zeigt die Ausführungstreiber und Kernelfunktionen, die von Docker verwendet werden. Wir werden später über Führungskräfte sprechen. Schauen wir uns einige der wichtigsten Kernel-Features an, die Docker benutzt:
![docker-driver](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_04.jpg)

Die Ausführungstreiber und Kernel-Funktionen, die von Docker (http://blog.docker.com/wp-content/uploads/2014/03/docker-execdriver-diagram.png) verwendet werden,

Namensräume

Namensräume sind die Bausteine ​​eines Containers. Es gibt verschiedene Arten von Namespaces und jeder von ihnen isoliert Anwendungen von einander. Sie werden mit dem Klon-Systemaufruf erstellt. Man kann auch an bestehende Namespaces anhängen. Einige der von Docker verwendeten Namespaces wurden in den folgenden Abschnitten erläutert.
Der pid-Namespace

Der pid-Namespace erlaubt jedem Container eine eigene Prozessnummerierung. Jeder pid bildet seine eigene Prozesshierarchie. Ein übergeordneter Namensraum kann die Kinder-Namespaces sehen und sie beeinflussen, aber ein Kind kann weder den übergeordneten Namespace sehen noch ihn beeinflussen.

Wenn es zwei Ebenen der Hierarchie gibt, dann auf der obersten Ebene, würden wir sehen, ein Prozess läuft innerhalb des Kind-Namespace mit einem anderen PID. Also, ein Prozess, der in einem Kind-Namespace läuft, hätte zwei PIDs: eine im Kind-Namespace und die andere im übergeordneten Namespace. Zum Beispiel, wenn wir ein Programm auf dem Container (container.sh) ausführen, dann können wir auch das entsprechende Programm auf dem Host sehen.

Am container:
`ps aux | grep container`

Am Host:
`ps aux | grep container`

## Der Netznamensraum

Mit dem `pid`-Namespace können wir das gleiche Programm mehrmals in verschiedenen isolierten Umgebungen ausführen; Zum Beispiel können wir verschiedene Fälle von Apache auf verschiedenen Behältern ausführen. Aber ohne den `net`-Namespace, würden wir nicht in der Lage sein, auf Port 80 auf jedem von ihnen zu hören. Der `net`-Namespace erlaubt uns, auf jedem Container unterschiedliche Netzwerkschnittstellen zu haben, was das Problem, das ich bereits erwähnt habe, löst. Loopback-Schnittstellen wären in jedem Container auch anders.

Um die Vernetzung in Containern zu ermöglichen, können wir in zwei verschiedenen `net`-Namespaces Paare von speziellen Schnittstellen erstellen und ihnen erlauben, miteinander zu sprechen. Ein Ende der speziellen Schnittstelle befindet sich im Container und das andere im Host-System. Im Allgemeinen wird die Schnittstelle innerhalb des Containers `eth0` genannt, und im Host-System wird ihm ein zufälliger Name wie `vethcf1a` gegeben. Diese speziellen Schnittstellen werden dann über eine Brücke (`docker0`) auf dem Host verbunden, um die Kommunikation zwischen Containern und Routenpaketen zu ermöglichen.

Innerhalb des Containers würden Sie so etwas wie folgendes sehen:

`ip a`

Innerhalb des Containers würden Sie so etwas wie folgendes sehen:

`ip a`

Also, each net namespace has its own routing table and firewall rules.

Außerdem hat jeder net namespace eine eigene Routingtabelle und Firewall-Regeln.

### Der ipc-Namespace

**Inter Process Communication (ipc)** bietet Semaphoren, Nachrichtenwarteschlangen und Shared Memory Segmente. Es ist nicht weit verbreitet in diesen Tagen, aber einige Programme immer noch davon abhängen.

Wenn die von einem Container erstellte `ipc`-Ressource von einem anderen Container verbraucht wird, kann die Anwendung, die auf dem ersten Container ausgeführt wird, fehlschlagen. Mit dem `ipc`-Namespace können Prozesse, die in einem Namespace ausgeführt werden, nicht auf Ressourcen aus einem anderen Namespace zugreifen.

### Der Mnt-Namespace

Mit nur einer chroot kann man die relativen Pfade des Systems aus einem chrootierten directory/namespace inspizieren. Der `mnt`-Namespace nimmt die Idee einer Chroot auf die nächste Ebene. Mit dem `mnt`-Namespace kann ein Container einen eigenen Satz von gemounteten Dateisystemen und Root-Verzeichnissen haben. Prozesse in einem `mnt`-Namespace können die installierten Dateisysteme eines anderen Mnt-Namespaces nicht sehen.

### Der uts namespace

Mit dem `uts`-Namespace können wir für jeden Container unterschiedliche Hostnamen haben.

### Der Benutzernamenpace

Mit `User`-Namespace-Unterstützung können wir Benutzer haben, die eine Nonzero-ID auf dem Host haben, aber eine Null-ID im Container haben können. Dies liegt daran, dass der `user` namenpace pro Namespace-Zuordnung von Benutzern und Gruppen-IDs erlaubt.

Es gibt Möglichkeiten, Namespaces zwischen Host und Container und Container und Container zu teilen. Wir werden sehen, wie wir das in den folgenden Kapiteln machen können.

## Cgroups

**Kontrollgruppen (Cgroups)** bieten Ressourcenbeschränkungen und Buchhaltung für Container. Aus der Linux Kernel Dokumentation:

Kontrollgruppen bieten einen Mechanismus für die aggregating/partitioning von Aufgaben und all ihren zukünftigen Kindern in hierarchische Gruppen mit spezialisiertem Verhalten.

In einfachen Worten können sie mit dem Befehl `ulimit` shell oder dem `setrlimit` Systemaufruf verglichen werden. Anstatt die Ressourcengrenze auf einen einzelnen Prozess zu setzen, erlauben cgroups die Begrenzung von Ressourcen auf eine Gruppe von Prozessen.

Kontrollgruppen werden in verschiedene Subsysteme aufgeteilt, wie CPU, CPU-Sets, Speicherblock I / O und so weiter. Jedes Subsystem kann unabhängig verwendet werden oder kann mit anderen gruppiert werden. Die Features, die cgroups bieten, sind:

* Resource limiting(Ressourcenbegrenzung): Zum Beispiel kann eine Cruppe an bestimmte CPUs gebunden werden, so dass alle Prozesse in dieser Gruppe nur bei CPUs ablaufen würden

* Prioritization(Priorisierung): Einige Gruppen können einen größeren Anteil an CPUs erhalten

* Accounting(Buchhaltung): Sie können die Ressourcennutzung verschiedener Subsysteme für die Abrechnung messen

* Control(Kontrolle): Einfrieren und Neustart von Gruppen

Einige der Subsysteme, die von cgroups verwaltet werden können, sind wie folgt:

* Blkio: Es setzt I / O-Zugriff auf und von Block-Geräte wie Festplatte, SSD, und so weiter

* Cpu: Es beschränkt den Zugriff auf CPU

* Cpuacct: Es erzeugt CPU-Ressourcenauslastung

* Cpuset: Es ordnet die CPUs auf einem Multicore-System den Aufgaben in einer Cgroup zu

* Devices: Es erkennt den Zugriff auf eine Reihe von Aufgaben in einer Cgroup

* Freezer: Es unterbricht oder nimmt Aufgaben in einer Cgroup auf

* Memory: Es setzt Grenzen für die Speicherbenutzung durch Aufgaben in einer Cgroup

Es gibt mehrere Möglichkeiten, die Arbeit mit cgroups zu kontrollieren. Zwei der beliebtesten greifen auf das virtuelle Dateisystem der Gruppe zu und greifen mit der `libcgroup`-Bibliothek auf sie zu. Um `libcgroup` in fedora zu verwenden, führen Sie den folgenden Befehl aus, um die erforderlichen Pakete zu installieren:
`$ sudo yum install libcgroup libcgroup-tools`

Nach der Installation können Sie die Liste der Subsysteme und ihren Mount-Punkt im Pseudo-Dateisystem mit folgendem Befehl abrufen:
`$ lssubsys -M`

Obwohl wir die tatsächlichen Befehle noch nicht gesehen haben, gehen wir davon aus, dass wir ein paar Container laufen und die Cgroup-Einträge für einen Container erhalten möchten. Um diese zu bekommen, müssen wir zuerst die Container-ID bekommen und dann den Befehl lscgroup verwenden, um die Cgroup-Einträge eines Containers zu erhalten, die wir aus dem folgenden Befehl erhalten können:

## Hinweis

Weitere Informationen finden Sie unter https://docs.docker.com/articles/runmetrics/.

## Das Union Dateisystem

Das Dateisystem der Union ermöglicht es, die Dateien und Verzeichnisse von separaten Dateisystemen, die als Ebenen bekannt sind, transparent zu überlagern, um ein neues virtuelles Dateisystem zu erstellen. Beim Starten eines Containers überlagert Docker alle an einem Bild angehängten Layer und erstellt ein schreibgeschütztes Dateisystem. Darüber hinaus erstellt Docker eine Lese- / Schreibschicht, die von der Laufzeitumgebung des Containers verwendet wird. Schau dir das Bild an und laufe ein Containerrezept dieses Kapitels für weitere Details. Docker kann mehrere Union-Dateisystemvarianten verwenden, einschließlich AUFS, Btrfs, vfs und DeviceMapper.

Docker kann mit verschiedenen Ausführungsfahrern arbeiten, wie z.B. `libcontainer`, `lxc` und `libvirt`, um Container zu verwalten. Der Default-Treiber ist `libcontainer`, der mit Docker aus der Box kommt. Es kann Namespaces, Kontrollgruppen, Fähigkeiten und so weiter für Docker manipulieren.

### Übersicht

* [Überprüfen der Anforderungen für die Docker-Installation](../docker-einleitung-und-Installation-anforderungen)

* [Docker installieren](../docker-einleitung-und-Installation-installieren)

* [Ziehen eines Bildes und Ausführen eines Containers](../docker-einleitung-und-Installation-build)

* [Hinzufügen eines Nonroot-Benutzers zum Verwalten von Docker](../docker-einleitung-und-Installation-user)

* [Einrichten des Docker-Hosts mit Docker-Maschine](../docker-einleitung-und-Installation-hosts-maschine)

* [Hilfe mit der Docker-Befehlszeile finden](../docker-einleitung-und-Installation-Befehlszeile)
