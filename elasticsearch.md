# Elasticsearch 

/usr/share/elasticsearch/bin/elasticsearch

# Elasticsearch absichern

# Elasticsearch Konfiguration

_/etc/elasticsearch/elasticsearch.yml_

```
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
	
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