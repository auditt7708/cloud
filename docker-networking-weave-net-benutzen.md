---
title: docker-networking-weave-net-benutzen
description: 
published: true
date: 2021-06-09T15:11:44.778Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:11:39.393Z
---

# Docker Netzwerk mit weave net

Weave ist ein interessantes Beispiel, das die verschiedenen Möglichkeiten zeigt, wie eine Drittanbieterlösung mit Docker interagieren kann. Es bietet verschiedene Ansätze zur Interaktion mit Docker. Die erste ist die Weave-CLI, von der aus man nicht nur Weave konfigurieren kann, sondern auch Container, wie man es mit dem Docker CLI mag. Das zweite ist das Netzwerk-Plugin, das direkt an Docker bindet und Ihnen erlaubt, Container von Docker auf das Weave-Netzwerk zu bringen. In diesem Rezept gehen wir durch, wie man Container mit dem Weave-Netzwerk mit dem Weave CLI verbindet. Das Weave Netzwerk-Plugin wird in seinem eigenen Rezept später in diesem Kapitel behandelt werden.

## Hinweis

Weave bietet auch einen API-Proxy-Service an, der es Weave ermöglicht, sich als Shim zwischen Docker und Docker CLI transparent einzusetzen. Diese Konfiguration wird in diesem Kapitel nicht behandelt, aber sie haben ausführliche Dokumentation über diese Funktionalität an diesem Link:

Https://www.weave.works/docs/net/latest/weave-docker-api/

Fertig werden

Es wird davon ausgegangen, dass Sie sich aus dem Labor, das wir im ersten Rezept dieses Kapitels erstellt haben, aufbauen. Es wird auch davon ausgegangen, dass die Hosts Docker und Weave installiert haben. Das Weben, das wir im vorigen Kapitel definiert haben, wird auch angenommen.

## Wie es geht…

Wenn Sie die Weave-CLI verwenden, um Container-Konnektivität zu verwalten, gibt es zwei Ansätze, die Sie ergreifen können, um einen Container mit dem Weave-Netzwerk zu verbinden.

Der erste ist, den Webenbefehl zu verwenden, um einen Container zu führen. `Weave` erfüllt dies, indem du irgendetwas passierst, das du nach dem `weave run` zum Dockerlauf angegeben hast. Der Vorteil dieses Ansatzes ist, dass Weave auf die Verbindung aufmerksam gemacht wird, da es derjenige ist, der dem Docker tatsächlich sagt, den Container zu führen.

Damit ist Weave in einer perfekten Position, um sicherzustellen, dass der Container mit der richtigen Konfiguration für die Arbeit am Weave Netzwerk gestartet wird. Zum Beispiel können wir mit dieser Syntax einen Container namens `web1` auf dem Host-`docker1` starten:

`user@docker1:~$ weave run -dP --name=web1 jonlangemak/web_server_1`

## Hinweis

Trotz der Gemeinsamkeiten gibt es ein paar Unterschiede. Weave kann nur Container im Hintergrund- oder -D-Modus starten. Außerdem können Sie das Flag --rm nicht angeben, um den Container zu entfernen, nachdem er die Ausführung beendet hat.

Sobald der Container auf diese Weise gestartet ist, schauen wir uns die Schnittstellenkonfiguration des Containers an:

```s
user@docker1:~$ docker exec web1 ip addr
…<Loopback interface removed for brevity>…
20: eth0@if21: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link
       valid_lft forever preferred_lft forever
22: ethwe@if23: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP
    link/ether a6:f2:d0:36:6f:bd brd ff:ff:ff:ff:ff:ff
    inet 10.32.0.1/12 scope global ethwe
       valid_lft forever preferred_lft forever
    inet6 fe80::a4f2:d0ff:fe36:6fbd/64 scope link
       valid_lft forever preferred_lft forever
user@docker1:~$
```

Beachten Sie, dass der Container jetzt eine zusätzliche Schnittstelle namens `Ethwe` hat, die eine IP-Adresse von `10.32.0.1/12` hat. Dies ist die Weave-Netzwerkschnittstelle und wird zusätzlich zur Docker-Netzwerkschnittstelle (`eth0`) hinzugefügt. Wenn wir überprüfen, werden wir feststellen, dass seit dem Passieren der `-P`-Flagge Docker den Container-exponierten Port zu mehreren `eth0`-Schnittstellen veröffentlicht hat:

```s
user@docker1:~$ docker port web1
80/tcp -> 0.0.0.0:32785
user@docker1:~$ sudo iptables -t nat -S
…<Additional output removed for brevity>…
-A DOCKER ! -i docker0 -p tcp -m tcp --dport 32768 -j DNAT --to-destination 172.17.0.2:80 
user@docker1:~$
```

