In [Arbeiten mit Docker Images](../docker-arbeiten-mit-docker-images), sahen wir, wie Dockerfiles verwendet werden können, um Images zu erstellen, die aus verschiedenen Diensten / Software und später in [Netzwerk und Daten Management mit Docker](../docker-daten-mgmnt) bestehen. Wir haben gesehen, wie ein Docker-Container mit dem sprechen kann Außenwelt in Bezug auf Daten und Netzwerk. In [Docker praktischer Einsatz möglichkeiten](../docker-praktischer-einsatz)sahen wir in die verschiedenen Anwendungsfälle von Docker, und in [Docker APIs und Programmierspach bindungen](../docker-api-programmierung), sahen wir, wie man Remote-APIs verwenden, um eine Verbindung zu einem Remote-Docker-Host zu verbinden.

Einfache Bedienung alles ist gut , aber bevor man in die Produktion geht, ist die Leistung einer der wichtigsten Aspekte, die berücksichtigt werden. In diesem Kapitel werden wir die Performance-Auswirkungen von Docker sehen und welchen Ansatz wir verfolgen können, um verschiedene Subsysteme zu Benchmark. 
Bei der Leistungsbewertung müssen wir die Leistung von Docker mit folgendem vergleichen:

* Bare metal

* Virtual machine

* Docker läuft innerhalb a virtual machine

Im Kapitel werden wir uns den Ansatz anschauen, den du dir folgen kannst, um Performance-Evaluierung zu machen, anstatt Performance-Zahlen, die von Läufen gesammelt werden, um Vergleich zu machen. Allerdings werde ich auf Vergleichsvergleiche von verschiedenen Firmen hinweisen, auf die Sie sich beziehen können.

Schauen wir uns zuerst an die Docker-Performance-Features:

* Volumes: Beim Ablegen einer Unterrichtsstufe für Unternehmensklassen möchten Sie den zugrunde liegenden Speicher entsprechend stimmen. Sie sollten das primäre / root-Dateisystem nicht verwenden, das von Containern verwendet wird, um Daten zu speichern. Docker bietet die Möglichkeit, externe Speicherung durch Volumes zu befestigen / zu montieren. Wie wir in Kapitel 4, Netzwerk- und Datenmanagement für Container gesehen haben, gibt es zwei Arten von Volumes, die wie folgt sind:

> Volumes, die über Host-Rechner mit der Option --volume montiert werden

> Volumes, die über einen anderen Container mit der Option --volumes-from montiert werden

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

* **Cgroups**: Dockers Standardausführungstreiber, libcontainer, stellt verschiedene Cgroups-Regler frei, mit denen die Container-Performance fein abgestimmt werden kann. Einige von ihnen sind wie folgt:

> **CPU shares**: Damit können wir den Containern proportionales Gewicht verleihen und dementsprechend wird die Ressource geteilt. Betrachten Sie das folgende Beispiel:
`$ docker run -it -c 100 fedora bash`

> **CPUsets**: Damit können Sie CPU-Masken erstellen, mit denen die Ausführung von Threads in einem Container auf Host-CPUs gesteuert wird. Zum Beispiel wird der folgende Code Fäden in einem Container auf dem 0. und 3. Kern laufen:
`$ docker run -it  --cpuset=0,3 fedora bash`

> **Memory limits**: Wir können Speichergrenzen für einen Container einstellen. Beispielsweise beschränkt der folgende Befehl den Speicherverbrauch auf 512 MB für den Container:
`$ docker run -it -m 512M fedora bash`

