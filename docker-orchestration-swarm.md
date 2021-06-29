---
title: docker-orchestration-swarm
description: 
published: true
date: 2021-06-09T15:13:58.677Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:13:53.440Z
---

# Docker swarm

Docker Swarm (http://docs.docker.com/swarm/) ist native Clustering für Docker. Es gruppiert mehrere Docker-Hosts in einem einzigen Pool, in dem man Container starten kann. In diesem Rezept verwenden wir Docker Machine (http://docs.docker.com/machine/), um einen Swarm-Cluster einzurichten. Zum Zeitpunkt des Schreibens ist Swarm in Docker Integriert. Um die Dinge einfach zu halten, verwenden wir VirtualBox als Backend für Docker Machine, um Hosts zu konfigurieren.

## Fertig werden

1.Installiere VirtualBox auf deinem System (https://www.virtualbox.org/). Die Anleitung zur Konfiguration von VirtualBox liegt außerhalb des Umfangs dieses Buches.

2.Docker Machine herunterladen und einrichten. Führen Sie in Fedora x86_64 die folgenden Befehle aus:

```s
$ wget  https://github.com/docker/machine/releases/download/v0.2.0/docker-machine_linux-amd64 
$ sudo mv  docker-machine_linux-amd64 /usr/local/bin/docker-machine
$ chmod a+x  /usr/local/bin/docker-machine
```

## Wie es geht…

1.Mit dem Swarm Discovery Service müssen wir zunächst ein Swarm Token erstellen, um unseren Cluster eindeutig zu identifizieren. Anders als der standardmäßig gehostete Ermittlungsdienst unterstützt Swarm verschiedene Arten von discovery service wie etcd, consul und zookeeper.
Weitere Informationen finden Sie unter https://docs.docker.com/swarm/discovery/. 
Um einen Token mit dem standardmäßig gehosteten Discovery-Service zu erstellen, richten wir zunächst den Docker-Host mit Docker Machine auf einer VM ein und bekommst dann das Token:
`$ docker-machine create -d virtualbox local`

2.Um auf den Docker zuzugreifen, den wir gerade von deinem lokalen Docker-Client erstellt haben, führen Sie den folgenden Befehl aus:
`$ eval "$(docker-machine env local)"`

3.Um dden Token zu erhalten, führen Sie den folgenden Befehl aus:

```s
$ docker run swarm create
7c3a21b42708cde81d99884116d68fa1
```

4.Mit dem im vorherigen Schritt erstellten Token den Swarm-Master einrichten:

```s
$ docker-machine create  -d virtualbox  --swarm  --swarm-master  --swarm-discovery token://7c3a21b42708cde81d99884116d68fa1  swarm-master
```

5.Ebenso schaffen wir zwei Swarm-Knoten:

```s
$ docker-machine create -d virtualbox  --swarm  --swarm-discovery token://7c3a21b42708cde81d99884116d68fa1 swarm-node-1
$ docker-machine create -d virtualbox  --swarm  --swarm-discovery token://7c3a21b42708cde81d99884116d68fa1 swarm-node-2
```

6.Jetzt verbinden Sie sich mit Docker Swarm von Ihrem lokalen Docker-Client:

`$ eval "$(docker-machine env swarm-master)"`

7.Swarm-APIs sind mit Docker-Client-APIs kompatibel. Lass uns den Docker-Info-Befehl ausführen, um die aktuelle Konfiguration / Einrichtung von Swarm zu sehen:

`$ docker info`

Wie Sie sehen können, haben wir drei Knoten im Cluster: einen Master und zwei Knoten.

## Wie es funktioniert…

Mit dem einzigartigen Token, den wir aus dem gehosteten discovery service bekommen haben, haben wir den Master und die Knoten in einem Cluster registriert.

## Es gibt mehr…

* In der vorherigen Docker-Info-Ausgabe haben wir auch geplante Politik (Strategie) und Filter. Weitere Informationen dazu finden Sie unter https://docs.docker.com/swarm/scheduler/strategy/ und https://docs.docker.com/swarm/scheduler/filter/. Diese definieren, wo der Container läuft.

* Es gibt eine aktive Entwicklung, die dazu beiträgt, Docker Swarm und Docker Compose zu integrieren, damit wir die App zum Swarm-Cluster zeigen und komponieren. Die App wird dann auf dem Cluster starten. Besuchen Sie https://github.com/docker/compose/blob/master/SWARM.md

## Siehe auch

* Die Swarm-Dokumentation auf der Docker-Website unter https://docs.docker.com/swarm/

* Swarm's GitHub Repository unter https://github.com/docker/swarm
