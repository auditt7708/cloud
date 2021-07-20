---
title: kubernetes-ha-etcd
description: 
published: true
date: 2021-06-09T15:32:42.248Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:32:36.795Z
---

Etcd speichert Netzwerkinformationen und Stati in Kubernetes. Jeder Datenverlust könnte entscheidend sein. Clustering wird dringend empfohlen in etcd. Etcd kommt mit Unterstützung für Clustering daher; Ein Cluster von **N** Mitgliedern kann bis zu **(N-1)/2** Ausfälle tolerieren. Es gibt drei Mechanismen für die Erstellung eines etcd-Clusters. Sie sind folgende:

* Statisch
* etcd discovery
* DNS discovery

In diesem Rezept werden wir diskutieren, wie man ein etcd-Cluster durch statische und etcd-Entdeckung bootstrapen kann .

### Fertig werden

Bevor Sie mit dem Aufbau eines etcd-Clusters beginnen, müssen Sie entscheiden, wie viele Mitglieder notwendig sind. Wie groß das etcd-Cluster sollte wirklich sein sollte hängt von der Umgebung ab, die Sie erstellen möchten. In der Produktionsumgebung werden mindestens drei Mitglieder empfohlen. Dann kann der Cluster mindestens einen permanenten Ausfall tolerieren. In diesem Rezept werden wir drei Mitglieder als Beispiel für eine Entwicklungsumgebung nutzen:

|Name/Hostname|IP Addresse |
| :---: | :---: |
| `ip-172-31-0-1` | `172.31.0.1` |
| `ip-172-31-0-2` | `172.31.0.2` |
| `ip-172-31-0-3` | `172.31.0.3` |

### Wie es geht…

Ein statischer Mechanismus ist der einfachste Weg(Und besonders Übersichtlich), um einen Cluster einzurichten. Allerdings sollte die IP-Adresse(was oft nicht der Fall ist) jedes Mitglieds vorher bekannt sein. Es bedeutet, dass, wenn Sie bootenstrap ein etcd-Cluster in einigen Cloud-Provider-Umgebung, ist die statische Mechanismus möglicherweise nicht so praktisch. Daher bietet etcd auch einen Entdeckungsmechanismus, um sich von dem vorhandenen Cluster zu booten.

### Statisch

Mit einem statischen Mechanismus müssen Sie die Adressinformationen jedes Mitglieds kennen:

|Parameter|Bedeutung|
|:---: | :---: |
| `-name `| Der Name dieses Mitglieds |
|`-initial-advertise-peer-urls`|Wird verwendet, um mit anderen Mitgliedern gesehen zu werden, sollte die gleiche sein wie die eine Auflistung in `-initial-cluster` zurück gibt|
|`-listen-peer-urls`|Die URL, um Peer-Traffic zu akzeptieren|
|`-listen-client-urls`|Die URL zum Akzeptieren von Kundenverkehr|
|` -advertise-client-urls `|Etcd Mitglied verwendet, um andere Mitglieder zu verbinden|
|` -initial-cluster-token `|Ein einzigartiges Token für die Unterscheidung verschiedener Cluster|
|` -initial-cluster `|Bekannte Peer-URLs aller Mitglieder|
|` -initial-cluster-state `|Gibt den Status des Initialen clusters an|

