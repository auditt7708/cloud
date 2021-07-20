---
title: docker-networking-weave-net-plugins
description: 
published: true
date: 2021-06-09T15:12:17.922Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:12:12.516Z
---

# Docker Networking weave net Plugins

Eines der Dinge, die Weave auseinander setzen ist, dass es in verschiedenen verschiedenen Arten betrieben werden kann. Wie wir in den vorherigen Rezepten dieses Kapitels gesehen haben, hat Weave eine eigene CLI, die wir verwenden können, um Container direkt auf das Weave-Netzwerk zu bringen. Während dies ist sicherlich eine enge Integration, die gut funktioniert, erfordert es, dass Sie die Weave CLI oder Weave API Proxy nutzen, um mit Docker zu integrieren. Zusätzlich zu diesen Optionen hat Weave auch ein natives Docker-Netzwerk-Plugin geschrieben. Dieses Plugin ermöglicht es Ihnen, mit Weave direkt von Docker zu arbeiten. Das heißt, sobald das Plugin registriert ist, müssen Sie nicht mehr die Weave CLI verwenden, um Container in Weave zu versorgen. In diesem Rezept, werden wir überprüfen, wie zu installieren und mit dem Weave Netzwerk-Plugin zu arbeiten.

## Fertig werden

Es wird davon ausgegangen, dass Sie das Labor, das wir im ersten Rezept dieses Kapitels erstellt haben, ausbauen. Es wird auch davon ausgegangen, dass die Hosts Docker und Weave installiert haben. Docker sollte in seiner Standardkonfiguration sein, Weave sollte installiert werden, wobei alle vier Hosts erfolgreich zusammengespielt wurden, wie wir es im ersten Rezept dieses Kapitels getan haben.

## Wie es geht…

Wie die anderen Komponenten von Weave, die Nutzung der Docker-Plugin könnte nicht einfacher sein. Alles, was Sie tun müssen, ist, Weave zu sagen, um es zu starten. Zum Beispiel, wenn ich beschloss, das Docker-Plugin auf dem Host-Docker1 zu verwenden, könnte ich das Plugin so starten:

```s
user@docker1:~$ weave launch-plugin
3ef9ee01cc26173f2208b667fddc216e655795fd0438ef4af63dfa11d27e2546
user@docker1:~$
```

Ähnlich wie die anderen Dienste kommt das Plugin in Form eines Containers. Nachdem du den vorherigen Befehl ausgeführt hast, solltest du das Plugin als Container namens `weaveplugin` sehen:
![docker ausgabe](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_07.jpg)

Sobald Sie laufen, sollten Sie auch sehen, dass es als Netzwerk-Plugin registriert:

```s
user@docker1:~$ docker info
…<Additional output removed for brevity>…
Plugins:
 Volume: local
 Network: host weavemesh overlay bridge null
…<Additional output removed for brevity>…
user@docker1:~$
```

Wir können es auch als definierten Netzwerktyp mit dem Unterbefehl des `docker network` sehen:

```s
user@docker1:~$ docker network ls
NETWORK ID        NAME              DRIVER            SCOPE
79105142fbf0      bridge            bridge            local
bb090c21339c      host              host              local
9ae306e2af0a      none              null              local
20864e3185f5      weave             weavemesh         local
user@docker1:~$
```

An diesem Punkt können Anschlussbehälter zum Weave-Netzwerk direkt über Docker erfolgen. Alles, was Sie tun müssen, ist, den Netzwerknamen des `weave` anzugeben, wenn Sie einen Container starten. Zum Beispiel können wir laufen:

```s
user@docker1:~$ docker run -dP --name=web1 --net=weave \
jonlangemak/web_server_1
4d84cb472379757ae4dac5bf6659ec66c9ae6df200811d56f65ffc957b10f748
user@docker1:~$
```

Wenn wir uns die Container-Schnittstellen anschauen, sehen wir die beiden Schnittstellen, die wir mit Weave verbundenen Containern gewohnt sind:

```s
user@docker1:~$ docker exec web1 ip addr
…<loopback interface removed for brevity>…
83: ethwe0@if84: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP
    link/ether 9e:b2:99:c4:ac:c4 brd ff:ff:ff:ff:ff:ff
    inet 10.32.0.1/12 scope global ethwe0
       valid_lft forever preferred_lft forever
    inet6 fe80::9cb2:99ff:fec4:acc4/64 scope link
       valid_lft forever preferred_lft forever
86: eth1@if87: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:12:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.2/16 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe12:2/64 scope link
       valid_lft forever preferred_lft forever
user@docker1:~$
```

Allerdings können Sie beachten, dass die IP-Adresse für `eth1 `nicht auf der `docker_gwbridge` ist, sondern auf docker_gwbridge, die wir in früheren Kapiteln gesehen haben, als wir den Docker-Overlay-Treiber zeigten. Der Vorteil der Verwendung der Gateway-Brücke anstatt der `Docker0`-Brücke ist, dass die Gateway-Brücke ICC deaktiviert standardmäßig. Dies verhindert, dass Weave verbundene Container, die von versehentlich über das `docker0 `Brücken gesprochen werden sollen, wenn man den ICC-Modus aktiviert hat.

Ein Nachteil zum Plugin-Ansatz ist, dass Weave nicht in der Mitte ist, um Docker über die DNS-bezogenen Konfigurationen zu erzählen, was bedeutet, dass die Container ihre Namen nicht registrieren. Selbst wenn sie waren, erhalten sie auch nicht die richtigen Namensauflösungseinstellungen, die erforderlich sind, um WeaveDNS zu lösen. Es gibt zwei Möglichkeiten, die richtigen Einstellungen für den Container festzulegen. In beiden Fällen müssen wir die Parameter bei der Containerlaufzeit manuell angeben. Die erste Methode beinhaltet die manuelle Angabe aller erforderlichen Parameter selbst. Manuell geht es wie folgt:

```s
user@docker1:~$ docker run -dP --name=web1 \
--hostname=web1.weave.local --net=weave --dns=172.17.0.1 \
--dns-search=weave.local jonlangemak/web_server_1
6a907ee64c129d36e112d0199eb2184663f5cf90522ff151aa10c2a1e6320e16
user@docker1:~$
```

Um sich bei DNS anzumelden, benötigen Sie die vier fettgedruckten Einstellungen im vorherigen Code:

* `--hostname=web1.weave.local` : Wenn Sie den Hostnamen des Containers nicht auf einen Namen innerhalb von `weave.local` setzen, wird der DNS-Server den Namen nicht registrieren.

* `--net=weave` : Es muss auf dem Weave-Netzwerk sein, um irgendwelche davon zu arbeiten.

* `--dns=172.17.0.1` : Wir müssen es sagen, dass wir den Weave-DNS-Server verwenden, der auf der Docker0-Bridge-IP-Adresse hört. Allerdings haben Sie vielleicht bemerkt, dass dieser Container nicht wirklich eine IP-Adresse auf der `Docker0`-Brücke hat. Vielmehr, da wir mit dem `docker-gwbridge` verbunden sind, haben wir eine IP-Adresse im `172.18.0.0/16` Netzwerk. In beiden Fällen, da beide Brücken IP-Schnittstellen haben, kann der Container durch die `docker_gwbridge` fahren, um an die IP-Schnittstelle auf der `docker0`-Brücke zu gelangen.

