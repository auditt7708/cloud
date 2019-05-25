Bisher haben wir mit einem einzigen Container gearbeitet und darauf lokal zugegriffen. Aber wenn wir in echte Praktische Fälle wechseln, müssen wir auf den Container von der Außenwelt zugreifen, den externen Speicher im Container freigeben, mit Containern kommunizieren, die auf anderen Hosts laufen und so weiter. In diesem Kapitel werden wir sehen, wie wir einige dieser Anforderungen erfüllen können. Lassen Sie uns beginnen, indem Sie das Standard-Netzwerk-Setup von Docker verstehen und dann zu fortgeschrittenen Anwendungsfällen gehen.

Wenn der Docker-Daemon startet, erstellt er eine virtuelle Ethernet-Bridge mit dem Namen `docker0`. Zum Beispiel werden wir folgendes mit dem Befehl `ip addr` auf dem System sehen, das den Docker-Daemon ausführt:
```
6: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:53:c7:17:8f brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:53ff:fec7:178f/64 scope link 
       valid_lft forever preferred_lft forever
```

Wie wir sehen können, hat docker0 die IP-Adresse 172.17.0.1/16. Docker wählt zufällig eine Adresse und ein Subnetz aus einem privaten Bereich, der in RFC 1918 definiert ist (https://tools.ietf.org/html/rfc1918). Mit dieser überbrückten Schnittstelle können Container miteinander und mit dem Host-System kommunizieren.

Standardmäßig wird jedes Mal, wenn Docker einen Container startet, ein Paar virtueller Schnittstellen erstellt, von denen ein Ende dem Host-System und dem anderen Ende des erstellten Containers zugeordnet ist. Lassen Sie uns einen Container anfangen und sehen, was passiert:

`docker run -it centos bash`

Das Ende, das an die `eth0`-Schnittstelle des Containers angeschlossen ist, erhält die IP-Adresse 172.17.0.1/16. Wir sehen auch den folgenden Eintrag für das andere Ende der Schnittstelle auf dem Host-System:
```
8: veth4f52bc6@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether 26:8a:c7:fa:9f:b7 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::248a:c7ff:fefa:9fb7/64 scope link 
       valid_lft forever preferred_lft forever

```

Nun wollen wir noch ein paar Container erstellen und die Brücke `docker0` mit dem `brctl`-Befehl betrachten, der Ethernet-Brücken verwaltet:
`brctl show docker0`
Ausgabe:
```
bridge name	bridge id		STP enabled	interfaces
docker0		8000.024253c7178f	no		veth4f52bc6

```

Jeder veth * bindet an die `docker0`-Brücke, die ein virtuelles Subnetz erzeugt, das zwischen dem Host und jedem Docker-Container geteilt wird. Abgesehen von der Einrichtung der `docker0`-Brücke erstellt Docker IPtables-NAT-Regeln, so dass alle Container standardmäßig mit der externen Welt reden können, aber nicht umgekehrt. Schauen wir uns die NAT-Regeln auf dem Docker-Host an:
`iptables -t nat -L -n`
Ausgabe:
```
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
RETURN     all  --  192.168.122.0/24     224.0.0.0/24        
RETURN     all  --  192.168.122.0/24     255.255.255.255     
MASQUERADE  tcp  --  192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
MASQUERADE  udp  --  192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
MASQUERADE  all  --  192.168.122.0/24    !192.168.122.0/24    
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0           
MASQUERADE  all  --  10.0.3.0/24         !10.0.3.0/24         
MASQUERADE  tcp  --  172.17.0.2           172.17.0.2           tcp dpt:6379

Chain DOCKER (2 references)
target     prot opt source               destination         
RETURN     all  --  0.0.0.0/0            0.0.0.0/0           
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:32768 to:172.17.0.2:6379
```

Wenn wir versuchen, eine Verbindung zur Außenwelt aus einem Container herzustellen, müssen wir die Docker-Brücke durchlaufen, die standardmäßig erstellt wurde:

Später in diesem Kapitel werden wir sehen, wie sich die Außenwelt mit einem Container verbinden kann.

Beim Starten eines Containers haben wir ein paar Modi, um seine Netzwerke auszuwählen:

* `--net=bridge`: Dies ist der Standardmodus, den wir gerade gesehen haben. So kann der vorherige Befehl, den wir verwendet haben, um den Container zu starten, wie folgt geschrieben werden:
`$ docker run -i -t --net=bridge centos /bin/bash `

* `--net=host`: Mit dieser Option erstellt Docker keinen Netzwerk-Namespace für den Container. Stattdessen wird der Container Netzwerk-Stack mit dem Host verbunden. So können wir den Container mit dieser Option wie folgt starten:
` $ docker run -i -t  --net=host centos bash `

Wir können dann den `ip addr` Befehl innerhalb des Containers ausführen, wie hier zu sehen:

`docker run -i -t --net=host centos /bin/bash`

Wir können alle an den Host angeschlossenen Netzwerkgeräte sehen. Ein Beispiel für die Verwendung einer solchen Konfiguration besteht darin, den nginx-Reverse-Proxy in einem Container auszuführen, um die auf dem Host laufenden Webanwendungen zu bedienen.

* `--net=container:NAME_or_ID`: Mit dieser Option erstellt Docker beim Start des Containers keinen neuen Netzwerk-Namespace, sondern teilt ihn mit einem anderen Container. Lass uns den ersten Container starten und nach seiner IP-Adresse suchen:
`$ docker run -i -t --name=centos centos bash `

Fang nun wie folgt an:
`$ docker run -i -t --net=container:centos ubuntu bash`

Wie wir sehen können, enthalten beide Container die gleiche IP-Adresse.

Container in einem Kubernetes (http://kubernetes.io/) Pod verwenden diesen Trick, um sich miteinander zu verbinden.

* `--net=none`: Mit dieser Option erstellt Docker den Netzwerk-Namespace im Container, konfiguriert aber keine Netzwerke.

### Hinweis:
Für weitere Informationen über die verschiedenen Netzwerke, die wir im vorigen Abschnitt besprochen haben, besuchen Sie https://docs.docker.com/articles/networking/#how-docker-networks-a-container.

Ab Docker 1.2 ist es auch möglich, `/etc/host`, `/etc/hostname` und `/etc/resolv.conf` auf einem laufenden Container zu ändern. Beachten Sie jedoch, dass diese nur zum Ausführen eines Containers verwendet werden. Wenn er neu startet, müssen wir die Änderungen wieder vornehmen.

Bisher haben wir uns die Vernetzung auf einem einzigen Host angesehen, aber in der realen Welt möchten wir mehrere Hosts miteinander verbinden und einen Container von einem Host haben, um mit einem Container von einem anderen Host zu sprechen. Flanell (https://github.com/coreos/flannel), Weave (https://github.com/weaveworks/weave), Calio (http://www.projectcalico.org/getting-started/docker/), Und Socketplane (http://socketplane.io/) sind einige Lösungen, die diese Funktionalität bieten. Später in diesem Kapitel werden wir sehen, wie man Flannel auf Multihost Networking konfiguriert. Socketplane trat Docker Inc im März '15 bei.

Community und Docker bauen ein Container Network Model (CNM) mit libnetwork (https://github.com/docker/libnetwork) auf, das eine native Implementierung zum Verbinden von Containern bietet. Weitere Informationen zu dieser Entwicklung finden Sie unter http://blog.docker.com/2015/04/docker-networking-takes-a-step-in-die-Right-direction-2/.

### Übersicht

* [Zugriff auf Container von außen](../docker-daten-mgmnt-network-remote)

* [Verwalten von Daten in Containern](../docker-daten-mgmnt-verwalten)

* [Verknüpfung von zwei oder mehr Containern](../docker-daten-mgmnt-verknuepfen)

* [Entwicklung einer LAMP-Anwendung durch Verknüpfung von Containern](../docker-daten-mgmnt-lamp-example)

* [Vernetzung von Multihost-Container mit Flanell](../docker-daten-mgmnt-multihost-flanell)

* [Zuweisen von IPv6-Adressen zu Containern](../docker-daten-mgmnt-net-ipv6)