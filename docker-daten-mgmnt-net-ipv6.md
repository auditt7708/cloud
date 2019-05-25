Standardmäßig ordnet Docker IPv4-Adressen den Containern zu. Mit Docker 1.5 wurde eine Funktion zur Unterstützung von IPv6-Adressen hinzugefügt.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon (Version 1.5 und höher) auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Um den Docker-Daemon mit der Option `--ipv6` zu starten, können wir diese Option in der Konfigurationsdatei des Dämons (`/etc/sysconfig/docker` auf Fedora) wie folgt hinzufügen:
`OPTIONS='--selinux-enabled --ipv6'`

Alternativ, wenn wir Docker im Daemon-Modus starten, dann können wir es wie folgt starten:
`$ docker -d --ipv6`

Wenn Sie einen dieser Befehle ausführen, wird Docker die `docker0` Bridge mit der IPv6-Local-Link-Adresse `fe80::1` einrichten.
`ip a show docker0`

2. Lassen Sie uns den Container starten und nach den ihm zugewiesenen IP-Adressen suchen:
```
ID=`docker run -itd centos bash`
docker inspect $ID | grep IP
```

Wie wir sehen können, sind sowohl die IPv4- als auch die lokalen Link-IPv6-Adressen für den Container verfügbar. Um die IPv6-Adresse eines Containers vom Hostcomputer zu pingen, führen Sie den folgenden Befehl aus:
`$ ping6 -I docker0 fe80::42:acff:fe11:3`

Um die Docker0-Brücke aus dem Container zu pingen, führen Sie den folgenden Befehl aus:
`[root@c7562c38bd0f /]# ping6 -I eth0 fe80::1   `

### Wie es funktioniert…

Docker konfiguriert die docker0-Brücke, um IPv6-Adressen zu Containern zuzuweisen, was es uns ermöglicht, die IPv6-Adresse von Containern zu verwenden.

### Es gibt mehr…

Standardmäßig werden Container die Link-Local-Adresse erhalten. Um ihnen eine global routbare Adresse zuzuweisen, können Sie die IPv6-Subnetz-Pick-Adresse mit --fixed-cidr-v6 wie folgt übergeben:
`$ docker -d --ipv6 --fixed-cidr-v6="2001:db8:1::/64"`

```
ID=`docker run -itd centos bash`
docker inspect $ID | grep IP
```

Von hier aus sehen wir, dass nun die globale routbare Adresse (GlobalIPv6Address) gesetzt ist.

### Siehe auch

* Die Docker 1.5 Release Notes unter https://blog.docker.com/2015/02/docker-1-5-ipv6-support-read-only-containers-stats-named-dockerfiles-and-more/.

* Die Dokumentation auf der Docker-Website unter http://docs.docker.com/v1.5/articles/networking/#ipv6.

* Möglicherweise müssen Sie die beendende docker0-Brücke auf dem Host löschen, bevor Sie die IPv6-Option festlegen. Um zu verstehen, wie dies zu tun ist, besuchen Sie http://docs.docker.com/v1.5/articles/networking/#customizing-docker0.