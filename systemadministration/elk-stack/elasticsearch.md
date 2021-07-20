---
title: elasticsearch
description: 
published: true
date: 2021-06-09T15:18:39.452Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:18:33.961Z
---

# Elasticsearch

/usr/share/elasticsearch/bin/elasticsearch

## Elasticsearch absichern

Zur sicherenkomunikation kann, certbot verwendet werden

Dazu muss dKonfigurationsdatei ___ folgerndermassen erweitert werden:

```
...
xpack.ssl.key: /etc/elasticsearch/ssl/vmd36612.contaboserver.net/privkey.pem
xpack.ssl.certificate: /etc/elasticsearch/ssl/vmd36612.contaboserver.net/fullchain.pem
xpack.ssl.certificate_authorities: [
  "/etc/elasticsearch/ssl/vmd36612.contaboserver.net/chain.pem",
  "/etc/elasticsearch/ssl/vmd36612.contaboserver.net/cacert.pem" ]


xpack.security.transport.ssl.enabled: true
xpack.security.http.ssl.enabled: true
xpack.security.audit.enabled: true


xpack.security.audit.enabled: true
xpack.security.audit.outputs: [ index, logfile ]
xpack.security.audit.logfile.events.include: [ access_denied, authentication_failed, connection_denied ]
```

> Info: Es kann sein das die _xpack_ erweiterungeninstalliert werden müssen.

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