Verwenden Sie das Befehlszeilenprogramm etcd, um einen Cluster mit zusätzlichen Parametern für jedes Mitglied zu bootstrap:
```
// on the host ip-172-31-0-1, running etcd command to make it peer with ip-172-31-0-2 and ip-172-31-0-3, advertise and listen other members via port 2379, and accept peer traffic via port 2380
# etcd -name ip-172-31-0-1 \
       -initial-advertise-peer-urls http://172.31.0.1:2380 \
       -listen-peer-urls http://172.31.0.1:2380 \
       -listen-client-urls http://0.0.0.0:2379 \
       -advertise-client-urls http://172.31.0.1:2379 \
       -initial-cluster-token mytoken \
       -initial-cluster ip-172-31-0-1=http://172.31.0.1:2380,ip-172-31-0-2=http://172.31.0.2:2380,ip-172-31-0-3=http://172.31.0.3:2380 \
       -initial-cluster-state new
...
2016-05-01 18:57:26.539787 I | etcdserver: starting member e980eb6ff82d4d42 in cluster 8e620b738845cd7
2016-05-01 18:57:26.551610 I | etcdserver: starting server... [version: 2.2.5, cluster version: to_be_decided]
2016-05-01 18:57:26.553100 N | etcdserver: added member 705d980456f91652 [http://172.31.0.3:2380] to cluster 8e620b738845cd7
2016-05-01 18:57:26.553192 N | etcdserver: added member 74627c91d7ab4b54 [http://172.31.0.2:2380] to cluster 8e620b738845cd7
2016-05-01 18:57:26.553271 N | etcdserver: added local member e980eb6ff82d4d42 [http://172.31.0.1:2380] to cluster 8e620b738845cd7
2016-05-01 18:57:26.553349 E | rafthttp: failed to dial 705d980456f91652 on stream MsgApp v2 (dial tcp 172.31.0.3:2380: getsockopt: connection refused)
2016-05-01 18:57:26.553392 E | rafthttp: failed to dial 705d980456f91652 on stream Message (dial tcp 172.31.0.3:2380: getsockopt: connection refused)
2016-05-01 18:57:26.553424 E | rafthttp: failed to dial 74627c91d7ab4b54 on stream Message (dial tcp 172.31.0.2:2380: getsockopt: connection refused)
2016-05-01 18:57:26.553450 E | rafthttp: failed to dial 74627c91d7ab4b54 on stream MsgApp v2 (dial tcp 172.31.0.2:2380: getsockopt: connection refused)
```

Der `etcd` Daemon auf `ip-172-31-0-1` beginnt dann zu prüfen, ob alle Mitglieder online sind. Die Logs zeigen die Verbindung wurde verweigert `ip-172-31-0-2` und `ip-172-31-0-3` sind noch offline. Gehen wir zum nächsten Mitglied und führen den Befehl `etcd` aus:
```
// on the host ip-172-31-0-2, running etcd command to make it peer with ip-172-31-0-1 and ip-172-31-0-3, advertise and listen other members via port 2379, and accept peer traffic via port 2380
# etcd -name ip-172-31-0-2 \
       -initial-advertise-peer-urls http://172.31.0.2:2380 \
       -listen-peer-urls http://172.31.0.2:2380 \
       -listen-client-urls http://0.0.0.0:2379 \
       -advertise-client-urls http://172.31.0.2:2379 \
       -initial-cluster-token mytoken \
       -initial-cluster ip-172-31-0-1=http://172.31.0.1:2380,ip-172-31-0-2=http://172.31.0.2:2380, ip-172-31-0-3=http://172.31.0.3:2380 -initial-cluster-state new
...
2016-05-01 22:59:55.696357 I | etcdserver: starting member 74627c91d7ab4b54 in cluster 8e620b738845cd7
2016-05-01 22:59:55.696397 I | raft: 74627c91d7ab4b54 became follower at term 0
2016-05-01 22:59:55.696407 I | raft: newRaft 74627c91d7ab4b54 [peers: [], term: 0, commit: 0, applied: 0, lastindex: 0, lastterm: 0]
2016-05-01 22:59:55.696411 I | raft: 74627c91d7ab4b54 became follower at term 1
2016-05-01 22:59:55.706552 I | etcdserver: starting server... [version: 2.2.5, cluster version: to_be_decided]
2016-05-01 22:59:55.707627 E | rafthttp: failed to dial 705d980456f91652 on stream MsgApp v2 (dial tcp 172.31.0.3:2380: getsockopt: connection refused)
2016-05-01 22:59:55.707690 N | etcdserver: added member 705d980456f91652 [http://172.31.0.3:2380] to cluster 8e620b738845cd7
2016-05-01 22:59:55.707754 N | etcdserver: added local member 74627c91d7ab4b54 [http://172.31.0.2:2380] to cluster 8e620b738845cd7
2016-05-01 22:59:55.707820 N | etcdserver: added member e980eb6ff82d4d42 [http://172.31.0.1:2380] to cluster 8e620b738845cd7
2016-05-01 22:59:55.707873 E | rafthttp: failed to dial 705d980456f91652 on stream Message (dial tcp 172.31.0.3:2380: getsockopt: connection refused)
2016-05-01 22:59:55.708433 I | rafthttp: the connection with e980eb6ff82d4d42 became active
2016-05-01 22:59:56.196750 I | raft: 74627c91d7ab4b54 is starting a new election at term 1
2016-05-01 22:59:56.196903 I | raft: 74627c91d7ab4b54 became candidate at term 2
2016-05-01 22:59:56.196946 I | raft: 74627c91d7ab4b54 received vote from 74627c91d7ab4b54 at term 2
2016-05-01 22:59:56.949201 I | raft: raft.node: 74627c91d7ab4b54 elected leader e980eb6ff82d4d42 at term 112
2016-05-01 22:59:56.961883 I | etcdserver: published {Name:ip-172-31-0-2 ClientURLs:[http://10.0.0.2:2379]} to cluster 8e620b738845cd7
2016-05-01 22:59:56.966981 N | etcdserver: set the initial cluster version to 2.1
```