* **Sysctl and ulimit settings**: In einigen Fällen müssen Sie eventuell einige der sysclt-Werte ändern, je nach Anwendungsfall, um eine optimale Leistung zu erzielen, z. B. das Ändern der Anzahl der geöffneten Dateien. Mit Docker 1.6 (https://docs.docker.com/v1.6/release-notes/) und oben können wir die ulimit-Einstellungen mit folgendem Befehl ändern:
`$ docker run -it --ulimit data=8192 fedora bash`

Der vorherige Befehl ändert die Einstellungen für gerade den gegebenen Behälter, es ist eine pro Behälter-Abstimmungsvariable. Wir können auch einige dieser Einstellungen über die Systemd-Konfigurationsdatei des Docker-Daemons festlegen, die standardmäßig auf alle Container anwendbar ist. Wenn Sie zum Beispiel die Systemd-Konfigurationsdatei für Docker auf Fedora betrachten, sehen Sie im Servicebereich so etwas wie das folgende:
```
LimitNOFILE=1048576  # Open file descriptor setting
LimitNPROC=1048576   # Number of processes settings
LimitCORE=infinity   # Core size settings
```
Sie können dies nach Ihren Bedürfnissen aktualisieren.

Sie können über die Docker-Leistung lernen, indem Sie die Arbeit von anderen erarbeiten. Im vergangenen Jahr wurden einige Docker-Performance-Studien von einigen Unternehmen veröffentlicht:

* Von Red Hat:
Performance-Analyse von Docker auf Red Hat Enterprise Linux:

     Http://developerblog.redhat.com/2014/08/19/performance-analysis-docker-red-hat-enterprise-linux-7/

     Https://github.com/jeremyeder/docker-performance

     Umfassende Übersicht der Speicher-Skalierbarkeit im Docker:

     Http://developerblog.redhat.com/2014/09/30/overview-storage-scalability-docker/

     Beyond Microbenchmarks-Durchbruch Container-Performance mit Tesla Effizienz:

     Http://developerblog.redhat.com/2014/10/21/beyond-microbenchmarks-breakthrough-container-performance-with-tesla-efficiency/

     Containerisierung von Datenbanken mit Red Hat Enterprise Linux:

     Http://rhelblog.redhat.com/2014/10/29/containerizing-databases-with-red-hat-enterprise-linux/

* From IBM

Ein aktualisierter Leistungsvergleich von virtuellen Maschinen und Linux-Containern:

     Http://domino.research.ibm.com/library/cyberdig.nsf/papers/0929052195DD819C85257D2300681E7B/$File/rc25482.pdf

     Https://github.com/thewmf/kvm-docker-comparison

* Von VMware

     Docker Container Leistung in VMware vSphere

     Http://blogs.vmware.com/performance/2014/10/docker-containers-performance-vmware-vsphere.html


Um das Benchmarking zu machen, müssen wir ähnliche Arbeitsbelastungen auf verschiedenen Umgebungen (Bare Metal / VM / Docker) durchführen und dann die Ergebnisse mit Hilfe verschiedener Performance-Statistiken sammeln. Um die Dinge zu vereinfachen, können wir gemeinsame Benchmark-Skripte schreiben, die verwendet werden können, um auf verschiedenen Umgebungen laufen zu können. Wir können auch Dockerfiles erstellen, um Container mit Workload-Generierungsskripts abzureiben. Zum Beispiel hat der Autor in der Performance-Analyse von Docker auf Red Hat Enterprise Linux Artikel, der früher aufgeführt ist (https://github.com/jeremyeder/docker-performance/blob/master/Dockerfiles/Dockerfile), eine Dockerfile verwendet Um ein CentOS-Bild zu erstellen und die Containerumgebungsvariable zu verwenden, um Docker- und Nicht-Docker-Umgebung für das Benchmark-Skript run-sysbench.sh auszuwählen.

Ebenso werden Dockerfiles und verwandte Skripte von IBM für ihre Studie unter https://github.com/thewmf/kvm-docker-comparison veröffentlicht.

Wir werden einige der Docker-Dateien und Skripte verwenden, die zuvor in den Rezepten dieses Kapitels erwähnt wurden.

### Übersicht 

[Benchmarking CPU Leistung](../docker-performence-cpu)

[Benchmarking der Plattenleistung](../docker-performence-plattenleistung)

[Benchmarking Netzwerkleistung](../docker-performence-netzwerkleistung)

[Erhalten der Container-Ressourcennutzung mit der Statistik-Funktion](../docker-performence-container-ressourcennutzung)

[Leistungsüberwachung einrichten](../docker-performence-leistungsueberwachung)