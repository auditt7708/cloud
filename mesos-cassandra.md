# Mesos und Cassandra

In diesem Abschnitt wird Cassandra vorgestellt und erklärt, wie man Cassandra auf Mesos einrichtet und dabei auch die Probleme behandelt, die während des Setup-Prozesses häufig auftreten.

## Einführung in Cassandra

Cassandra ist eine Open-Source-, skalierbare NoSQL-Datenbank, die mit keinem einzigen Punkt des Ausfalls vollständig verteilt ist und für die meisten üblichen Anwendungsfälle sehr leistungsfähig ist. Es ist sowohl horizontal als auch vertikal skalierbar. Horizontale Skalierbarkeit oder Scale-Out-Lösung beinhaltet das Hinzufügen von mehr Knoten mit Rohstoff-Hardware zu den bestehenden Cluster, während vertikale Skalierbarkeit oder Scale-up-Lösung bedeutet, mehr CPU und Speicherressourcen zu einem Knoten mit spezialisierten Hardware hinzufügen.

Cassandra wurde von Facebook-Ingenieuren entwickelt, um den Inbox-Such-Use-Case zu adressieren und wurde von Google Bigtable inspiriert, der als Grundlage für sein Speichermodell diente und Amazon DynamoDB, das die Grundlage seines Distributionsmodells war. Es wurde 2008 erschienen und wurde Anfang 2010 zum Apache-Top-Level-Projekt. Es bietet eine Abfrage-Sprache namens Cassandra Query Language oder CQL, die eine SQL-ähnliche Syntax hat, um mit der Datenbank zu kommunizieren.

Cassandra bietet verschiedene Funktionen wie:

* Hohe Leistung
* Ununterbrochene Uptime (kein einziger Ausfall)
* Benutzerfreundlichkeit
* Datenreplikation und -verteilung über Rechenzentren

Anstatt einen traditionellen Master-Sklaven oder Sharded Design zu verwenden, verwendet die Architektur von Cassandra ein elegantes und einfaches Ringdesign ohne Masters. Dies ermöglicht es, alle Funktionen und Vorteile, die früher aufgeführt sind, zur Verfügung zu stellen.

Das Cassandra Ring Design Diagramm ist wie folgt dargestellt (Quelle: www.planetcassandra.org):

![cassandra-ring](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_09_00.jpg)

Eine große Anzahl von Unternehmen nutzt Cassandra in der Produktion, darunter Apple, Instagram, eBay, Spotify, Comcast und Netflix unter anderem.

Cassandra wird am besten benutzt, wenn man braucht:

* No single failure point

* Real-time writes

* Flexibility

* Horizontal scaling

* Reliability

* Ein klar definiertes Tabellenschema in einer NoSQL-Umgebung

Einige der üblichen Anwendungsfälle sind wie folgt:

* Speichern, Verwalten und Durchführen von Analysen auf Daten, die durch Messaging-Anwendungen generiert werden (Instagram und Comcast, unter anderem verwenden Cassandra zu diesem Zweck)

* Speichern von Datenmustern für die Erkennung von betrügerischen Aktivitäten

* Speichern von benutzerdefinierten und kuratierten Gegenständen (Einkaufswagen, Wiedergabelisten usw.)

* Empfehlung und Personalisierung

## Performance-Benchmark

Die folgende Performance-Benchmark, die von einer unabhängigen Datenbankfirma durchgeführt wurde, zeigte, dass Cassandra für gemischte operative und analytische Workloads anderen Open Source NoSQL-Technologien (Quelle: www.datastax.com) weit überlegen war:

![cassabdra-performence](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_09_01.jpg)

### Cassandra auf Mesos aufstellen

Dieser Abschnitt behandelt den Prozess der Bereitstellung von Cassandra oben auf Mesos. Die empfohlene Art, Cassandra auf Mesos einzusetzen, ist durch Marathon. Zum Zeitpunkt des Schreibens dieses Buches ist Cassandra auf Mesos in einem experimentellen Stadium, und die hier beschriebene Konfiguration könnte sich in zukünftigen Versionen ändern.

Das Mesosphere-Team hat bereits die notwendigen JAR-Dateien und den Cassandra-Executor in einem Tarball verpackt, der direkt über den Marathon mit dem folgenden JSON-Code an Mesos übergeben werden kann:

