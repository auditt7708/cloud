Der Datenspeicher, etcd, arbeitet für das Speichern der Informationen von Kubernetes Ressourcen. Das Kubernetes-System wird ohne robuste etcd-Server nicht stabil sein. Wenn die Information eines Pods verloren gehen, können wir es nicht im System erkennen, wie wir über mit den Kubernetes-Service darauf zugreifen oder ihn über den Replikationscontroller verwalten können wissen wir. In diesem Rezept, werden Sie lernen, welche Art von Nachricht aus dem etcd Log hollen können und wie man sie mit ELK zu sammelt.

### Fertig werden

Bevor wir mit dem Sammeln des Protokolls von etcd beginnen, sollten wir die Server von ELK vorbereiten. Gehen Sie bitte zurück zu dem Sammelanwendungsprotokollrezept in [Sammeln von Anwendungsprotokollen](../kubernates-logging-monitorring-anwendungsprotokollen), um zu überprüfen, wie man ELK einrichtet und seine grundlegende Verwendung umsetzt.

Auf der anderen Seite setzen Sie bitte Ihren Kubernetes-Service Port von Elasticsearch zur verfügung, wenn Ihre etcd-Server einzelne Maschinen über den Kubernetes-Cluster sind. Sie können die Servicevorlage für Elasticsearch wie folgt ändern:

```
# cat es-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch
  labels:
    component: elasticsearch
spec:
  type: LoadBalancer
  selector:
    component: elasticsearch
  ports:
  - name: http
    port: 9200
    nodePort: 30000
    protocol: TCP
  - name: transport
    port: 9300
    protocol: TCP

```

Dann kann darauf ihr Logstash-Prozess auf dem `etcd` Server mit der URL `<NODE_ENDPOINT>:30000` zugreifen. Port `30000` ist auf jedem Node offen, was bedeutet, dass es möglich ist, von den Nodepunkten der Nodes kontaktiert zu werden.

### Wie es geht…

Auf dem etcd-Server haben wir das Protokoll vom Daemon `etcd` unter` /var/log/etcd.log` aufgezeichnet. Die Nachricht ist Zeile für Zeile im folgenden Format:

`<Date> <time> <subpackage>: <logs>`

Es ist ganz einfach, den Zeitstempel und die Informationen zu zeigen. Wir können auch sehen, woher die Logs kommen, was bedeutet, dass wir wissen, welche Art von Unterpaketen dieses Problem behandeln. Hier ist ein Beispiel für ein etcd log:

`2016/04/4 08:43:51 etcdserver: starting server... [version: 2.1.1, cluster version: to_be_decided]`

Nachdem Sie den Stil der Nachricht verstanden haben, ist es Zeit, die Logstash-Konfigurationsdatei zu erstellen:

``` 
# cat etcd.conf
input {
  file {
    path => "/var/log/etcd.log"
  }
}

filter {
  grok {
    match => {
        "message" => "%{DATA:date} %{TIME:time} %{PROG:subpackage}: %{GREEDYDATA:message}"
    }
  }
}

output {
  elasticsearch {
    hosts => ["<ELASTIC_SERVICE_IP>:<EXPOSE_PORT>"]
    index => "etcd-log"
  }

  stdout { codec => rubydebug }
}
```
In der Datei werden wir den Speicherort der etcd-Logdatei als dessen Eingabedaten zuordnen. Das im `grok` Filter definierte Muster trennt einfach das Protokoll in drei Teile: Zeitstempel, das Unterpaket und die Nachricht. 
Natürlich zeigen wir nicht nur die Ausgabe auf dem Bildschirm, sondern senden auch die Daten zum Elasticsearch-Server zur weiteren Analyse:
```
// Under the directory of $LOGSTASH_HOME
# ./bin/logstash -f etcd.conf
Settings: Default pipeline workers: 1
Pipeline main started
{
    "subpackage" => "raft",
       "message" => [
        [0] "2016/04/4 08:43:53 raft: raft.node: ce2a822cea30bfca elected leader ce2a822cea30bfca at term 2",
        [1] "raft.node: ce2a822cea30bfca elected leader ce2a822cea30bfca at term 2"
    ],
    "@timestamp" => 2016-04-04T11:23:
27.571Z,
          "time" => "08:43:53",
          "host" => "etcd1",
          "path" => "/var/log/etcd.log",
          "date" => "2016/04/4",
      "@version" => "1"
}
{
    "subpackage" => "etcdserver",
       "message" => [
        [0] "2016/04/4 08:43:53 etcdserver: setting up the initial cluster version to 2.1.0",
        [1] "setting up the initial cluster version to 2.1.0"
    ],
    "@timestamp" => 2016-04-04T11:24:09.603Z,
          "time" => "08:43:53",
          "host" => "etcd1",
          "path" => "/var/log/etcd.log",
          "date" => "2016/04/4",
      "@version" => "1"
}
```
Wie Sie sehen können, durch Logstash, werden wir das Protokoll in verschiedenen Unterpaket parsen um es zu einem bestimmten Zeitpunkt zu analysieren. Es ist eine gute Zeit für Sie jetzt, auf das Kibana Armaturenbrett zuzugreifen und mit den etcd Protokollen zu arbeiten.