Nach dem Start vom member 2 sehen wir, dass die aktuelle Cluster version `2.1` ist . Die folgende Fehlermeldung zeigt die Verbindung zum Peer `705d980456f91652` ist nicht in ordnung. Durch das Beobachten des Protokolls können wir feststellen, dass das Mitglied `705d980456f91652` auf `http://172.31.0.3:2380` zeigt. Lass uns das letzte Mitglied starten `ip-172-31-0-3`:
```
# etcd -name ip-172-31-0-3 \
       -initial-advertise-peer-urls http://172.31.0.3:2380 \
       -listen-peer-urls http://172.31.0.3:2380 \
       -listen-client-urls http://0.0.0.0:2379 \
       -advertise-client-urls http://172.31.0.3:2379 \
       -initial-cluster-token mytoken \
       -initial-cluster ip-172-31-0-1=http://172.31.0.1:2380,ip-172-31-0-2=http://172.31.0.2:2380, ip-172-31-0-3=http://172.31.0.3:2380 -initial-cluster-state new
2016-05-01 19:02:19.106540 I | etcdserver: starting member 705d980456f91652 in cluster 8e620b738845cd7
2016-05-01 19:02:19.106590 I | raft: 705d980456f91652 became follower at term 0
2016-05-01 19:02:19.106608 I | raft: newRaft 705d980456f91652 [peers: [], term: 0, commit: 0, applied: 0, lastindex: 0, lastterm: 0]
2016-05-01 19:02:19.106615 I | raft: 705d980456f91652 became follower at term 1
2016-05-01 19:02:19.118330 I | etcdserver: starting server... [version: 2.2.5, cluster version: to_be_decided]
2016-05-01 19:02:19.120729 N | etcdserver: added local member 705d980456f91652 [http://10.0.0.75:2380] to cluster 8e620b738845cd7
2016-05-01 19:02:19.120816 N | etcdserver: added member 74627c91d7ab4b54 [http://10.0.0.204:2380] to cluster 8e620b738845cd7
2016-05-01 19:02:19.120887 N | etcdserver: added member e980eb6ff82d4d42 [http://10.0.0.205:2380] to cluster 8e620b738845cd7
2016-05-01 19:02:19.121566 I | rafthttp: the connection with 74627c91d7ab4b54 became active
2016-05-01 19:02:19.121690 I | rafthttp: the connection with e980eb6ff82d4d42 became active
2016-05-01 19:02:19.143351 I | raft: 705d980456f91652 [term: 1] received a MsgHeartbeat message with higher term from e980eb6ff82d4d42 [term: 112]
2016-05-01 19:02:19.143380 I | raft: 705d980456f91652 became follower at term 112
2016-05-01 19:02:19.143403 I | raft: raft.node: 705d980456f91652 elected leader e980eb6ff82d4d42 at term 112
2016-05-01 19:02:19.146582 N | etcdserver: set the initial cluster version to 2.1
2016-05-01 19:02:19.151353 I | etcdserver: published {Name:ip-172-31-0-3 ClientURLs:[http://10.0.0.75:2379]} to cluster 8e620b738845cd7
2016-05-01 19:02:22.022578 N | etcdserver: updated the cluster version from 2.1 to 2.2
```

