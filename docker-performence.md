In [Arbeiten mit Docker Images](../docker-arbeiten-mit-docker-images), sahen wir, wie Dockerfiles verwendet werden können, um Images zu erstellen, die aus verschiedenen Diensten / Software und später in [Netzwerk und Daten Management mit Docker](../docker-daten-mgmnt) bestehen. Wir haben gesehen, wie ein Docker-Container mit dem sprechen kann Außenwelt in Bezug auf Daten und Netzwerk. In [Docker praktischer Einsatz möglichkeiten](../docker-praktischer-einsatz)sahen wir in die verschiedenen Anwendungsfälle von Docker, und in [Docker APIs und Programmierspach bindungen](../docker-api-programmierung), sahen wir, wie man Remote-APIs verwenden, um eine Verbindung zu einem Remote-Docker-Host zu verbinden.

Einfache Bedienung alles ist gut , aber bevor man in die Produktion geht, ist die Leistung einer der wichtigsten Aspekte, die berücksichtigt werden. In diesem Kapitel werden wir die Performance-Auswirkungen von Docker sehen und welchen Ansatz wir verfolgen können, um verschiedene Subsysteme zu Benchmark. 
Bei der Leistungsbewertung müssen wir die Leistung von Docker mit folgendem vergleichen:

* Bare metal

* Virtual machine

* Docker läuft innerhalb a virtual machine

Im Kapitel werden wir uns den Ansatz anschauen, den du dir folgen kannst, um Performance-Evaluierung zu machen, anstatt Performance-Zahlen, die von Läufen gesammelt werden, um Vergleich zu machen. Allerdings werde ich auf Vergleichsvergleiche von verschiedenen Firmen hinweisen, auf die Sie sich beziehen können.

Schauen wir uns zuerst an die Docker-Performance-Features:

* Volumes: Beim Ablegen einer Unterrichtsstufe für Unternehmensklassen möchten Sie den zugrunde liegenden Speicher entsprechend stimmen. Sie sollten das primäre / root-Dateisystem nicht verwenden, das von Containern verwendet wird, um Daten zu speichern. Docker bietet die Möglichkeit, externe Speicherung durch Volumes zu befestigen / zu montieren. Wie wir in Kapitel 4, Netzwerk- und Datenmanagement für Container gesehen haben, gibt es zwei Arten von Volumes, die wie folgt sind:

* > Volumes, die über Host-Rechner mit der Option --volume montiert werden

* > Volumes, die über einen anderen Container mit der Option --volumes-from montiert werden

* **Storage drivers**: Wir haben verschiedene Speicher-Treiber in Kapitel 1, Installation und Einführung, die vfs, aufs, btrfs, devicemapper und overlayFS sind. Die Unterstützung für ZFS wurde vor kurzem auch zusammengeführt. Sie können die aktuell unterstützten Speichertreiber und ihre Priorität der Auswahl überprüfen, wenn nichts als Docker-Startzeit unter https://github.com/docker/docker/blob/master/daemon/graphdriver/driver.go gewählt wird.

Wenn Sie Fedora, CentOS oder RHEL ausführen, dann ist der Geräte-Mapper der Standard-Speicher-Treiber. Sie finden einige Geräte-Mapperspezifische Tuning unter https://github.com/docker/docker/tree/master/daemon/graphdriver/devmapper.

Sie können den Standardspeichertreiber mit der Option -s zum Docker-Daemon ändern. Sie können die verteilungsspezifische Konfigurations- / Systemdatei aktualisieren, um Änderungen während des Dienstneustarts vorzunehmen. Für Fedora / RHEL / CentOS hast du das Update OPTIONS Feld in / etc / sysconfig / docker. Etwas wie das folgende, um das btrfs backend zu benutzen:

`OPTIONS=-s btrfs`

Die folgende Grafik zeigt Ihnen, wie viel Zeit es braucht, um 1000 Container mit verschiedenen Konfigurationen des Speichertreibers zu starten und zu stoppen:

![redhat-storage-scalability-docker](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_07_01.jpg)
http://developerblog.redhat.com/2014/09/30/overview-storage-scalability-docker/

Wie Sie sehen können, führt OverlayFS besser als andere Speichertreiber.

* **--net=host**: Wie wir wissen, schafft Docker standardmäßig eine Brücke und verknüpft IPs von ihm zu den Containern. Mit `--net=host` stellt den Host-Netzwerk-Stack dem Container vor, indem er die Erstellung eines Netzwerk-Namespaces für den Container überspringt. Daraus ist klar, dass diese Option immer bessere Leistung im Vergleich zu den überbrückten bietet.

Dies hat einige Einschränkungen, wie nicht in der Lage, zwei Container oder Host-Anwendungen auf dem gleichen Port zu hören.
### Übersicht

[Benchmarking CPU Leistung](../docker-performence-cpu)

[Benchmarking der Plattenleistung](../docker-performence-plattenleistung)

[Benchmarking Netzwerkleistung](../docker-performence-netzwerkleistung)

[Erhalten der Container-Ressourcennutzung mit der Statistik-Funktion](../docker-performence-container-ressourcennutzung)

[Leistungsüberwachung einrichten](../docker-performence-leistungsueberwachung)