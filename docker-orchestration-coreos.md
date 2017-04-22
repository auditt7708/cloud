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