```yml
{
    "healthChecks": [
      {
        "timeoutSeconds": 5,
        "protocol": "HTTP",
        "portIndex": 0,
        "path": "/health/cluster",
        "maxConsecutiveFailures": 0,
        "intervalSeconds": 30,
        "gracePeriodSeconds": 120
      },
      {
        "timeoutSeconds": 5,
        "protocol": "HTTP",
        "portIndex": 0,
        "path": "/health/process",
        "maxConsecutiveFailures": 3,
        "intervalSeconds": 30,
        "gracePeriodSeconds": 120
      }
    ],
    "id": "/cassandra/dev-test",
    "instances": 1,
    "cpus": 0.5,
    "mem": 512,
    "ports": [0],
    "uris": [
      "https://downloads.mesosphere.io/cassandra-mesos/artifacts/0.2.1-SNAPSHOT-608-master-d1c2cf30c8/cassandra-mesos-0.2.1-SNAPSHOT-608-master-d1c2cf30c8.tar.gz",
      "https://downloads.mesosphere.io/java/jre-7u76-linux-x64.tar.gz"
    ],
    "env": {
      "CASSANDRA_ZK_TIMEOUT_MS": "10000",
      "CASSANDRA_HEALTH_CHECK_INTERVAL_SECONDS": "60",
      "MESOS_ZK": "zk://localhost:2181/mesos",
      "JAVA_OPTS": "-Xms256m -Xmx256m",
      "CASSANDRA_CLUSTER_NAME": "dev-test",
      "CASSANDRA_ZK": "zk://localhost:2181/cassandra-mesos",
      "CASSANDRA_NODE_COUNT": "3",
      "CASSANDRA_RESOURCE_CPU_CORES": "2.0",
      "CASSANDRA_RESOURCE_MEM_MB": "2048",
      "CASSANDRA_RESOURCE_DISK_MB": "2048"
    },
    "cmd": "$(pwd)/jre*/bin/java $JAVA_OPTS -classpath cassandra-mesos-framework.jar io.mesosphere.mesos.frameworks.cassandra.framework.Main"
  }
```

Bearbeiten Sie den JSON-Code, indem Sie `MESOS_ZK` und alle anderen Parameter, die Sie entsprechend ändern müssen, speichern Sie diesen JSON-Code in `cassandra-mesos.json`, und senden Sie ihn dann an Marathon mit dem folgenden Befehl:

```sh
curl -X POST -H "Content-Type: application/json" -d cassandra-mesos.json http://marathon-machine:8080/v2/apps
```

Einmal eingereicht, wird das Framework bootstrap sich.
Wir müssen auch die Port-Bereiche erweitern, die von jedem Mesos-Knoten verwaltet werden, um die Standard-Cassandra-Ports einzuschließen.
Wir können die Port-Bereiche als Ressourcen beim Start des Prozesses passieren.

Hier ist ein Beispiel:

`--resources='ports:[31000-32000,7000-7001,7199-7199,9042-9042,9160-9160]'`

Cassandra auf Mesos bietet einen REST-Endpunkt, um das Setup zu stimmen.
Wir können diesen Endpunkt auf Port `18080` standardmäßig aufrufen (sofern nicht geändert).

## Eine erweiterte Konfigurationsanleitung

Wie bereits erwähnt, nimmt Cassandra auf Mesos die Laufzeitkonfiguration durch Umgebungsvariablen ein. Wir können die folgenden Umgebungsvariablen verwenden, um die Konfiguration des Frameworks zu booten. Nach dem ersten Durchlauf werden die Konfigurationen aus dem im ZooKeeper gespeicherten Framework-Status gelesen:

```sh
# name of the cassandra cluster, this will be part of the framework name in Mesos
CASSANDRA_CLUSTER_NAME=dev-cluster

# Mesos ZooKeeper URL to locate leading master
MESOS_ZK=zk://localhost:2181/mesos

# ZooKeeper URL to be used to store framework state
CASSANDRA_ZK=zk://localhost:2181/cassandra-mesos

# The number of nodes in the cluster (default 3)
CASSANDRA_NODE_COUNT=3

# The number of seed nodes in the cluster (default 2)
# set this to 1, if you only want to spawn one node
CASSANDRA_SEED_COUNT=2

# The number of CPU Cores for each Cassandra Node (default 2.0)
CASSANDRA_RESOURCE_CPU_CORES=2.0

# The number of Megabytes of RAM for each Cassandra Node (default 2048)
CASSANDRA_RESOURCE_MEM_MB=2048

# The number of Megabytes of Disk for each Cassandra Node (default 2048)
CASSANDRA_RESOURCE_DISK_MB=2048

# The number of seconds between each health check of the Cassandra node (default 60)
CASSANDRA_HEALTH_CHECK_INTERVAL_SECONDS=60

# The default bootstrap grace time - the minimum interval between two node starts
# You may set this to a lower value in pure local development environments.
CASSANDRA_BOOTSTRAP_GRACE_TIME_SECONDS=120

# The number of seconds that should be used as the mesos framework timeout (default 604800 seconds / 7 days)
CASSANDRA_FAILOVER_TIMEOUT_SECONDS=604800

# The mesos role to used to reserve resources (default *). If this is set, the framework accepts offers that have resources for that role or the default role *
CASSANDRA_FRAMEWORK_MESOS_ROLE=*

# A pre-defined data directory specifying where Cassandra should write its data. 
# Ensure that this directory can be created by the user the framework is running as (default. [mesos sandbox]).
# NOTE:
# This field is slated to be removed and the framework will be able to allocate the data volume itself.
CASSANDRA_DATA_DIRECTORY=.
```

Hier sind einige Referenzen:

* [Cassandra Mesos](https://github.com/mesosphere/cassandra-mesos)

* [Cassandra Mesos Git](http://mesosphere.github.io/cassandra-mesos/)