---
title: mesos-elk-stack
description: 
published: true
date: 2021-06-09T15:38:34.098Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:38:28.144Z
---

# Mesos ELK Stack aufbauen

In diesem Abschnitt wird der Elasticsearch-Logstash-Kibana (ELK) Stack vorgestellt und erklärt,
wie man ihn auf Mesos einrichtet und dabei auch die Probleme behandelt, die während des Setup-Prozesses häufig auftreten.

## Einführung in Elasticsearch, Logstash und Kibana

Der ELK-Stack, eine Kombination aus Elasticsearch, Logstash und Kibana, ist eine End-to-End-Lösung für Log Analytics. Elasticsearch bietet Suchfunktionen, Logstash ist eine Log-Management-Software, während Kibana als Visualisierungsschicht dient. Der Stapel wird von einer Firma namens Elastic kommerziell unterstützt.

## Suche mit elasticsearch

Elasticsearch ist eine Lucene-basierte Open Source verteilte Suchmaschine für hohe Skalierbarkeit und schnelle Suchanfrage Antwortzeit. Es vereinfacht die Verwendung von Lucene, einer hochleistungsfähigen Suchmaschinenbibliothek, durch die Bereitstellung einer leistungsstarken REST API oben. Einige der wichtigen Konzepte in Elasticsearch werden wie folgt hervorgehoben:

* Dokument: Dies ist ein JSON-Objekt, das in einem Index gespeichert ist

* Index: Dies ist eine Dokumentensammlung

* Typ: Dies ist eine logische Partition eines Index, der eine Kategorie von Dokumenten darstellt

* Feld: Dies ist ein Schlüsselwertpaar innerhalb eines Dokuments

* Mapping: Hier wird jedes Feld mit seinem Datentyp abgebildet

* Shard: Dies ist der physische Ort, an dem die Daten eines Index gespeichert sind (die Daten werden auf einem primären Shard gespeichert und auf einem Satz von Replik-Shards kopiert)

## Logstash

Dies ist ein Werkzeug, um die von einer Vielzahl von Systemen erzeugten Log-Ereignisse zu sammeln und zu verarbeiten. Es enthält einen umfangreichen Satz von Eingangs- und Ausgangsanschlüssen, um die Protokolle einzubauen und sie zur Analyse zur Verfügung zu stellen. Einige seiner wichtigen Merkmale sind:

* Die Fähigkeit, Protokolle in ein gemeinsames Format für die Benutzerfreundlichkeit zu konvertieren

* Die Fähigkeit, mehrere Log-Formate, einschließlich benutzerdefinierte zu verarbeiten

* Ein reicher Satz von Eingangs- und Ausgangsanschlüssen

## Kibana

Dies ist ein Elasticsearch-basiertes Datenvisualisierungs-Tool mit einer Vielzahl von Charting- und Dashboarding-Funktionen. Es wird durch die in den Elasticsearch-Indizes gespeicherten Daten angetrieben und wird komplett mit HTML und JavaScript entwickelt. Einige seiner wichtigsten Merkmale sind:

* Eine grafische Benutzeroberfläche für Armaturenbrettbau

* Ein reicher Satz von Diagrammen (Karte, Kreisdiagramme, Histogramme und so weiter)

* Die Möglichkeit, Diagramme in Benutzeranwendungen einzubetten

## Die ELK-Stack-Datenpipeline

Schauen Sie sich das folgende Diagramm an (Quelle: Learning ELK Stack von Packt Publishing):

![elk-schemata](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_09_02.jpg)

In einer Standard-ELK-Stack-Pipeline werden Protokolle von verschiedenen Applikationsservern über Logstash zu einem zentralen Indexer-Modul transportiert. Dieser Indexer überträgt dann die Ausgabe an einen Elasticsearch-Cluster, wo er direkt abgefragt oder in einem Dashboard visualisiert werden kann, indem er Kibana nutzt.

## Einrichten von Elasticsearch-Logstash-Kibana auf Mesos

