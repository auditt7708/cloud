---
title: docker-performence-plattenleistung
description: 
published: true
date: 2021-06-09T15:14:37.212Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:14:32.074Z
---

# Docker Platetenleistung

Es gibt Werkzeuge wie Iozone (http://www.iozone.org/), smallfile (https://github.com/bengland2/smallfile) und Flexible IO (https://github.com/axboe/fio) Verfügbar zur Benchmark-Plattenleistung. Für dieses Rezept verwenden wir FIO. Dazu müssen wir eine Job-Datei schreiben, die die Arbeitsbelastung imitiert, die Sie ausführen möchten. Mit dieser Job-Datei können wir die Workload auf dem Ziel simulieren. Für dieses Rezept nehmen wir das FIO-Beispiel aus den Benchmark-Ergebnissen, die IBM veröffentlicht hat (https://github.com/thewmf/kvm-docker-comparison/tree/master/fio).

### Fertig werden

Im Bare-Metal / VM / Docker-Container installieren Sie FIO und mounten den Datenträger mit einem Dateisystem für jeden Test unter `/ferrari` oder alles, was in der FIO-Job-Datei erwähnt wird. Auf blankem Metall können Sie nativ montieren und auf VM kann es mit dem virtuellen Festplattenlaufwerk gemoountet werden oder wir können Gerät durchlaufen lassen. Auf Docker können wir das Dateisystem vom Host-Rechner mit Docker-Volumes anhängen.

Bereiten Sie die Workload-Datei vor. Wir können https://github.com/thewmf/kvm-docker-comparison/blob/master/fio/mixed.fio auswählen:
```
[global]
ioengine=libaio
direct=1
size=16g
group_reporting
thread
filename=/ferrari/fio-test-file

[mixed-random-rw-32x8]
stonewall
rw=randrw
rwmixread=70
bs=4K
iodepth=32
numjobs=8
runtime=60
```

Mit der vorherigen Job-Datei können wir zufällige direkte I/O on `/ferrari/fio-test-file` mit 4K Blockgröße mit dem libaio Treiber auf einer 16 GB Datei machen. Die I/O-Tiefe beträgt 32 und die Anzahl der parallelen Jobs ist 8. Es ist ein Mix Workload, der 70 Prozent liest und 30 Prozent schreibt.

### Wie es geht…

1. Für die Bare-Metal- und VM-Tests können Sie einfach die FIO-Job-Datei ausführen und das Ergebnis sammeln:
`$ fio mixed.fio`

2. Für den Docker-Test können Sie eine Docker-Datei wie folgt vorbereiten:
```
FROM ubuntu
MAINTAINER nkhare@example.com
RUN apt-get update
RUN apt-get -qq install -y fio
ADD mixed.fio /
VOLUME ["/ferrari"]
ENTRYPOINT ["fio"]
```

3. Erstellen Sie nun ein Bild mit folgendem Befehl:
`$ docker build -t docker_fio_perf .`

4. Starten Sie den Container wie folgt, um den Benchmark auszuführen und die Ergebnisse zu sammeln:
$ docker run --rm -v /ferrari:/ferrari docker_fio_perf mixed.fio

5. Beim Ausführen des vorherigen Tests auf Fedora/RHEL/CentOS, wo SELinux aktiviert ist, erhältst du den `Permission denied` Fehler. Um es zu beheben, benennen Sie das Host-Verzeichnis neu, während es in den Container wie folgt gemountet wird:
`$ docker run --rm -v /ferrari:/ferrari:z docker_fio_perf mixed.fio`

### Wie es funktioniert…

FIO wird die in der Jobdatei angegebene Workload ausführen und die Ergebnisse ausgeben.

### Es gibt mehr…

Sobald die Ergebnisse gesammelt sind, können Sie den Ergebnisvergleich durchführen. Sie können sogar verschiedene Arten von E/A Mustern mit der Job-Datei ausprobieren und das gewünschte Ergebnis erhalten.
Siehe auch

Schauen Sie sich die Festplatten-Benchmark-Ergebnisse in IBM und VMware mit FIO in den Links, die weiter unten in diesem Kapitel