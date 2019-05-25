Natürlich ist das nächste, was nach IPAM zu beachten ist Namensauflösung. Unabhängig von der Skala, mit einer Möglichkeit zu finden und zu identifizieren Container durch etwas anderes als eine IP-Adresse wird eine Notwendigkeit. Ähnlich wie neuere Versionen von Docker bietet Weave einen eigenen DNS-Service für die Behebung von Containernamen, die auf Weave-Netzwerken leben. In diesem Rezept werden wir die Standardkonfiguration für WeaveDNS überprüfen und zeigen, wie es implementiert ist, und einige relevante Konfigurationseinstellungen, um dich aufzurufen.

### Fertig werden

Es wird davon ausgegangen, dass Sie das Labor, das wir im ersten Rezept dieses Kapitels erstellt haben, ausbauen. Es wird auch davon ausgegangen, dass die Hosts Docker und Weave installiert haben. Docker sollte in seiner Standardkonfiguration sein und Weave sollte mit allen vier Hosts erfolgreich zusammengeführt werden, wie wir es im ersten Rezept dieses Kapitels getan haben.

### Wie es geht…

Wenn du bis zu diesem Punkt im Kapitel verfolgt hast, hast du bereits WeaveDNS bereitgestellt. WeaveDNS kommt mit dem Weave Router Container und ist standardmäßig aktiviert. Wir können das sehen, indem wir den Weave-Status betrachten:
```
user@docker1:~$ weave status
…<Additional output removed for brevity>…
        Service: dns
         Domain: weave.local.
       Upstream: 10.20.30.13
            TTL: 1
        Entries: 0
…<Additional output removed for brevity>…
```
Wenn Weave den DNS-Service vorstellt, beginnt er mit einigen gesunden Vorgaben. In diesem Fall wird festgestellt, dass mein Hosts DNS-Server `10.20.30.13` ist, und so hat es das als Upstream-Resolver konfiguriert. Es ist auch ausgewählt `weave.local` als Domain-Namen. Wenn wir einen Container mit der Webart-Syntax starten, wird Weave sicherstellen, dass der Container in einer Weise bereitgestellt wird, die es erlaubt, diesen DNS-Dienst zu verbrauchen. Zum Beispiel lasst uns einen Container auf dem Host `docker1 `starten:
```
user@docker1:~$ weave run -dP --name=web1 jonlangemak/web_server_1
c0cf29fb07610b6ffc4e55fdd4305f2b79a89566acd0ae0a6de09df06979ef36
user@docker1:~$ docker exec –t web1 more /etc/resolv.conf
nameserver 172.17.0.1
user@docker1:~$
```
Nach dem Starten des Containers können wir sehen, dass Weave die Datei `resolv.conf` des Containers anders konfiguriert hat als Docker. Erinnern Sie sich, dass Docker standardmäßig in nicht benutzerdefinierten Netzwerken einen Container die gleiche DNS-Konfiguration gibt, wie der Docker sich selbst hostet. In diesem Fall hat Weave dem Container einen Namenserver von `172.17.0.1` gegeben, der standardmäßig die der `docker0`-Brücke zugewiesene IP-Adresse ist. Sie könnten sich fragen, wie Weave erwartet, dass der Container sein eigenes DNS-System durch das Gespräch mit der `docker0`-Brücke zu lösen. Die Lösung ist ganz einfach. Der Weave-Router-Container wird im Host-Modus ausgeführt und hat einen Dienst, der an Port `53 `gebunden ist:
```
user@docker1:~$ docker network inspect host
…<Additional output removed for brevity>… 
"Containers": {        "03e3e82a5e0ced0b973e2b31ed9c2d3b8fe648919e263965d61ee7c425d9627c": {
                "Name": "weave",
…<Additional output removed for brevity>…
```
Wenn wir die auf dem Host gebundenen Ports überprüfen, können wir sehen, dass der Webrouter Port 53 verfügbar gemacht:

```
user@docker1:~$ sudo netstat -plnt
Active Internet connections (only servers)
…<some columns removed to increase readability>…
Proto Local Address State       PID/Program name
tcp   172.17.0.1:53 LISTEN      2227/weaver
```
Dies bedeutet, dass der WeaveDNS-Dienst im Weave-Container auf der `docker0`-Bridge-Schnittstelle für DNS-Anfragen abhört. Lassen Sie uns einen weiteren Container auf dem Host `docker2` starten:
``` 
user@docker2:~$ weave run -dP --name=web2 jonlangemak/web_server_2
b81472e86d8ac62511689185fe4e4f36ac4a3c41e49d8777745a60cce6a4ac05
user@docker2:~$ docker exec -it web2 ping web1 -c 2
PING web1.weave.local (10.32.0.1): 48 data bytes
56 bytes from 10.32.0.1: icmp_seq=0 ttl=64 time=0.486 ms
56 bytes from 10.32.0.1: icmp_seq=1 ttl=64 time=0.582 ms
--- web1.weave.local ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.486/0.534/0.582/0.048 ms
user@docker2:~$ 
```
Solange beide Container auf dem Weave-Netzwerk sind und die entsprechenden Einstellungen haben, erzeugt Weave automatisch einen DNS-Datensatz mit dem Namen des Containers. Wir können alle Namensdatensätze anzeigen Weave ist sich bewusst, den Befehl `weave status dns` von jedem Weave-fähigen Host zu verwenden:
```
user@docker2:~$ weave status dns
web1         10.32.0.1       86029a1305f1 12:d2:fe:7a:c1:f2
web2         10.44.0.0       56927d3bf002 e6:b1:90:cd:76:da
user@docker2:~$ 
```
Hier sehen wir den Containernamen, die IP-Adresse, die Container-ID und die MAC-Adresse der Weave-Netzwerkschnittstelle des Zielhosts.