Dieser Abschnitt erklärt, wie man Elasticsearch, Logstash und Kibana oben auf Mesos einrichtet. Wir werden uns erst einen Blick darauf werfen, wie wir Elastesuche auf Mesos aufstellen können, gefolgt von Logstash und Kibana.

### Elastische Suche auf Mesos

Wir werden Marathon einsetzen, um Elasticsearch einzusetzen, und dies kann auf zwei Arten geschehen: durch das Docker-Bild, das sehr zu empfehlen ist, und durch `elasticsearch-mesos jar`. Beide werden im folgenden Abschnitt erklärt.

Wir können die folgende Marathon-Datei verwenden, um Elasticsearch auf Mesos zu implementieren. Es benutzt das Docker-Image:

```sh
{
  "id": "elasticsearch-mesos-scheduler",
  "container": {
    "docker": {
      "image": "mesos/elasticsearch-scheduler",
      "network": "HOST"
    }
},
"args": ["--zookeeperMesosUrl", "zk://zookeeper-node:2181/mesos"],
  "cpus": 0.2,
  "mem": 512.0,
  "env": {
    "JAVA_OPTS": "-Xms128m -Xmx256m"
  },
  "instances": 1
}
```

Stellen Sie sicher, dass der `zookeeper-node` an die Adresse des ZooKeeper-Knotens geändert wird, den Sie auf dem Cluster haben. Wir können dies auf eine `elasticsearch.json` Datei speichern und dann auf Marathon mit dem folgenden Befehl einsetzen:

```sh
curl -k -XPOST -d @elasticsearch.json -H "Content-Type: application/json" http://marathon-machine:8080/v2/apps
```

Wie bereits erwähnt, können wir auch die JAR-Datei verwenden, um Elasticsearch auf Mesos mit der folgenden Marathon-Datei einzusetzen:

```json
{
  "id": "elasticsearch",
  "cpus": 0.2,
  "mem": 512,
  "instances": 1,
  "cmd": "java -jar scheduler-0.7.0.jar --frameworkUseDocker false --zookeeperMesosUrl zk://10.0.0.254:2181 --frameworkName elasticsearch --elasticsearchClusterName mesos-elasticsearch --elasticsearchCpu 1 --elasticsearchRam 1024 --elasticsearchDisk 1024 --elasticsearchNodes 3 --elasticsearchSettingsLocation /home/ubuntu/elasticsearch.yml",
  "uris": ["https://github.com/mesos/elasticsearch/releases/download/0.7.0/scheduler-0.7.0.jar"],
  "env": {
    "JAVA_OPTS": "-Xms256m -Xmx512m"
  },
  "ports": [31100],
  "requirePorts": true,
  "healthChecks": [
    {
     "gracePeriodSeconds": 120,
      "intervalSeconds": 10,
      "maxConsecutiveFailures": 6,
      "path": "/",
      "portIndex": 0,
      "protocol": "HTTP",
      "timeoutSeconds": 5
    }
  ]
}
```

In beiden Fällen ist die Umgebungsvariable `JAVA_OPTS` erforderlich, und wenn sie nicht gesetzt ist, wird es zu Problemen mit dem Java-Heap-Space kommen. Wir können das als `elasticsearch.json` retten und es dem Marathon mit folgendem Befehl unterwerfen:

```s
curl -k -XPOST -d @elasticsearch.json -H "Content-Type: application/json" http://MARATHON_IP_ADDRESS:8080/v2/apps
```

Sowohl das Docker-Bild als auch die JAR-Datei nehmen die folgenden Befehlszeilenargumente ein, ähnlich dem `--zookeeperMesosUrl` Argument:

```s
--dataDir
         The host data directory used by Docker volumes in the executors. [DOCKER MODE ONLY]
         Default: /var/lib/mesos/slave/elasticsearch

    --elasticsearchClusterName
         Name of the Elasticsearch cluster
         Default: mesos-ha

    --elasticsearchCpu
         The amount of CPU resource to allocate to the Elasticsearch instance.
         Default: 1.0

    --elasticsearchDisk
         The amount of Disk resource to allocate to the Elasticsearch instance
         (MB).
         Default: 1024.0

    --elasticsearchExecutorCpu
         The amount of CPU resource to allocate to the Elasticsearch executor.
         Default: 0.1

    --elasticsearchExecutorRam
         The amount of ram resource to allocate to the Elasticsearch executor
         (MB).
         Default: 32.0

    --elasticsearchNodes
         Number of Elasticsearch instances.
         Default: 3

    --elasticsearchPorts
         User specified Elasticsearch HTTP and transport ports. [NOT RECOMMENDED]
         Default: <empty string>

    --elasticsearchRam
         The amount of ram resource to allocate to the Elasticsearch instance
         (MB).
         Default: 256.0

    --elasticsearchSettingsLocation
         Path or URL to Elasticsearch yml settings file. [In docker mode file must be in /tmp/config] E.g. '/tmp/config/elasticsearch.yml' or 'https://gist.githubusercontent.com/mmaloney/5e1da5daa58b70a3a671/raw/elasticsearch.yml'
         Default: <empty string>

    --executorForcePullImage
         Option to force pull the executor image. [DOCKER MODE ONLY]
         Default: false

    --executorImage
         The docker executor image to use. E.g. 'elasticsearch:latest' [DOCKER
         MODE ONLY]
         Default: elasticsearch:latest

    --executorName
         The name given to the executor task.
         Default: elasticsearch-executor

    --frameworkFailoverTimeout
         The time before Mesos kills a scheduler and tasks if it has not recovered
         (ms).
         Default: 2592000.0

    --frameworkName
         The name given to the framework.
         Default: elasticsearch

    --frameworkPrincipal
         The principal to use when registering the framework (username).
         Default: <empty string>

    --frameworkRole
         Used to group frameworks for allocation decisions, depending on the
         allocation policy being used.
         Default: *

    --frameworkSecretPath
         The path to the file which contains the secret for the principal
         (password). Password in file must not have a newline.
         Default: <empty string>

    --frameworkUseDocker
         The framework will use docker if true, or jar files if false. If false, the user must ensure that the scheduler jar is available to all slaves.
         Default: true

    --javaHome
         When starting in jar mode, if java is not on the path, you can specify
         the path here. [JAR MODE ONLY]
         Default: <empty string>

    --useIpAddress
         If true, the framework will resolve the local ip address. If false, it
         uses the hostname.
         Default: false

    --webUiPort
         TCP port for web ui interface.
         Default: 31100

    --zookeeperMesosTimeout
         The timeout for connecting to zookeeper for Mesos (ms).
         Default: 20000

    * --zookeeperMesosUrl
         Zookeeper urls for Mesos in the format zk://IP:PORT,IP:PORT,...)
         Default: zk://mesos.master:2181
```

## Logstash auf Mesos

In diesem Abschnitt erfahren Sie, wie Sie Logstash über Mesos ausführen können. Sobald Logstash auf dem Cluster bereitgestellt wird, kann jedes Programm, das auf Mesos ausgeführt wird, ein Ereignis protokollieren, das dann von Logstash übergeben und an einen zentralen Protokollstandort gesendet wird.

Wir können Logstash als Marathon-Anwendung ausführen und es auf der Mesos mit der folgenden Marathon-Datei einsetzen:

```json
{
  "id": "/logstash",
  "cpus": 1,
  "mem": 1024.0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "mesos/logstash-scheduler:0.0.6",
      "network": "HOST"
    }
  },
  "env": {
    "ZK_URL": "zk://123.0.0.12:5181/logstash",
    "ZK_TIMEOUT": "20000",
    "FRAMEWORK_NAME": "logstash",
    "FAILOVER_TIMEOUT": "60",
    "MESOS_ROLE": "logstash",
    "MESOS_USER": "root",
    "LOGSTASH_HEAP_SIZE": "64",
    "LOGSTASH_ELASTICSEARCH_URL": "http://elasticsearch.service.consul:1234",
    "EXECUTOR_CPUS": "0.5",
    "EXECUTOR_HEAP_SIZE": "128",
    "ENABLE_FAILOVER": "false",
    "ENABLE_COLLECTD": "true",
    "ENABLE_SYSLOG": "true",
    "ENABLE_FILE": "true",
    "ENABLE_DOCKER": "true",
    "EXECUTOR_FILE_PATH": "/var/log/*,/home/jhf/example.log"
  }
}
```

