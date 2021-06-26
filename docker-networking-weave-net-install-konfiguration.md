---
title: docker-networking-weave-net-install-konfiguration
description: 
published: true
date: 2021-06-09T15:12:01.802Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:11:55.155Z
---

# Docker networking weave net Installation und Konfiguration

![docker-weave-net-01](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_01.jpg)

Du brauchst ein paar Gastgeber, vorzugsweise mit einigen von ihnen auf verschiedenen Subnetzen. Es wird davon ausgegangen, dass die in diesem Labor verwendeten Docker-Hosts in ihrer Standardkonfiguration sind. In einigen Fällen können die Änderungen, die wir machen, verlangen, dass Sie einen Root-Level-Zugriff auf das System haben.

## Wie es geht…

Weave wird über das Weave CLI Tool installiert und verwaltet. Einmal heruntergeladen, verwaltet es nicht nur Weave-bezogene Konfiguration, sondern auch die Bereitstellung von Weave-Services. Auf jedem Host, den du konfigurieren möchtest, kannst du einfach die folgenden drei Befehle ausführen:

* Laden Sie die Weave-Binärdatei in Ihr lokales System herunter:

```s
user@docker1:~$ sudo curl -L git.io/weave -o \
/usr/local/bin/weave
```

* Machen Sie die Datei ausführbar:
`user@docker1:~$ sudo chmod +x /usr/local/bin/weave`

* Wave ausführen :
`user@docker1:~$ weave launch`

Wenn alle diese Befehle erfolgreich abgeschlossen sind, ist Ihr Docker-Host nun bereit, Weave für Docker-Netzwerke zu verwenden. Um zu überprüfen, können Sie den Weave-Status mit dem Weave-Status-Befehl überprüfen:


``` 
user@docker1:~$ weave status
        Version: 1.7.1 (up to date; next check at 2016/10/11 01:26:42)

        Service: router
       Protocol: weave 1..2
           Name: 12:d2:fe:7a:c1:f2(docker1)
     Encryption: disabled
  PeerDiscovery: enabled
        Targets: 0
    Connections: 0
          Peers: 1
 TrustedSubnets: none

        Service: ipam
         Status: idle
          Range: 10.32.0.0/12
  DefaultSubnet: 10.32.0.0/12

        Service: dns
         Domain: weave.local.
       Upstream: 10.20.30.13
            TTL: 1
        Entries: 0

        Service: proxy
        Address: unix:///var/run/weave/weave.sock

        Service: plugin
     DriverName: weave
user@docker1:~$ 
```

Diese Ausgabe liefert Ihnen Informationen über alle fünf Netzwerke von Weave. Das sind `Router`, `ipam`, `dns`, `Proxy `und `Plugin`. An dieser Stelle können Sie sich fragen, wo alle diese Dienste laufen.Um es mit dem Docker-Thema zu halten, laufen sie alle in Containern auf dem Host:

Wie Sie sehen können, gibt es drei Weave-bezogene Container, die auf dem Host laufen. Das Ausführen des `weave launch` befehls hat alle drei Container hervorgebracht. Jeder Container bietet einzigartige Dienste, die Weave für Netzwerkcontainer verwendet. Der `weaveproxy` Container dient als Shim-Layer, so dass Weave direkt aus dem Docker CLI genutzt werden kann. Der `weaveplugin` Container implementiert einen benutzerdefinierten Netzwerk-Treiber für Docker. Der "weave" Container wird üblicherweise als Weave Router bezeichnet und bietet allen anderen Services an, die mit Weave Networking zusammenhängen.

Jeder dieser Container kann unabhängig konfiguriert und betrieben werden. Laufen Weave mit dem `weave launch` Befehl setzt voraus, dass Sie alle drei Container verwenden und sie mit einem gesunden Satz von Standardeinstellungen einsetzen möchten. Wenn Sie jedoch die Einstellungen für einen bestimmten Container ändern möchten, müssen Sie die Container selbstständig starten. Dies geschieht auf diese Weise:
```
weave launch-router
weave launch-proxy
weave launch-plugin
```

