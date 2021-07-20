---
title: docker-networking-weave-net-ipam
description: 
published: true
date: 2021-06-09T15:12:10.617Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:12:05.083Z
---


# Docker Networking weave net ipam

Wie wir in früheren Kapiteln mehrfach gesehen haben, ist IPAM ein wichtiger Bestandteil jeder Container-Netzwerklösung. Die Kritikalität von IPAM wird noch deutlicher, wenn Sie mit gemeinsamen Netzwerken über mehrere Docker-Hosts beginnen. Da die Anzahl der IP-Zuweisungen beginnt zu skalieren, um diese Container durch Namen zu lösen, wird auch entscheidend. Ähnlich wie Docker hat Weave ein eigenes, integriertes IPAM für ihre Container-Netzwerklösung. In diesem Kapitel zeigen wir, wie Sie Weave IPAM konfigurieren und nutzen können, um IP-Zuweisungen über das Weave-Netzwerk zu verwalten.

## Fertig werden

Es wird davon ausgegangen, dass Sie sich aus dem Labor, das wir im ersten Rezept dieses Kapitels erstellt haben, aufbauen. Es wird auch davon ausgegangen, dass die Hosts Docker und Weave installiert haben. Docker sollte in seiner Standardkonfiguration sein, und Weave sollte installiert werden, aber noch nicht gespannt. Wenn Sie das in früheren Beispielen definierte Peering entfernen müssen, geben Sie den `weave reset` Befehl auf jedem Host aus.

## Wie es geht…

Weaves Lösung für IPAM setzt auf das Weave-Netzwerk als Ganzes mit einem großen Subnetz, das dann in kleinere Stücke geschnitzt und direkt jedem Host zugeordnet wird. Der Host weist dann Container-IP-Adressen aus dem IP-Adresspool zu, den ihm zugewiesen wurde. Damit dies funktioniert, muss sich der Weave-Cluster darauf einigen, welche IP-Zuweisungen jedem Host zuzuordnen sind. Das tut dies, indem man zuerst einen Konsens innerhalb des Clusters erreicht. Wenn Sie eine allgemeine Vorstellung davon haben, wie groß Ihr Cluster sein wird, können Sie bei der Initialisierung Spekulationen zur Verfügung stellen, die Ihnen helfen, eine bessere Entscheidung zu treffen.

## Hinweis

Das Ziel dieses Rezepts ist es nicht, in die Besonderheiten bei der Optimierung des Konsensusalgorithmus zu gelangen, den Weave mit IPAM verwendet. Für spezifische Informationen hierzu siehe folgenden Link:

[Weave ipam](Https://www.weave.works/docs/net/latest/ipam/)

Um dieses Rezept willen, werden wir davon ausgehen, dass Sie nicht wissen, wie groß Ihr Cluster sein wird, und wir werden von der Prämisse arbeiten, dass es mit zwei Hosts beginnen und von dort aus expandieren wird.

Es ist wichtig zu verstehen, dass das IPAM in Weave im Leerlauf sitzt, bis Sie Ihren ersten Container bereitstellen. Zum Beispiel beginnen wir mit der Konfiguration von Weave auf dem Host-`Docker1`:

```s
user@docker1:~$ weave launch-router --ipalloc-range 172.16.16.0/24
469c81f786ac38618003e4bd08eb7303c1f8fa84d38cc134fdb352c589cbc42d
user@docker1:~$
```

Das erste, was Sie beachten sollten, ist die Ergänzung des Parameters `--ipalloc-range`. Wie wir bereits erwähnt haben, arbeitet Weave das Konzept eines großen Subnetzes. Standardmäßig ist dieses Subnetz `10.32.0.0/12`. Diese Voreinstellung kann während der Weave-Initialisierung überschrieben werden, indem das `--ipalloc-range`-Flag an Weave übergeben wird. Um diese Beispiele ein wenig leichter zu verstehen, habe ich beschlossen, das Standard-Subnetz zu etwas mehr überschaubaren zu ändern; In diesem Fall 172.16.16.0/24.

Lassen Sie uns auch den gleichen Befehl auf dem Host-`docker2` ausführen, aber geben Sie ihm die IP-Adresse des Host-`docker1`, so dass es sofort Peer:

```s
user@docker2:~$ weave launch-router --ipalloc-range \
172.16.16.0/24 10.10.10.101
9bfb1cb0295ba87fe88b7373a8ff502b1f90149741b2f43487d66898ffad775d
user@docker2:~$
```

Beachten Sie, dass ich noch einmal das gleiche Subnetz zu Weave bestanden habe. Es ist entscheidend, dass der IP-Zuweisungsbereich auf jedem Host, der Weave ausführt, identisch ist. Nur Hosts, die sich auf denselben IP-Zuweisungsbereich einigen, können ordnungsgemäß funktionieren. Lassen Sie uns nun den Status der Weave-Dienste überprüfen:

```s
user@docker2:~$ weave status
…<Additional output removed for brevity>…
Connections: 1 (1 established)
          Peers: 2 (with 2 established connections)
 TrustedSubnets: none

        Service: ipam
         Status: idle
          Range: 172.16.16.0/24
  DefaultSubnet: 172.16.16.0/24 
…<Additional output removed for brevity>…
user@docker2:~$
```

Die Ausgabe zeigt zwei Peers, die darauf hinweisen, dass unser Pearing zum `docker1 `erfolgreich war. Beachten Sie, dass der IPAM-Dienst den Status des `idle` anzeigt. Der `idle` staus bedeutet, dass Weave auf weitere Peers wartet, um sich anzuschließen, bevor es irgendwelche Entscheidungen darüber macht, welche Hosts bekommen werden, was IP-Zuweisungen. Mal sehen, was passiert, wenn wir einen Container führen:

```s
user@docker2:~$ weave run -dP --name=web2 jonlangemak/web_server_2
379402b05db83315285df7ef516e0417635b24923bba3038b53f4e58a46b4b0d
user@docker2:~$
```
Wenn wir den Weave-Status noch einmal überprüfen, sollten wir sehen, dass IPAM nun von Leerlauf zu Ready geändert hat:

```s
user@docker2:~$ weave status
…<Additional output removed for brevity>… 
    Connections: 1 (1 established)
          Peers: 2 (with 2 established connections)
 TrustedSubnets: none

        Service: ipam
         Status: ready
          Range: 172.16.16.0/24
  DefaultSubnet: 172.16.16.0/24 
…<Additional output removed for brevity>…
user@docker2:~$
```

Das Ausführen des ersten Containers, der mit dem Weave-Netzwerk verbunden ist, hat Weave gezwungen, zu einem Konsens zu kommen. An diesem Punkt hat Weave entschieden, dass die Clustergröße zwei ist und hat sich bemüht, die verfügbare IP-Adressierung zwischen den Hosts zuzuordnen. Lassen Sie uns auch einen Container auf dem Host-`docker1` ausführen und dann die IP-Adressen überprüfen, die jedem Container zugewiesen wurden:

```s
user@docker1:~$ weave run -dP --name=web1 jonlangemak/web_server_1
fbb3eac421159308f41d795638c3a4689c92a9401718fd1988083bfc12047844
user@docker1:~$ weave ps
weave:expose 12:d2:fe:7a:c1:f2
fbb3eac42115 02:a7:38:ab:73:23 172.16.16.1/24
user@docker1:~$
```

Mit dem weave ps Befehl können wir sehen, dass der Container, den wir gerade auf dem Host `docker1` hervorgebracht haben, eine IP Adresse von `172.16.16.1/24` erhalten hat. Wenn wir die IP-Adresse des Containers `web2` auf dem Host-Docker2 überprüfen, sehen wir, dass es eine IP-Adresse von `172.16.16.128/24`:

```s
user@docker2:~$ weave ps
weave:expose e6:b1:90:cd:76:da
dde411fe4c7b c6:42:74:89:71:da 172.16.16.128/24
user@docker2:~$
```

Das macht Sinn. Weave wusste, dass es zwei Mitglieder im Netzwerk hatte, so dass es die Zuordnung direkt in der Hälfte aufteilt, was im Wesentlichen jedem Host seine eigene `/25` Netzwerkzuteilung gibt. Docker1 begann mit der Zuteilung aus der ersten Hälfte des `/24` und `docker2` begann zu Beginn der zweiten Hälfte.

Trotz der vollständigen Zuteilung des gesamten Raumes bedeutet das nicht, dass wir jetzt aus dem IP-Raum sind. Diese anfänglichen Zuweisungen sind eher Vorbehalte und können aufgrund der Größe des Webnetzes geändert werden. Zum Beispiel können wir nun den Host-`docker3` dem Weave-Netzwerk hinzufügen und eine weitere Instanz des `Web1`-Containers starten:

```s
user@docker3:~$ weave launch-router --ipalloc-range \
172.16.16.0/24 10.10.10.101
8e8739f48854d87ba14b9dcf220a3c33df1149ce1d868819df31b0fe5fec2163
user@docker3:~$ weave run -dP --name=web1 jonlangemak/web_server_1
0c2193f2d7569943171764155e0e93272f5715c257adba75ed544283a2794d3e
user@docker3:~$ weave ps
weave:expose ae:af:a6:36:18:37
0c2193f2d756 76:8d:4c:ee:08:db 172.16.16.224/24
user@docker3:~$
```

Weil das Netzwerk jetzt mehr Mitglieder hat, spaltet Weave nur die anfängliche Zuordnung in kleinere Stücke. Basierend auf den IP-Adressen, die den Containern auf jedem Host zugewiesen werden, können wir sehen, dass Weave versucht, die Zuweisungen in gültigen Subnetzen zu halten. Das folgende Bild zeigt, was mit den IP-Zuweisungen passieren würde, da die dritten und vierten Hosts dem Weave-Netzwerk beigetreten sind:

![waeve-net02](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_05.jpg)

Es ist wichtig zu beachten, dass, während die Zuweisungen, die jedem Server gegeben werden, flexibel sind, sie alle die gleiche Maske wie die ursprüngliche Zuweisung verwenden, wenn sie die IP-Adresse dem Container zuweisen. Dies stellt sicher, dass die Container alle davon ausgehen, dass sie sich im selben Netzwerk befinden und eine direkte Konnektivität zueinander haben, wodurch die Notwendigkeit besteht, Routen zu haben, die auf andere Hosts zeigen.

Um zu beweisen, dass die anfängliche IP-Zuweisung über alle Hosts gleich sein muss, können wir versuchen, den letzten Host, `Docker4`, mit einem anderen Subnetz zu verbinden:

```s
user@docker4:~$ weave launch-router --ipalloc-range 172.64.65.0/24 10.10.10.101
9716c02c66459872e60447a6a3b6da7fd622bd516873146a874214057fe11035
user@docker4:~$ weave status
…<Additional output removed for brevity>…
        Service: router
       Protocol: weave 1..2
           Name: 42:ec:92:86:1a:31(docker4)
     Encryption: disabled
  PeerDiscovery: enabled
        Targets: 1
    Connections: 1 (1 failed)
…<Additional output removed for brevity>…
user@docker4:~$
```

Wenn wir den Container des Weave-Routers auf Protokolle überprüfen, werden wir sehen, dass es nicht möglich ist, sich dem vorhandenen Weave-Netzwerk anzuschließen, weil die falsche IP-Zuweisung definiert ist:

```s
user@docker4:~$ docker logs weave
…<Additional output removed for brevity>…
INFO: 2016/10/11 02:16:09.821503 ->[192.168.50.101:6783|ae:af:a6:36:18:37(docker3)]: connection shutting down due to error: Incompatible IP allocation ranges (received: 172.16.16.0/24, ours: 172.64.65.0/24)
…<Additional output removed for brevity>…
```

Der einzige Weg, sich dem bestehenden Weave-Netzwerk anzuschließen, wäre die Verwendung der gleichen IP-Zuweisung wie alle vorhandenen Knoten.

Schließlich ist es wichtig zu rufen, dass es keine Voraussetzung ist, Weave IPAM auf diese Weise zu verwenden. Sie können die IP-Adressierung manuell zuordnen, indem Sie eine IP-Adresse während eines `weave run` wie folgt angeben:

```s
user@docker1:~$ weave run 1.1.1.1/24 -dP --name=wrongip \
jonlangemak/web_server_1
259004af91e3b0367bede723c9eb9d3fbdc0c4ad726efe7aea812b79eb408777
user@docker1:~$
```

Wenn Sie einzelne IP-Adressen angeben, können Sie eine beliebige IP-Adresse auswählen. Wie Sie in einem späteren Rezept sehen werden, können Sie auch ein Subnetz für die Zuordnung angeben und haben Weave verfolgen diese Subnetzzuweisung in IPAM. Bei der Zuweisung einer IP-Adresse aus einem Subnetz muss das Subnetz Teil der anfänglichen Weave-Zuordnung sein.

Wenn Sie manuell einige IP-Adressen zuordnen möchten, kann es sinnvoll sein, einen zusätzlichen Weave-Parameter während der anfänglichen Weave-Konfiguration zu konfigurieren, um den Umfang der dynamischen Zuweisungen zu begrenzen. Sie können den Parameter `--ipalloc-default-subnet` an Weave während des Ladens übergeben, um den Umfang zu begrenzen, dessen IP-Adressen dynamisch den Hosts zugewiesen sind. Zum Beispiel könnten Sie dies übergeben:

```s
weave launch-router --ipalloc-range 172.16.16.0/24 \
--ipalloc-default-subnet 172.16.16.0/25
```

Dies würde das Weave-Subnetz zu `172.16.16.0/25` konfigurieren, wobei der Rest des größeren Netzwerks für die manuelle Zuweisung verfügbar ist. Wir werden in einem späteren Rezept sehen, dass diese Art von Konfiguration eine große Rolle spielt, wie Weave die Netzwerkisolation über das Weave-Netzwerk verarbeitet.