Hier haben wir das Docker-Image für die Bereitstellung verwendet, dessen Konfigurationen je nach Cluster-Spezifikation geändert werden können. Speichern Sie die vorherige Datei als `logstash.json` und senden Sie sie an Marathon mit dem folgenden Befehl:

```s
curl -k -XPOST -d @logstash.json -H "Content-Type: application/json" http://MARATHON_IP_ADDRESS:8080/v2/apps
```

## Logstash auf Mesos-Konfigurationen

Logstash und Elasticsearch werden mit der Mesos Version 0.25.0 und später getestet. Wir müssen Logstash zur Liste der Rollen auf jedem Mesos-Master-Rechner hinzufügen. Dies kann mit folgendem Befehl erfolgen:

`$ sudo echo logstash > /etc/mesos-master/roles`

Wenn der Zweck von Logstash darin besteht, `syslog` zu überwachen (ein Meldungsprotokollierungsstandard), dann müssen wir den TCP- und UDP-Port 514 der Ressourcenliste in jedem Mesos-Knoten im Cluster hinzufügen. Dies kann durch Hinzufügen des folgenden Eintrags in der Datei `/etc/mesos-slave/resources` erfolgen:

`ports(logstash):[514-514]`

Um `collectd` zu überwachen, müssen wir den TCP- und UDP-Port `25826` die Ressourcen für die Logstash-Rolle hinzufügen, indem wir die folgende Zeile der Datei `/etc/mesos-slave/resources` hinzufügen:

`ports(logstash):[25826-25826]`

## Kibana auf Mesos

Wenn wir Kibana auf Mesos laufen lassen, dann wird jede Instanz von Kibana als Docker-Image im Mesos-Cluster laufen. Für jede Instanz von Elasticsearch können eine oder mehrere Instanzen von Kibana eingesetzt werden, um den Nutzern zu dienen.

Wir können Kibana auf dem Mesos-Projekt aus folgendem Repository klonen:

`$ git clone https://github.com/mesos/kibana`

Erstellen Sie das Projekt mit dem folgenden Befehl:

```s
cd kibana
gradlew jar
```

Dies wird die Kibana JAR-Datei (`kibana.jar`) erzeugen.

Sobald `kibana.jar` erzeugt wird, können wir es mit folgendem Befehl einsetzen:

|Kurzes Schlüsselword| Schlüsselword| Beschreibung|
| :--: | :--: | :--: |
|`-zk`|`-zookeeper`|Dies ist die Mesos ZooKeeper URL (Erforderlich)|
|`-di`|`-dockerimage`|Dies ist der Name des zu verwendenden Docker-Bildes (Der Standardwert ist `kibana`)|
|`-v`|`-version`|Dies ist die Version des Kibana Docker Bildes verwendet werden (die Voreinstellung ist `latest`)|
|`-mem`|`-requiredMem`|Dies ist die Menge an Speicher (in MB), die einer einzigen Kibana-Instanz zugeordnet werden soll (die Voreinstellung ist `128`)|
|`-cpu`|`-requiredCpu`|Dies ist die Anzahl der CPUs, die einer einzigen Kibana-Instanz zugewiesen werden sollen (Die Voreinstellung ist `0,1`)|
|`-disk`|`-requiredDisk`|Dies ist die Menge an Speicherplatz (in MB), die einer einzelnen Kibana-Instanz zugeordnet werden soll (die Voreinstellung ist `25`)|
|`-es`|`-elasticsearch`|Dies sind die URLs von Elasticsearch, um eine Kibana zum Start zu starten|

### Hier sind einige Quellen

* [elasticsearch-mesos-framework](Http://mesos-elasticsearch.readthedocs.org/en/latest/#elasticsearch-mesos-framework)
* [mesos logstash](Https://github.com/mesos/logstash)
* [mesos kibana](Https://github.com/mesos/kibana)