Wenn Sie zu irgendeinem Zeitpunkt die Weave-Konfiguration auf einem bestimmten Host aufräumen möchten, können Sie den `weave reset` Befehl ausgeben, der alle Weave-bezogenen Servicecontainer aufräumen wird. Um unser Beispiel zu beginnen, verwenden wir nur den Weave Router Container. Lassen Sie uns die Weave-Konfiguration löschen und starten Sie dann gerade diesen Container auf unserem Host `docker1`:
```
user@docker1:~$ weave reset
user@docker1:~$ weave launch-router
e5af31a8416cef117832af1ec22424293824ad8733bb7a61d0c210fb38c4ba1e
user@docker1:~$
```
Der Weave Router (Weave Container) ist der einzige Container, den wir für die Mehrheit der Netzwerkfunktionalität benötigen. Schauen wir uns die Konfigurationsoptionen an, die standardmäßig an den Weave Router übergeben werden, indem wir die Webbehälterkonfiguration inspizieren:
```
user@docker1:~$ docker inspect weave
…<Additional output removed for brevity>…
        "Args": [
            "--port",
            "6783",
            "--name",
            "12:d2:fe:7a:c1:f2",
            "--nickname",
            "docker1",
            "--datapath",
            "datapath",
            "--ipalloc-range",
            "10.32.0.0/12",
            "--dns-effective-listen-address",
            "172.17.0.1",
            "--dns-listen-address",
            "172.17.0.1:53",
            "--http-addr",
            "127.0.0.1:6784",
            "--resolv-conf",
            "/var/run/weave/etc/resolv.conf" 
…<Additional output removed for brevity>… 
user@docker1:~$
```
Es gibt einige Punkte, die in der vorherigen Ausgabe darauf hinweisen. Der IP-Zuweisungsbereich ist als `10.32.0.0/12` angegeben. Das ist deutlich anders als die `172.17.0.0/16`, mit denen wir standardmäßig auf der `docker0` brücke verhandelt haben. Außerdem ist eine IP-Adresse definiert, die als DNS-Adresse verwendet wird. Erinnern Sie sich, dass Weave auch WeaveDNS bereitstellt, mit dem die Namen anderer Container auf dem Weave-Netzwerk namentlich aufgelöst werden können. Beachten Sie, dass diese IP-Adresse die der `docker0`-Bridge-Schnittstelle auf dem Host ist.