Wir können sehen, auf Mitglied 3 haben wir den etcd Cluster ohne Fehler erfolgreich initiiert und die aktuelle Clusterversion ist `2.2`. Wie wäre es mit Mitglied 1?
```
2016-05-01 19:02:19.118910 I | rafthttp: the connection with 705d980456f91652 became active
2016-05-01 19:02:22.014958 I | etcdserver: updating the cluster version from 2.1 to 2.2
2016-05-01 19:02:22.018530 N | etcdserver: updated the cluster version from 2.1 to 2.2
```

Mit Mitglied 2 und 3 sind online jetzt kann Mitglied 1 verbunden werden und auch online gehen. Bei der Beobachtung des Protokolls können wir sehen, dass die _leader_ Wahl im etcd-Cluster stattgefunden hat:
```
ip-172-31-0-1: raft: raft.node: e980eb6ff82d4d42 (ip-172-31-0-1) elected leader e980eb6ff82d4d42 (ip-172-31-0-1) at term 112
ip-172-31-0-2: raft: raft.node: 74627c91d7ab4b54 (ip-172-31-0-2) elected leader e980eb6ff82d4d42 (ip-172-31-0-1) at term 112
ip-172-31-0-3: 2016-05-01 19:02:19.143380 I | raft: 705d980456f91652 became follower at term 112
```

Der etcd-Cluster sendet den Heartbeat an die Mitglieder im Cluster, um den Gesundheitszustand zu überprüfen. Beachten Sie, dass, wenn Sie irgendwelche Mitglieder in den Cluster hinzufügen oder entfernen müssen, der vorhergehende etcd-Befehl auf allen Mitgliedern erneut ausgeführt werden muss, um diese zu benachrichtigen, dass es neue Mitglieder gibt, die dem Cluster beitreten. 
Auf diese Weise sind alle Mitglieder im Cluster auf alle Online-Mitglieder aufmerksam geworden. Wenn ein Knoten offline geht, werden die anderen Mitglieder das Fehlerhaft mitglied abfragen, bis es die Mitglieder durch den Befehl etcd aktualisiert haben. Wenn wir eine Nachricht von einem Mitglied setzen, könnten wir die gleiche Nachricht von den anderen Mitgliedern auch bekommen. Wenn ein Mitglied fehlerhaft wird, werden die anderen Mitglieder im etcd-Cluster noch im Dienst sein und sich für einen neuen leader entscheiden.

### Etcd entdeckung