Das funktioniert gut, setzt aber darauf, dass der Container mit den entsprechenden Einstellungen konfiguriert ist. Dies ist ein weiteres Szenario, bei dem die Weave-CLI eher hilfreich ist, da sie sicherstellt, dass diese Einstellungen zur Containerlaufzeit vorhanden sind. Zum Beispiel, wenn wir einen anderen Container auf dem Host-`Docker3 `mit der Docker-CLI starten und dann an Docker anhängen, wird es keinen DNS-Datensatz erhalten:
```
user@docker3:~$ docker run -dP --name=web1 jonlangemak/web_server_1
cd3b043bd70c0f60a03ec24c7835314ca2003145e1ca6d58bd06b5d0c6803a5c
user@docker3:~$ weave attach web1
10.36.0.0
user@docker3:~$ docker exec -it web1 ping web2
ping: unknown host
user@docker3:~$
```
Dies funktioniert nicht aus zwei Gründen. Zuerst weiß der Container nicht, wo man nach Weave DNS suchen kann, und es versucht, es durch den DNS-Server Docker zu beheben. In diesem Fall ist das eine auf dem Docker-Host konfiguriert:
```
user@docker3:~$ docker exec -it web1 more /etc/resolv.conf
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 10.20.30.13
search lab.lab
user@docker3:~$
```
Zweitens hat Weave keinen Rekord in WeaveDNS registriert, als der Container angeschlossen war. Damit Weave einen Datensatz für den Container in WeaveDNS generieren kann, muss sich der Container im selben Bereich befinden. Um dies zu tun, wenn Weave einen Container durch seine CLI führt, übergibt er den Hostnamen des Containers zusammen mit einem Domain-Namen. Wir können dieses Verhalten nachweisen, indem wir einen Hostnamen bereitstellen, wenn wir den Container in Docker ausführen. Zum Beispiel:
```
user@docker3:~$ docker stop web1
user@docker3:~$ docker rm web1
user@docker3:~$ docker run -dP --hostname=web1.weave.local \
--name=web1 jonlangemak/web_server_1
04bb1ba21b692b4117a9b0503e050d7f73149b154476ed5a0bce0d049c3c9357
user@docker3:~$
``` 
Jetzt, wenn wir den Container an das Weave-Netzwerk anschließen, sollten wir einen DNS-Datensatz für ihn anzeigen lassen:
```

user@docker3:~$ weave attach web1
10.36.0.0
user@docker3:~$ weave status dns
web1         10.32.0.1       86029a1305f1 12:d2:fe:7a:c1:f2
web1         10.36.0.0       5bab5eae10b0 ae:af:a6:36:18:37
web2         10.44.0.0       56927d3bf002 e6:b1:90:cd:76:da
user@docker3:~$
```
####### Hinweis
Wenn Sie diesen Container auch in der Lage sein würden, Datensätze in WeaveDNS aufzulösen, müssten Sie auch das Flag `--dns=172.17.0.1` an den Container übergeben, um sicherzustellen, dass sein DNS-Server auf die IP-Adresse des `docker0` eingestellt ist Brücke.

Sie haben vielleicht bemerkt, dass wir jetzt zwei Einträge in WeaveDNS für den gleichen Containernamen haben. Dies ist, wie Weave für die grundlegende Lastverteilung innerhalb der Weave-Netzwerk bietet. Zum Beispiel, wenn wir zurück zum `docker2`-Host gehen, lasst uns versuchen und ping den Namen `web1 `ein paar verschiedene Zeiten:
```
user@docker2:~$ docker exec -it web2 ping web1 -c 1
PING web1.weave.local (10.32.0.1): 48 data bytes
56 bytes from 10.32.0.1: icmp_seq=0 ttl=64 time=0.494 ms
--- web1.weave.local ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.494/0.494/0.494/0.000 ms
user@docker2:~$ docker exec -it web2 ping web1 -c 1
PING web1.weave.local (10.36.0.0): 48 data bytes
56 bytes from 10.36.0.0: icmp_seq=0 ttl=64 time=0.796 ms
--- web1.weave.local ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.796/0.796/0.796/0.000 ms
user@docker2:~$ docker exec -it web2 ping web1 -c 1
PING web1.weave.local (10.32.0.1): 48 data bytes
56 bytes from 10.32.0.1: icmp_seq=0 ttl=64 time=0.507 ms
--- web1.weave.local ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.507/0.507/0.507/0.000 ms
user@docker2:~$
```
Beachten Sie, wie sich der Container während des zweiten Ping-Versuchs auf eine andere IP-Adresse löst. Da es mehrere Datensätze in WeaveDNS für den gleichen Namen gibt, können wir grundlegende Load-Balancing-Funktionalität nur mit DNS. Weave wird auch den Zustand der Container verfolgen und tote Container aus WeaveDNS ziehen. Zum Beispiel, wenn wir den Container auf dem Host-`Docker3 `töten, sollten wir einen der `Web1`-Datensätze aus dem DNS herauslassen, wobei nur ein einziger Datensatz für `web1 `übrig bleibt:
```
user@docker3:~$ docker stop web1
web1
user@docker3:~$ weave status dns
web1         10.32.0.1       86029a1305f1 12:d2:fe:7a:c1:f2
web2         10.44.0.0       56927d3bf002 e6:b1:90:cd:76:da
user@docker3:~$
```
###### Hinweis
Es gibt viele verschiedene Konfigurationsoptionen, die Ihnen zur Verfügung stehen, um anzupassen, wie WeaveDNS funktioniert. Um den gesamten Führer zu sehen, schau dir die Dokumentation unter https://www.weave.works/docs/net/latest/weavedns/ an.

