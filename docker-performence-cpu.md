Wir können Benchmarks wie Linpack (http://www.netlib.org/linpack/) und sysbench (https://github.com/nuodb/sysbench) verwenden, um die CPU-Leistung zu bestimmen. Für dieses Rezept verwenden wir sysbench. Wir werden sehen, wie man den Benchmark auf nacktem Metall und in den Container führt. Ähnliche Schritte können in anderen Umgebungen durchgeführt werden, wie bereits erwähnt.

### Fertig werden

Wir verwenden den CentOS 7 Container, um den Benchmark im Container durchzuführen. Idealerweise sollten wir ein System mit CentOS 7 installiert haben, um Benchmark-Ergebnisse auf Bare Metall zu erhalten. Für den Containertest bauen wir das Image aus dem GitHub-Repository, das wir früher erwähnt haben:

```
$ git clone https://github.com/jeremyeder/docker-performance.git 
$ cd docker-performance/Dockerfiles/
$ docker build -t c7perf --rm=true - < Dockerfile
$ docker images 
REPOSITORY           TAG            IMAGE ID          CREATED              VIRTUAL SIZE 
c7perf              latest         59a10df39a82    About a minute ago         678.3 MB 
```

### Wie es geht…

Innerhalb des gleichen GitHub-Repositorys haben wir ein Skript, um sysbench, docker-performance/bench/sysbench/run-sysbench.sh auszuführen. Es hat einige Konfigurationen, die Sie je nach Bedarf ändern können.

1. Als Root-Benutzer erstellen Sie das Verzeichnis `/results` auf dem Host:
`$ mkdir -p /results`

Führen Sie nun den Benchmark aus, nachdem Sie die Containerumgebungsvariable auf etwas anderes als Docker gesetzt haben, das wir beim Erstellen des `c7perf` Images auf dem Hostcomputer verwendet haben, führen Sie die folgenden Befehle aus:

```
$ cd docker-performance/bench/sysbench
$ export container=no
$ sh ./run-sysbench.sh  cpu test1
```

Standardmäßig werden die Ergebnisse in `/results` gesammelt. Vergewissern Sie sich, dass Sie einen Schreibzugriff darauf haben oder den `OUTDIR` Parameter im Benchmark-Skript ändern.

2. Um den Benchmark im Container auszuführen, müssen wir zuerst den Container starten und dann das Benchmark-Skript ausführen:
```
$ mkdir /results_container
$ docker run -it -v /results_container:/results c7perf bash 
$ docker-performance/bench/sysbench/run-sysbench.sh cpu test1

```

Als wir das Host-Verzeichnis `/results_container` im Inneren des `/results` Containers `,` installiert haben, wird das Ergebnis auf dem Host gesammelt.

3. Beim Ausführen des vorherigen Tests auf Fedora / RHEL / CentOS, wo SELinux aktiviert ist, erhältst du einen `Permission denied` Fehler. Um es zu beheben, das Host-Verzeichnis neu zu erfassen, während es in den Container wie folgt montiert wird:
`$ docker run -it -v /results_container:/results:z c7perf bash`

Alternativ dazu setzen wir SELinux vorläufig in den zulässigen Modus:
`$  setenforce 0`

Dann, nach dem Test, setze es wieder in den permissive Modus:
`$  setenforce 1`

### Wie es funktioniert…

Das Benchmark-Skript ruft intern den CPU-Benchmark der sysbench für den gegebenen Eingang auf. Die CPU wird durch die Verwendung der 64-Bit-Integer-Manipulation mit Euklid-Algorithmen zur Primzahlenberechnung gbenchmarkt. 
Das Ergebnis für jeden Lauf wird im entsprechenden Ergebnisverzeichnis gesammelt, das zum Vergleich verwendet werden kann.

### Es gibt mehr…

Fast kein Unterschied wird in bare metal und Docker CPU Leistung berichtet.

### Siehe auch

* Schauen Sie sich die in IBM und VMware veröffentlichten CPU-Benchmark-Ergebnisse mit Linpack in den Links an, auf die in diesem Kapitel verwiesen wird.
