---
title: mesos-saltstck-deployment-konfiguration
description: 
published: true
date: 2021-06-09T15:39:07.086Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:39:01.389Z
---

# Mesos Deployment mit Saltstack

Die SaltStack-Plattform oder Salt ist eine Python-basierte Open-Source-Konfigurations-Management-Software und eine Remote-Ausführungs-Engine.
Dieses Modul erklärt, wie wir SaltStack verwenden können, um einen Mesos-Cluster mit Marathon und ein paar anderen Tools in der Produktion zu installieren. SaltStack ist eine Alternative zu Puppet, Ansible, Chef und anderen.
Wie bei den anderen wird es verwendet, um die Bereitstellung und Konfiguration von Software auf mehreren Servern zu automatisieren.
Die SaltStack-Architektur besteht aus einem Knoten als SaltStack-Master und anderen Knoten als Minions (Slaves).
Es gibt auch zwei verschiedene Rollen: eine Master-Rolle, um Cluster-Aktionen und eine Slave-Rolle auszuführen, um die Docker-Container auszuführen.

Die folgenden Pakete werden für den Rollen master installiert:

* [ZooKeeper](../zookeeper)

* [The Mesos master](../mesos)

* [Marathon](../marathon)

* [Consul](../consul)

Die Slave-Rolle wird die folgenden Pakete installiert:

* The Mesos slave

* Docker

* cAdvisor (used to export metrics to prometheus)

* Registrator (used to register services with Consul)

* Weave (provides an overlay network between containers)

Nun, werfen wir einen Blick darauf, wie diese Komponenten in den Cluster schauen. 
Die folgende Abbildung zeigt, dass alle diese Komponenten im Cluster miteinander verbunden sind 

Quelle

* [SaltStack Mesos Test](https://github.com/Marmelatze/saltstack-mesos-test)

![saltstack-mesos.test](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_05_03.jpg)

## SaltStack-Installation

Wir müssen den Salt-Master installieren, um alle Salt-Minions zu koordinieren. SaltStack verlangt von den Meistern eine ungerade Nummer. Einer dieser Meister kann als der Salt-Master verwendet werden, und die anderen werden dann die Schergen. Folgen wir den hier beschriebenen Schritten, um SaltStack zu installieren:

1.Führen Sie den folgenden Befehl aus, um den Master und den Minion einzurichten:

```sh
curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -U -M -P -A localhost
#Clone the repository to /srv/salt this is where the configurations are kept.
sudo git clone https://github.com/Marmelatze/saltstack-mesos-test /srv/salt
```

2.Bearbeiten Sie die Datei `/etc/salt/master` und ändern Sie die Konfigurationen wie folgt:

```sh

file_roots:
  base:
    - /srv/salt/salt

# ...
pillar_roots:
  base:
    - /srv/salt/pillar
```

Jetzt den Meister neu starten:

`$ sudo service salt-master restart`

3.Bearbeiten Sie die Minion-Konfigurationsdatei unter `/etc/salt/minion` über den folgenden Code:

```sh
# ...
mine_interval: 5
mine_functions:
  network.ip_addrs:
    interface: eth0
  zookeeper:
    - mine_function: pillar.get
    - zookeeper
```

4.Bearbeiten Sie nun die `salt-grains` Datei, die sich unter `/etc/salt/grains` befindet, indem Sie den folgenden Code ausführen:

```sh
# /etc/salt/grains
# Customer-Id this host is assigned to (numeric)-
customer_id: 0
# ID of this host.
host_id: ID

 # ID for zookeeper, only needed for masters.
zk_id: ID

# Available roles are master & slave. Node can use both.
roles:
- master
- slave
```

5.Dann ersetzen Sie die ID mit einem numerischen Wert ab 1; Diese ID ähnelt der ZooKeeper ID, die wir früher verwendet haben.
Starten Sie nun den Minion mit folgendem Befehl neu:
$ sudo service salt-minion restart

6.Die öffentliche Schlüsselauthentifizierung wird für die Authentifizierung zwischen dem Minion und dem Master verwendet. Führen Sie dazu den folgenden Befehl aus:

`$ sudo salt-key -A`

7.Sobald wir mit den vorhergehenden Schritten fertig sind, können wir SaltStack mit folgendem Befehl ausführen:

`$ sudo salt '*' state.highstate`

Wenn alles erfolgreich ausgeführt wird, werden die Mesos-Dienste im Cluster ausgeführt.