Dies beweist, dass die gesamte Port-Publishing-Funktionalität, die wir früher gesehen haben, noch über Docker-Netzwerkkonstrukte erfolgt. Die Weave-Schnittstelle wird zusätzlich zu den vorhandenen Docker nativen Netzwerkschnittstellen hinzugefügt.

Der zweite Ansatz, einen Container mit dem Weave-Netzwerk zu verbinden, kann auf zwei verschiedene Weisen erreicht werden, ergibt aber im Wesentlichen das gleiche Ergebnis. Vorhandene Docker-Container können dem Weave-Netzwerk hinzugefügt werden, indem entweder ein aktuell gestoppter Container mit der Weave-CLI gestartet wird oder indem ein laufender Container an Weave angehängt wird. Schauen wir uns jeden Ansatz an. Zuerst starten wir einen Container auf dem Host-`Docker2` in der gleichen Weise, wie wir normalerweise mit dem Docker-CLI arbeiten und dann mit Weave neu starten:

```s
user@docker2:~$ docker run -dP --name=web2 jonlangemak/web_server_2
5795d42b58802516fba16eed9445950123224326d5ba19202f23378a6d84eb1f
user@docker2:~$ docker stop web2
web2
user@docker2:~$ weave start web2
web2
user@docker2:~$ docker exec web2 ip addr
…<Loopback interface removed for brevity>…
15: eth0@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link
       valid_lft forever preferred_lft forever
17: ethwe@if18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP
    link/ether e2:22:e0:f8:0b:96 brd ff:ff:ff:ff:ff:ff
    inet 10.44.0.0/12 scope global ethwe
       valid_lft forever preferred_lft forever
    inet6 fe80::e022:e0ff:fef8:b96/64 scope link
       valid_lft forever preferred_lft forever
user@docker2:~$
```

So wie Sie sehen können, hat Weave das Hinzufügen der Weave-Schnittstelle zum Container übernommen, als es mit dem Weave CLI neu gestartet wurde. Ähnlich können wir eine zweite Instanz unseres `web1`-Containers auf dem Host `docker3` starten und dann dynamisch mit dem Weave-Netzwerk mit dem `weave-attach`-Befehl verbinden:

```s
user@docker3:~$ docker run -dP --name=web1 jonlangemak/web_server_1
dabdf098964edc3407c5084e56527f214c69ff0b6d4f451013c09452e450311d
user@docker3:~$ docker exec web1 ip addr
…<Loopback interface removed for brevity>…
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link
       valid_lft forever preferred_lft forever
user@docker3:~$ 
user@docker3:~$ weave attach web1
10.36.0.0
user@docker3:~$ docker exec web1 ip addr
…<Loopback interface removed for brevity>…
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link
       valid_lft forever preferred_lft forever
15: ethwe@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP
    link/ether de:d6:1c:03:63:ba brd ff:ff:ff:ff:ff:ff
    inet 10.36.0.0/12 scope global ethwe
       valid_lft forever preferred_lft forever
    inet6 fe80::dcd6:1cff:fe03:63ba/64 scope link
       valid_lft forever preferred_lft forever
user@docker3:~$
```

Wie wir in der vorangegangenen Ausgabe sehen können, hatte der Container keine `ethwe` Schnittstelle, bis wir ihn manuell an das Weave-Netzwerk anschlossen haben. Die Befestigung wurde dynamisch durchgeführt, ohne dass der Container neu gestartet werden musste. Zusätzlich zum Hinzufügen von Containern zum Weave-Netzwerk können Sie sie auch dynamisch aus Weave mit dem `weave detach`-Befehl entfernen.

An dieser Stelle sollten Sie eine Verbindung zwischen allen Containern haben, die jetzt mit dem Weave-Netzwerk verbunden sind. In meinem Fall erhielten sie folgende IP-Adressen:

* web1 on host docker1: 10.32.0.1

* web2 on host docker2: 10.44.0.0

* web1 on host docker3: 10.36.0.0 

```s
user@docker1:~$ docker exec -it web1 ping 10.44.0.0 -c 2
PING 10.40.0.0 (10.40.0.0): 48 data bytes
56 bytes from 10.40.0.0: icmp_seq=0 ttl=64 time=0.447 ms
56 bytes from 10.40.0.0: icmp_seq=1 ttl=64 time=0.681 ms
--- 10.40.0.0 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.447/0.564/0.681/0.117 ms
user@docker1:~$ docker exec -it web1 ping 10.36.0.0 -c 2
PING 10.44.0.0 (10.44.0.0): 48 data bytes
56 bytes from 10.44.0.0: icmp_seq=0 ttl=64 time=1.676 ms
56 bytes from 10.44.0.0: icmp_seq=1 ttl=64 time=0.839 ms
--- 10.44.0.0 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.839/1.257/1.676/0.419 ms
user@docker1:~$
```

Dies beweist, dass das Weave-Netzwerk wie erwartet funktioniert und die Container auf dem richtigen Netzwerksegment sind.
