# Einfügen und Abfragen

Die API für Cassandra ist CQL , die Cassandra Query Language.
Um CQL verwenden zu können, müssen Sie eine Verbindung zum Cluster herstellen.
Dies ist möglich:

entweder mit cqlsh,
oder über einen Client-Treiber für Cassandra.

## CQLSH

cqlsh ist eine Befehlszeilen-Shell für die Interaktion mit Cassandra über CQL.
Es wird mit jedem Cassandra-Paket geliefert und befindet sich im Verzeichnis bin / neben der ausführbaren Cassandra-Datei.
Es stellt eine Verbindung zu dem einzelnen Knoten her, der in der Befehlszeile angegeben ist. Beispielsweise:

```s
$ bin/cqlsh localhost
Connected to Test Cluster at localhost:9042.
[cqlsh 5.0.1 | Cassandra 3.8 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> SELECT cluster_name, listen_address FROM system.local;

 cluster_name | listen_address
--------------+----------------
 Test Cluster |      127.0.0.1

(1 rows)
cqlsh>
```

Siehe den cqlsh Abschnitt für die vollständige Dokumentation.

## Client-Treiber

Viele Client-Treiber werden von der Community bereitgestellt, und eine Liste bekannter Treiber wird im nächsten Abschnitt bereitgestellt.
Weitere Informationen zu deren Verwendung finden Sie in der Dokumentation der einzelnen Treiber.
