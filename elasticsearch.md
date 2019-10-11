# Elasticsearch 

/usr/share/elasticsearch/bin/elasticsearch

## Elasticsearch absichern

## Elasticsearch Konfiguration

_/etc/elasticsearch/elasticsearch.yml_

```
##################################
cluster.name: my-cluster
node.name: elastic-node1
path.data: /data/elastic/elastic-node1
path.logs: /var/log/elasticsearch

bootstrap.memory_lock: true
network.host: 192.168.1.1
http.port: 9200

# Make sure to add all your nodes host names
discovery.zen.ping.unicast.hosts: ["elastic-node1", "elastic-node2"]

# If we have more than 2 nodes in our cluster, this setting should be set
# to '2' or bigger number
discovery.zen.minimum_master_nodes: 1

##################################
```
> Hinweis:
> Die Heap-Größe muss 50 % des Server-Arbeitsspeichers betragen. Beispiel: In einem 24-GB-Elasticsearch-Knoten bedeutet dies, dass eine Heap-Größe von 12 GB optimale Leistung verspricht.

Quellen

* [elasticsearch documentation](https://www.netiq.com/de-de/documentation/sentinel-81/install/data/b1m3gtdt.html)
