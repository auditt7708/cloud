---
title: docker-daten-mgmnt-multihost-flanell
description: 
published: true
date: 2021-06-09T15:09:38.427Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:09:33.235Z
---

# Docker Multihost managenment mit flanell

In diesem Rezept verwenden wir Flannel (https://github.com/coreos/flannel), um Multihost-Container-Netzwerke einzurichten. Flanell ist ein generisches Overlay-Netzwerk, das als Alternative zu Software Defined Networking (SDN) verwendet werden kann. Es handelt sich um eine IP-basierte Lösung, die virtuelles Extensible LAN (VXLAN) verwendet, bei dem jedem Container ein einzelnes Subnetz zugeordnet wird, das dem Host, der diesen Container ausführt, zugewiesen wird. Also, in dieser Art von Lösung, ein anderes Subnetz und Kommunikation tritt in jedem Host im Cluster, mit dem Overlay-Netzwerk. Flannel verwendet den etcd-Service (https://github.com/coreos/etcd) für den Key-Value-Store.

## Fertig werden

Für dieses Rezept benötigen wir drei VMs oder physische Maschinen mit Fedora 21 installiert.

## Wie es geht…

1. Nennen wir eine Maschine / VM `Master` und andere zwei `minion1` und `minion2`. Entsprechend den IP-Adressen Ihres Systems aktualisieren Sie die Datei `/etc/hosts` wie folgt:

2. Installiere `etcd`, `Flanell` und `Docker` auf allen Systemen, die wir eingerichtet haben:
`$ yum install -y etcd flannel docker`

3. Ändern Sie den Wert des `ETCD_LISTEN_CLIENT_URLS` zu `http://master.example.com:4001` in der Datei `/etc/etcd/etcd.conf` wie folgt:
ETCD_LISTEN_CLIENT_URLS="http://master.example.com:4001"

4. Im Master starten Sie den `etcd`-Service und überprüfen den Status:

```s
$ systemctl start etcd
$ systemctl enable etcd
$ systemctl status etcd
```

5. Erstellen Sie im Master eine Datei namens `flannel-config.json` mit folgendem Inhalt:

```s
{
"Network": "10.0.0.0/16",
"SubnetLen": 24,
"Backend": {
"Type": "vxlan",
"VNI": 1
   }
}
```

6.Laden Sie die vorherige Konfigurationsdatei in `etcd` mit `config` als Schlüssel hoch:
`$ curl -L http://master.example.com:4001/v2/keys/coreos.com/network/config -XPUT --data-urlencode value@flannel-config.json`

7.Im Master aktualisieren Sie `FLANNEL_OPTIONS` in der Datei `/etc/sysconfig/flanneld`, um die Schnittstelle des Systems zu reflektieren. Auch aktualisieren Sie `FLANNEL_ETCD`, um Hostname anstelle der Adresse 127.0.0.1:4001 zu verwenden.

```s
FLANNEL_ETCD="http://master.example.com:4001"
FLANNEL_ETCD_KEY="/coreos.com/network"
FLANNEL_OPTIONS="eno1"
```

8.So aktivieren und starten Sie den Flanneldienst im Master:

```s
$ systemctl enable flanneld
$ systemctl start flanneld
$ systemctl status flanneld
```

9.From the minion systems, check the connectivity to master for `etcd`:

`[root@minion1 ~]#  curl -L http://master.example.com:4001/v2/keys/coreos.com/network/config`

10.Aktualisieren Sie die Datei `/etc/sysconfig/flanneld` in beiden Minions, um auf den `etcd`-Server zu verweisen, der im Master ausgeführt wird, und aktualisieren Sie `FLANNEL_OPTIONS`, um die Schnittstelle des Minion-Hosts zu reflektieren:
`cat /etc/sysconfig/flanneld`

11.Um den `flanneld` dienst in beiden Minions zu aktivieren und zu starten:

```s
$ systemctl enable flanneld
$ systemctl start flanneld
$ systemctl status flanneld
```

12.Führen Sie in einem der Hosts im Cluster den folgenden Befehl aus:
`$ curl -L http://master.example.com:4001/v2/keys/coreos.com/network/subnets | python -mjson.tool`

Dies sagt uns die Anzahl der Hosts im Netzwerk und die zugeordneten Subnetze (mit Blick auf den Schlüssel für jeden Knoten) mit ihnen. Wir können das Subnetz mit der MAC-Adresse auf den Hosts verknüpfen. Auf jedem Host werden die Dateien `/run/flannel/docker` und `/run/flannel/subnet.env` mit Subnetzinformationen gefüllt. Zum Beispiel, in `minion2`, würdest du so etwas wie folgendes sehen:

`cat /run/flannel/docker`

13.Um den Docker-Daemon in allen Hosts neu zu starten:

`$ systemctl restart docker`

Dann schau auf die IP-Adresse der `docker0` und `flannel.1` Schnittstellen. In `minion2` sieht es wie folgt aus:

`ip addr show `

Wir können sehen, dass die `docker0`-Schnittstelle die IP aus dem gleichen Subnetz wie die `flanell.1`-Schnittstelle bekam, mit der der gesamte Verkehr verlegt wird.

14.Wir sind alle eingestellt, um zwei Container in jedem der Gastgeber und sie sollten in der Lage zu kommunizieren. Lassen Sie uns einen Container in `minion1` erstellen und erhalten Sie seine IP-Adresse:
`docker run -it centos bash`

15.Erstellen Sie nun einen weiteren Container in `minion2` und ping den Container in `minion1` wie folgt:
`docker run -it centos bash`

## Wie es funktioniert…

Mit Flannel konfigurieren wir zunächst das Overlay mit dem `10.0.0.0/16` Netzwerk. Dann nimmt jeder Host ein zufälliges `/24` Netzwerk auf; Zum Beispiel, in unserem Fall, `minion2` bekommt die `10.0.62.0/24` Subnetz und so weiter. Einmal konfiguriert, bekommt ein Container im Host die IP-Adresse aus dem gewählten Subnetz. Flanell kapselt die Pakete und sendet sie an entfernte Hosts mit UDP.

Auch bei der Installation kopiert Flannel eine Konfigurationsdatei (`flannel.conf`) innerhalb `/usr/lib/systemd/system/docker.service.d/`, die Docker verwendet, um sich selbst zu konfigurieren.

## Siehe auch

* Das Diagramm von Flannel GitHub, um Ihnen zu helfen, die Theorie der Operationen unter https://github.com/coreos/flannel/blob/master/packet-01.png zu verstehen

* Die Dokumentation auf der CoreOS-Website unter https://coreos.com/blog/introducing-rudder/

* Scott Colliers Blog-Post über die Einstellung Flannel auf Fedora auf http://www.colliernotes.com/2015/01/flannel-and-docker-on-fedora-getting.html
