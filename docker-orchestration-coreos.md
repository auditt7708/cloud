CoreOS (https://coreos.com/) ist eine Linux-Distribution, für Container wie Docker angepasst wurde, um die notwendigen Funktionen für den Betrieb moderner Infrastruktur-Stacks bereitzustellen. Es ist Apache 2.0 lizenziert. Es hat ein Produkt namens CoreOS Managed Linux (https://coreos.com/products/managed-linux/), für das das CoreOS-Team kommerzielle Unterstützung bietet.

Im Wesentlichen bietet CoreOS Plattformen, um einen kompletten Anwendungs stapel zu hosten. Wir können CoreOS auf verschiedenen Cloud-Anbietern, bare metal und in der VM-Umgebung aufbauen. Schauen wir uns die Bausteine von CoreOS an:

* etcd
* Container Laufzeitumgebubng
* Systemd
* Fleet

Lassen Sie uns im Einzelnen besprechen:

>* **etcd**: Von der GitHub-Seite von etcd (https://github.com/coreos/etcd/#etcd). Etcd ist ein hoch >verfügbarer Key-Value-Store für gemeinsame Konfiguration und Service Discovery. Es ist inspiriert von >Apache ZooKeeper und Doozer. :
>
>> * **Simple**: Curl-fähige User-API (HTTP plus JSON)
>> * **Secure**: Optional SSL client certificate authentication
>> *   **Fast**: Benchmark von 1.000s von Schriften pro Instanz 
>> * **Reliable**: Richtige Verteilung mit Raft
> 
> Es ist in Go geschrieben und verwendet den Raft Consensus Algorithmus (https://raftconsensus.github.io/), > um ein hochverfügbares repliziertes Protokoll zu verwalten.
> Etcd kann unabhängig von CoreOS verwendet werden. Wir können:
>
>> * Einen Einzel- oder Multinode-Cluster einrichten. Weitere Informationen hierzu finden Sie unter https://github.com/coreos/etcd/blob/master/Documentation/clustering.md.
>>
>> * Zugriff mit CURL und verschiedenen Bibliotheken, närares unter https://github.com/coreos/etcd/blob/master/Documentation/libraries-and-tools.md. 
> 
> * **Container runtime**: CoreOS unterstützt Docker als Container-Laufzeitumgebung. Im Dezember 2014 gab CoreOS eine neue Container-Laufzeit Rocket (https://coreos.com/blog/rocket/) bekannt. Lassen Sie uns unsere Diskussion auf Docker beschränken, die derzeit auf allen CoreOS-Maschinen installiert ist.
> * **systemd**: `Systemd` ist ein init-System zum Starten, Stoppen und Verwalten von Prozessen. In CoreOS ist es gewohnt:
>> 
>> * Starten Sie Docker-Container
>> 
>> * Registrieren von Diensten, wie von Containern in etc
>> 
>> Systemd verwaltet Unit-Dateien. Eine Beispiel unit datei sieht wie folgt aus:
```
[Unit] 
Description=Docker Application Container Engine 
Documentation=http://docs.docker.com 
After=network.target docker.socket 
Requires=docker.socket 

[Service] 
Type=notify 
EnvironmentFile=-/etc/sysconfig/docker 
EnvironmentFile=-/etc/sysconfig/docker-storage 
ExecStart=/usr/bin/docker -d -H fd:// $OPTIONS $DOCKER_STORAGE_OPTIONS 
LimitNOFILE=1048576 
LimitNPROC=1048576 

[Install] 
WantedBy=multi-user.target 
```
>Diese unit datei startet den Docker Daemon mit dem Befehl `ExecStart`, der auf Fedora 21 erwähnt wird. Der Docker-Daemon startet nach dem `network target` und den `docker socket` Diensten. `docker socket` ist eine Voraussetzung für den Docker-Daemon. Systemd targets sind Möglichkeiten, Prozesse zu gruppieren, damit sie gleichzeitig starten können. `multi-user` ist eines der targets, mit denen die vorherige unit datei registriert ist. Für weitere Details können Sie sich die Upstream-Dokumentation von Systemd unter http://www.freedesktop.org/wiki/Software/systemd/ ansehen.
>
> * **Fleet**: Fleet (https://coreos.com/using-coreos/clustering/) ist der Cluster-Manager, der System auf der Cluster-Ebene steuert. Systemd Unit-Dateien werden mit einigen flottenspezifischen Eigenschaften kombiniert, um das Ziel zu erreichen. Aus der Flottendokumentation (https://github.com/coreos/fleet/blob/master/Documentation/architecture.md):
>
> Zitat: 
> "Jedes System im fleet-Cluster läuft mit einem einzigen `fleetd` Daemon, jeder Dämon kapselt zwei Rollen: die engine und den Agenten, eine engine, der in erster Linie Entscheidungen trift, während ein Agent Einheiten ausführt. Sowohl die engine als auch der Agent verwenden das modell, snapshot des "acurrent state" und des desired state(gewünschten Zustandes) und die notwendige Arbeit, um die Erstere gegen die letzteren zu mutieren. "
> 
> `etcd` ist der einzige Datenspeicher in einem `fleet` cluster. Alle persistenten und kurzlebigen Daten werden in etcd gespeichert; Unit-Dateien, Cluster-Präsenz, Unit Status und so weiter. Etcd wird auch für alle internen kommunikationen zwischen fleet engines und agenten verwendet.
> 

Jetzt kennen wir alle Bausteine von CoreOS. Lassen Sie uns CoreOS auf unserem lokalen System/Laptop ausprobieren. Um die Dinge einfach zu halten, werden wir Vagrant benutzen, um die Umgebung zu einzurichten.

### Fertig werden

1. Installiere VirtualBox auf dem System (https://www.virtualbox.org/) und Vagrant (https://www.vagrantup.com/). Die Anweisungen, diese beiden Dinge zu konfigurieren, liegen außerhalb des Umfangs dieses Buches.

2. Klone das `coreos-vagrant` Repository:
```
$ git clone https://github.com/coreos/coreos-vagrant.git 
$ cd coreos-vagrant
```

3. Kopiere die Beispieldatei `user-data.sample` in `user-data` und setze das Token ein, um den Cluster zu booten:

4. Wenn wir den CoreOS-Cluster mit mehr als einem Knoten konfigurieren, benötigen wir einen Token, um den Cluster zu booten, um den anfänglichen usw-Führer auszuwählen. Dieser Service wird vom CoreOS Team kostenlos zur Verfügung gestellt. Wir müssen nur `https://discovery.etcd.io/new` im Browser öffnen, um das Token zu erhalten und es in der `user-data` Datendatei wie folgt zu aktualisieren:
```
![haed-user-data](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_04.jpg)

5. Kopiere `config.rb.sample` in `config.rb` und tauche die folgende Zeile aus:
`$num_instances=1`
es sollte folgender maßen aussehen
`$num_instances=3`

Wir werden Vagrant bitten, drei cluster Nodes einzurichten. Standardmäßig ist Vagrant so konfiguriert, dass die VM-Bilder aus der Alpha-Version erhalten werden. Wir können es von Beta zu Stable ändern, indem wir den Parameter `$update_channel` in Vagrantfile aktualisieren. Für dieses Rezept wählte ich stabil.

### Wie es geht…

1. Führen Sie den folgenden Befehl aus, um den Cluster einzurichten:
`$ vagrant up ` 

Überprüfen Sie nun den Status, indem Sie den folgenden Befehl verwenden:
`vagrant status`

2. Melden Sie sich mit SSH in einer der VMs an, schauen Sie sich den Status der Dienste an und listen Sie die Maschinen im Cluster auf:
```
$ vagrant ssh core-01 
$ systemctl status etcd fleet
$ fleetctl list-machines
```

`fleetctl list-machines`

3. Erstellen Sie eine Service-Unit-Datei namens `myapp.service` mit folgendem Inhalt:
```
[Unit] 
Description=MyApp 
After=docker.service 
Requires=docker.service 

[Service] 
TimeoutStartSec=0 
ExecStartPre=-/usr/bin/docker kill busybox1 
ExecStartPre=-/usr/bin/docker rm busybox1 
ExecStartPre=/usr/bin/docker pull busybox 
ExecStart=/usr/bin/docker run --name busybox1 busybox /bin/sh -c "while true; do echo Hello World; sleep 1; done" 
ExecStop=/usr/bin/docker stop busybox1

```

4. Lassen Sie uns jetzt den Service für den scheduler einreichen und den Service starten:
```
$ fleetctl submit myapp.service
$ fleetctl start myapp.service
$ fleetctl list-units
```

`fleetctl submit myapp.service`

`fleetctl start myapp.service`

Wie wir sehen können, hat unser Service auf einem der Nodes im Cluster begonnen.

### Wie es funktioniert…

Vagrant verwendet die Cloud-Konfigurationsdatei (`user-data`), um die VMs zu booten. Da sie das gleiche Token haben, um den Cluster zu booten, wählen sie den Ersten und starten ihn. 
Dann, mit `fleetctl`, das ist das fleet-Cluster-Management-Tool, legen wir die Unit Datei für die Terminierung, die auf einem der Knoten beginnt.

### Es gibt mehr…

* Mit der Cloud-Konfigurationsdatei in diesem Rezept können wir `etcd` und `fleet` auf allen VMs starten. Wir können wählen, um etcd nur auf ausgewählte Knoten laufen und dann konfigurieren Arbeiter Knoten mit `fleet` zu verbinden, um etcd Servern. Dies kann durch die Einstellung der Cloud-Konfigurationsdatei erfolgen. Weitere Informationen finden Sie unter https://coreos.com/docs/cluster-management/setup/cluster-architectures/.

* Mit der `fleet` können wir die Dienste für die Hochverfügbarkeit konfigurieren. Weitere Informationen finden Sie unter https://coreos.com/docs/launching-containers/launching/fleet-unit-files/.

Obwohl dein Service auf dem Host läuft, kannst du ihn nicht von der Außenwelt erreichen. Sie müssen eine Art Router und Wildcard-DNS-Konfiguration hinzufügen, um Ihren Service von der Außenwelt zu erreichbar zu machen.

### Siehe auch

* Die CoreOS-Dokumentation für weitere Details unter https://coreos.com/docs/

* Die Visualisierung des RAFT consensus algorithmus auf http://thesecretlivesofdata.com/raft

* So konfiguriert man die Cloud-Konfigurationsdatei unter https://coreos.com/docs/cluster-management/setup/cloudinit-cloud-config/ und https://coreos.com/validate/

* Dokumentation auf systemd unter https://coreos.com/docs/launching-containers/launching/getting-started-with-systemd/

* Wie man Container mit Flotte auf https://coreos.com/docs/launching-containers/launching/launching-containers-fleet/