* `--dns-search=weave.local``: Damit kann der Container Namen auflösen, ohne den **Fully Qualified Domain Name (FQDN)** anzugeben.

Sobald ein Container mit diesen Einstellungen gestartet wird, sollten Sie Datensätze sehen, die sich in WeaveDNS registrieren:

```s
user@docker1:~$ weave status dns
web1         10.32.0.1       7b02c0262786 12:d2:fe:7a:c1:f2
user@docker1:~$
```

Die zweite Lösung ist noch manuell, aber beinhaltet das Ziehen der DNS-Informationen von Weave selbst. Anstatt den DNS-Server und die Suchdomäne anzugeben, kannst du ihn direkt aus Weave einspritzen. Weave hat einen Befehl namens `dns-args`, der die relevanten Informationen für Sie zurücksendet. Also, anstatt es zu spezifizieren, können wir diesen Befehl einfach als Teil der Containerparameter wie folgt einspritzen:

```s
user@docker2:~$ docker run --hostname=web2.weave.local \
--net=weave $(weave dns-args) --name=web2 -dP \
jonlangemak/web_server_2
597ffde17581b7203204594dca84c9461c83cb7a9076ed3d1ed3fcb598c2b77d
user@docker2:~$
```

Zugegeben, dies verhindert nicht die Notwendigkeit, das Netzwerk oder den FQDN des Containers anzugeben, aber es schneidet einige der Eingabe ab. An dieser Stelle sollten Sie alle in WeaveDNS definierten Datensätze sehen und in der Lage sein, auf Dienste über das Webnetzwerk zuzugreifen:

```s
user@docker1:~$ weave status dns
web1         10.32.0.1       7b02c0262786 12:d2:fe:7a:c1:f2
web2         10.32.0.2       b154e3671feb 12:d2:fe:7a:c1:f2
user@docker1:~$
user@docker2:~$ docker exec -it web2 ping web1 -c 2
PING web1 (10.32.0.1): 48 data bytes
56 bytes from 10.32.0.1: icmp_seq=0 ttl=64 time=0.139 ms
56 bytes from 10.32.0.1: icmp_seq=1 ttl=64 time=0.130 ms
--- web1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.130/0.135/0.139/0.000 ms
user@docker1:~$
```

Sie können beachten, dass die DNS-Konfiguration dieses Containers nicht genau so ist, wie Sie es erwartet haben. Zum Beispiel zeigt die Datei `resolv.conf` nicht den DNS-Server an, den wir bei der Container-Laufzeit angegeben haben:

```s
user@docker1:~$ docker exec web1 more /etc/resolv.conf
::::::::::::::
/etc/resolv.conf
::::::::::::::
search weave.local
nameserver 127.0.0.11
options ndots:0
user@docker1:~$
```

Wenn Sie jedoch die Konfiguration des Containers überprüfen, sehen Sie, dass der korrekte DNS-Server richtig definiert ist:

```s
User @ docker1: ~ $ docker überprüfen web1
... <Zusätzliche Ausgabe zur Kürze entfernt ...
             "Dns": [
                 "172.17.0.1"
             ],
... <Zusätzliche Ausgabe zur Kürze entfernt ...
User @ docker1: ~ $
```

Erinnern Sie sich, dass benutzerdefinierte Netzwerke die Verwendung von Dockers eingebettetem DNS-System erfordern. Die IP-Adresse, die wir in den Containern `resolv.conf`-Datei gesehen haben, verweist auf den eingebetteten DNS-Server von Docker. Im Gegenzug, wenn wir einen DNS-Server für einen Container angeben, fügt der eingebettete DNS-Server diesen Server als Forwarder in eingebetteten DNS hinzu. Dies bedeutet, dass, obwohl die Anforderung immer noch den eingebetteten DNS-Server schlägt, die Anforderung an WeaveDNS zur Auflösung weitergeleitet wird.

## Hinweis

Mit dem Weave Plugin können Sie auch weitere benutzerdefinierte Netzwerke mit dem Weave Treiber erstellen. Allerdings, da Docker sieht diese als global in Umfang, sie benötigen die Verwendung eines externen Schlüsselspeichers. Wenn Sie daran interessiert sind, Weave auf diese Weise zu verwenden, wenden Sie sich bitte an die Weave-Dokumentation unter https://www.weave.works/docs/net/latest/plugin/.