Lassen Sie uns jetzt einen anderen unserer Gastgeber als Teil des Weave-Netzwerks konfigurieren:
```
user@docker2:~$ sudo curl -L git.io/weave -o /usr/local/bin/weave
user@docker2:~$ sudo chmod +x /usr/local/bin/weave
user@docker2:~$ weave launch-router 10.10.10.101
48e5035629b5124c8d3bedf09fca946b333bb54aff56704ceecef009b53dd449
user@docker2:~$
```
Beachten Sie, dass wir Weave in der gleichen Weise wie zuvor installiert haben, aber als wir den Router-Container gestartet haben, haben wir dies getan, indem wir die IP-Adresse des ersten Docker-Hosts angaben. In Weave, so sehen wir mehrere Hosts zusammen. Jeder Host, den Sie mit dem Weave-Netzwerk verbinden möchten, muss nur die IP-Adresse eines vorhandenen Knotens im Weave-Netzwerk angeben. Wenn wir den Status von Weave auf diesem neu verbundenen Node überprüfen, sollten wir sehen, dass es als verbunden erscheint:
```
user@docker2:~$ weave status
        Version: 1.7.1 (up to date; next check at 2016/10/11 03:36:22)
        Service: router
       Protocol: weave 1..2
           Name: e6:b1:90:cd:76:da(docker2)
     Encryption: disabled
  PeerDiscovery: enabled
        Targets: 1
    Connections: 1 (1 established)
          Peers: 2 (with 2 established connections)
 TrustedSubnets: none
…<Additional output removed for brevity>…
user@docker2:~$
```
Wir können fortfahren, die beiden anderen verbleibenden Knoten auf die gleiche Weise zu verbinden, nachdem Weave installiert ist:
```
user@docker3:~$ weave launch-router 10.10.10.102
user@docker4:~$ weave launch-router 192.168.50.101
´´´
In jedem Fall geben wir den zuvor verbundenen Weave-Node als Peer des Nodes an, den wir zu verbinden versuchen. In unserem Fall sieht unser Join-Muster aus wie das folgendes Bild:
![multilayer-sw-01](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_03.jpg)

Allerdings hätten wir jeden Knoten jedem anderen bestehenden Knoten beitreten und das gleiche Ergebnis erzielen können. Das heißt, das Verbinden von Knoten `docker2`, `docker3` und `docker4` zu `docker1` hätte den gleichen Endzustand ergeben. Dies liegt daran, dass Weave nur mit einem bestehenden Knoten sprechen muss, um Informationen über den aktuellen Stand des Weave-Netzwerks zu erhalten. Da alle vorhandenen Mitglieder diese Informationen haben, spielt es keine Rolle, mit wem sie reden, um einem neuen Knoten zum Weave-Netzwerk beizutreten. Wenn wir den Status eines der Weave-Knoten jetzt überprüfen, sollten wir sehen, dass wir insgesamt vier Peers haben:
```
user@docker4:~$ weave status
        Version: 1.7.1 (up to date; next check at 2016/10/11 03:25:22)

        Service: router
       Protocol: weave 1..2
           Name: 42:ec:92:86:1a:31(docker4)
     Encryption: disabled
  PeerDiscovery: enabled
        Targets: 1
    Connections: 3 (3 established)
          Peers: 4 (with 12 established connections)
 TrustedSubnets: none 
…<Additional output removed for brevity>… 
user@docker4:~$
```

Wir können sehen, dass dieser Knoten drei Verbindungen hat, einen zu jedem der anderen verbundenen Knoten. Das gibt uns insgesamt vier Peers mit zwölf Verbindungen, drei pro Weave-Knoten. Also trotz nur Konfigurieren Peering zwischen drei Knoten, wir am Ende mit einem vollen Mesh für Container-Konnektivität zwischen allen Hosts:

![m-sw-02](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_04.jpg)

Jetzt ist die Konfiguration von Weave komplett, und wir haben ein volles Mesh-Netzwerk zwischen all unseren Weave-fähigen Docker-Hosts. Sie können die Verbindungen überprüfen, die jeder Host mit den anderen Peers mit dem Befehl `weave status connections` hat:
```
user@docker1:~$ weave status connections
-> 192.168.50.102:6783   established fastdp 42:ec:92:86:1a:31(docker4)
<- 10.10.10.102:45632    established fastdp e6:b1:90:cd:76:da(docker2)
<- 192.168.50.101:38411  established fastdp ae:af:a6:36:18:37(docker3)
user@docker1:~$ 
```
Sie werden feststellen, dass diese Konfiguration nicht die Konfiguration eines eigenständigen Schlüsselwertspeichers erfordert.

Es ist auch anzumerken, dass Weave Peers manuell mit dem Weave CLI `Connect` verwaltet und Command `forget` kann. Wenn Sie ein vorhandenes Mitglied des Weave-Netzwerks nicht angeben, wenn Sie Weave instanziieren, können Sie die Weave-Verbindung verwenden, um eine manuelle Verbindung zu einem vorhandenen Mitglied herzustellen. Auch wenn du ein Mitglied aus dem Weave-Netzwerk entfernst und es nicht erwarten wirst zurückzukehren, kannst du dem Netzwerk mitteilen, dass er den Peer mit dem `forget`-Befehl ganz vergessen darf.

