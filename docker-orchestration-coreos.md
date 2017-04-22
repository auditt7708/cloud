CoreOS (https://coreos.com/) ist eine Linux-Distribution, für Container wie Docker angepasst wurde, um die notwendigen Funktionen für den Betrieb moderner Infrastruktur-Stacks bereitzustellen. Es ist Apache 2.0 lizenziert. Es hat ein Produkt namens CoreOS Managed Linux (https://coreos.com/products/managed-linux/), für das das CoreOS-Team kommerzielle Unterstützung bietet.

Im Wesentlichen bietet CoreOS Plattformen, um einen kompletten Anwendungs stapel zu hosten. Wir können CoreOS auf verschiedenen Cloud-Anbietern, bare metal und in der VM-Umgebung aufbauen. Schauen wir uns die Bausteine von CoreOS an:

* etcd

* Container Laufzeitumgebubng

* Systemd

* Fleet

Lassen Sie uns im Einzelnen besprechen:

>* **etcd**: Von der GitHub-Seite von etcd (https://github.com/coreos/etcd/#etcd). Etcd ist ein hoch >verfügbarer Key-Value-Store für gemeinsame Konfiguration und Service Discovery. Es ist inspiriert von >Apache ZooKeeper und Doozer mit einem Fokus auf Sein:
>
>> * **Simple**: Curl-fähige User-API (HTTP plus JSON)
>> * **Secure**: Optional SSL client certificate authentication
>> *  **Fast**: Benchmark von 1.000s von Schriften pro Instanz 
> 
> Es ist in Go geschrieben und verwendet den Raft Consensus Algorithmus (https://raftconsensus.github.io/), > um ein hochverfügbares repliziertes Protokoll zu verwalten. 
> Etcd kann unabhängig von CoreOS verwendet werden. Wir können:
>> * Richten Sie einen Einzel- oder Multinode-Cluster ein. Weitere Informationen hierzu finden Sie unter >>https://github.com/coreos/etcd/blob/master/Documentation/clustering.md.
>>
>> * Zugriff mit CURL und verschiedenen Bibliotheken, gefunden unter >>https://github.com/coreos/etcd/blob/master/Documentation/libraries-and-tools.md. 
>> 
>> 