Bevor Sie die etcd-Erkennung verwenden, sollten Sie eine Discovery-URL haben, die zum bootstrapen eines Clusters verwendet wird. Wenn Sie ein Mitglied hinzufügen oder entfernen möchten, sollten Sie den Befehl `etcdctl` als Laufzeitkonfiguration verwenden. Die Kommandozeile ist genau so wie der statische Mechanismus. Was wir tun müssen, ist, `-initial-cluster` in `-discovery` zu ändern, mit dem die Discovery-Service-URL angegeben wird. Wir könnten den etcd Discovery Service (https://discovery.etcd.io) verwenden, um eine Discovery URL anzufordern:
```
// get size=3 cluster url from etcd discovery service
# curl -w "\n" 'https://discovery.etcd.io/new?size=3'
https://discovery.etcd.io/be7c1938bbde83358d8ae978895908bd
// Init a cluster via requested URL
# etcd -name ip-172-31-0-1 -initial-advertise-peer-urls http://172.31.43.209:2380 \
 -listen-peer-urls http://172.31.0.1:2380 \
 -listen-client-urls http://0.0.0.0:2379 \
 -advertise-client-urls http://172.31.0.1:2379 \
 -discovery https://discovery.etcd.io/be7c1938bbde83358d8ae978895908bd
...
2016-05-02 00:28:08.545651 I | etcdmain: listening for peers on http://172.31.0.1:2380
2016-05-02 00:28:08.545756 I | etcdmain: listening for client requests on http://127.0.0.1:2379
2016-05-02 00:28:08.545807 I | etcdmain: listening for client requests on http://172.31.0.1:2379
2016-05-02 00:28:09.199987 N | discovery: found self e980eb6ff82d4d42 in the cluster
2016-05-02 00:28:09.200010 N | discovery: found 1 peer(s), waiting for 2 more
```

Das erste Mitglied ist dem Cluster beigetreten; Wartet auf die beiden anderen Peers. Lassen Sie uns im zweiten Knoten starten:

```
# etcd -name ip-172-31-0-2 -initial-advertise-peer-urls http://172.31.0.2:2380 \
 -listen-peer-urls http://172.31.0.2:2380 \
 -listen-client-urls http://0.0.0.0:2379 \
 -advertise-client-urls http://172.31.0.2:2379 \
 -discovery https://discovery.etcd.io/be7c1938bbde83358d8ae978895908bd
...
2016-05-02 00:30:12.919005 I | etcdmain: listening for peers on http://172.31.0.2:2380
2016-05-02 00:30:12.919074 I | etcdmain: listening for client requests on http://0.0.0.0:2379
2016-05-02 00:30:13.018160 N | discovery: found self 25fc8075ab1ed17e in the cluster
2016-05-02 00:30:13.018235 N | discovery: found 1 peer(s), waiting for 2 more
2016-05-02 00:30:22.985300 N | discovery: found peer e980eb6ff82d4d42 in the cluster
2016-05-02 00:30:22.985396 N | discovery: found 2 peer(s), waiting for 1 more

```
Wir wissen, dass es schon zwei Mitglieder in etcd gibt und sie warten auf den letzten, der mitmacht. Der folgende Code startet den letzten Node:

```
# etcd -name ip-172-31-0-3 -initial-advertise-peer-urls http://172.31.0.3:2380 \
 -listen-peer-urls http://172.31.0.3:2380 \
 -listen-client-urls http://0.0.0.0:2379 \
 -advertise-client-urls http://172.31.0.3:2379 \
 -discovery https://discovery.etcd.io/be7c1938bbde83358d8ae978895908bd
```

Nachdem der neue nodes beitreten ist, können wir aus den logs überprüfen, dass es eine neue wahl stattfindet:
```
2016-05-02 00:31:01.152215 I | raft: e980eb6ff82d4d42 is starting a new election at term 308
2016-05-02 00:31:01.152272 I | raft: e980eb6ff82d4d42 became candidate at term 309
2016-05-02 00:31:01.152281 I | raft: e980eb6ff82d4d42 received vote from e980eb6ff82d4d42 at term 309
2016-05-02 00:31:01.152292 I | raft: e980eb6ff82d4d42 [logterm: 304, index: 9739] sent vote request to 705d980456f91652 at term 309
2016-05-02 00:31:01.152302 I | raft: e980eb6ff82d4d42 [logterm: 304, index: 9739] sent vote request to 74627c91d7ab4b54 at term 309
2016-05-02 00:31:01.162742 I | rafthttp: the connection with 74627c91d7ab4b54 became active
2016-05-02 00:31:01.197820 I | raft: e980eb6ff82d4d42 received vote from 74627c91d7ab4b54 at term 309
2016-05-02 00:31:01.197852 I | raft: e980eb6ff82d4d42 [q:2] has received 2 votes and 0 vote rejections
2016-05-02 00:31:01.197882 I | raft: e980eb6ff82d4d42 became leader at term 309

```

Mit der Entdeckungsmethode können wir sehen, dass der Cluster gestartet werden kann, ohne die IPs vorher zu kennen. Etcd wird eine neue Wahl beginnen, wenn neue Nodes beitreten oder den Cluster verlassen, und immer den Service online halten mit der Multi-Node Einstellung.