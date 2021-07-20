---
title: docker-networking-weave-net-sicherheit
description: 
published: true
date: 2021-06-09T15:12:26.252Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:12:20.901Z
---

# Sicheres Netzwerk mit weave net

Weave bietet ein paar Features, die unter den Schirm der Sicherheit fallen. Da Weave eine überlagernde Netzwerklösung ist, bietet sie die Möglichkeit, den Overlay-Verkehr zu verschlüsseln, während er das physische oder das Unterlagennetzwerk durchquert. Dies kann besonders nützlich sein, wenn Ihre Container ein öffentliches Netzwerk durchqueren müssen. Darüber hinaus erlaubt Weave Ihnen, Container in bestimmten Netzwerksegmenten zu isolieren. Weave setzt auf die Verwendung von verschiedenen Subnetzen für jedes isolierte Segment, um dies zu erreichen. In diesem Rezept gehen wir durch, wie man sowohl Overlay-Verschlüsselung konfiguriert als auch wie man Isolation für verschiedene Container über das Weave-Netzwerk bereitstellt.

## Fertig werden

Es wird davon ausgegangen, dass Sie das Labor, das wir im ersten Rezept dieses Kapitels erstellt haben, ausbauen. Es wird auch davon ausgegangen, dass die Hosts Docker und Weave installiert haben. Docker sollte in seiner Standardkonfiguration sein, und Weave sollte installiert werden, aber noch nicht gespannt. Wenn Sie das in früheren Beispielen definierte Peering entfernen müssen, geben Sie den Weave Reset Befehl auf jedem Host aus.

## Wie es geht…

Konfigurieren von Weave, um das Overlay-Netzwerk zu verschlüsseln ist ziemlich einfach zu erreichen; Allerdings muss es bei der anfänglichen Konfiguration von Weave geschehen. Mit der gleichen Labortopologie aus den vorherigen Rezepten führen wir die folgenden Befehle aus, um das Webnetz zu erstellen:

* Auf dem host `docker1`:

```s
weave launch-router --password notverysecurepwd \
--trusted-subnets 192.168.50.0/24 --ipalloc-range \
172.16.16.0/24 --ipalloc-default-subnet 172.16.16.128/25
```

* Auf den Hosts `docker2` , `docker3` , und `docker4` :

```s
weave launch-router --password notverysecurepwd \
--trusted-subnets 192.168.50.0/24 --ipalloc-range \
172.16.16.0/24 --ipalloc-default-subnet \
172.16.16.128/25 10.10.10.101
```

Sie werden feststellen, dass der Befehl, den wir auf den Hosts laufen, weitgehend der gleiche ist, mit Ausnahme der letzten drei Hosts, die `docker1` als Peer angeben, um das Weave-Netzwerk zu bauen. In beiden Fällen gibt es einige zusätzliche Parameter, die wir während der Weave-Initialisierung an den Router übergeben haben:

* `--password`: Dies ermöglicht die Verschlüsselung für die Kommunikation zwischen Weave-Knoten. Sie sollten, anders als in meinem Beispiel, ein sehr sicheres Passwort wählen. Dies muss bei jedem Knoten, der webt, gleich sein.

* `--trusted-subnets`: Dies ermöglicht es Ihnen, Subnetze von Hosts als vertrauenswürdig zu definieren, was bedeutet, dass sie nicht benötigen, dass ihre Kommunikation verschlüsselt wird. Wenn Weave die Verschlüsselung macht, fällt es auf einen langsameren Datenpfad zurück als das, was normalerweise verwendet wird. Da die Verwendung des `--password`-Parameters die Verschlüsselung von Ende zu Ende aktiviert, könnte es sinnvoll sein, einige Subnetze zu definieren, da sie keine Verschlüsselung benötigen

* `--ipalloc-range`: Hier definieren wir das größere Webnetz als `172.16.16.0/24`. Wir haben diesen Befehl in früheren Rezepten verwendet:

* `--ipalloc-default-subnet``: Dies weist Weave an, standardmäßig Container-IP-Adressen aus einem kleineren Subnetz der größeren Weave-Zuweisung zuzuordnen. In diesem Fall ist das`172.16.16.128/25`.

Nun lassen wir die folgenden Container auf jedem Host laufen:

* `docker1`:
`weave run -dP --name=web1tenant1 jonlangemak/web_server_1`

* `docker2`:
`weave run -dP --name=web2tenant1 jonlangemak/web_server_2`

* `docker3`:

```s
weave run net:172.16.16.0/25 -dP --name=web1tenant2 \
jonlangemak/web_server_1
```

* `docker4`:

```s
weave run net:172.16.16.0/25 -dP --name=web2tenant2 \
jonlangemak/web_server_2
```

Sie werden feststellen, dass auf dem Host-`Docker3` und `Docker4`, fügte ich das Netz: 172.16.16.0/25 Parameter. Rückruf, als wir das Weave-Netzwerk gestartet haben, haben wir Weave angewiesen, standardmäßig IP-Adressen aus `172.16.16.128/25` zuzuweisen. Wir können dies bei der Container-Laufzeit überschreiben und ein neues Subnetz für Weave verwenden, solange es innerhalb des größeren Weave-Netzwerks ist. In diesem Fall erhalten die Container auf `docker1` und `docker2` eine IP-Adresse innerhalb von `172.16.16.128/25`, weil das der Standard ist. Die Container auf `docker3` und `docker4` erhalten eine IP-Adresse innerhalb von `172.16.16.0/25`, da wir den Standardwert überschreiben. Wir können dies bestätigen, sobald Sie alle Container begonnen haben:

```s
user@docker4:~$ weave status dns
web1tenant1  172.16.16.129   26c58ef399c3 12:d2:fe:7a:c1:f2
web1tenant2  172.16.16.64    4c569073d663 ae:af:a6:36:18:37
web2tenant1  172.16.16.224   211c2e0b388e e6:b1:90:cd:76:da
web2tenant2  172.16.16.32    191207a9fb61 42:ec:92:86:1a:31
user@docker4:~$
```

Wie ich bereits erwähnt habe, ist die Verwendung von verschiedenen Subnetzen, wie Weave für die Container-Segmentierung sorgt. In diesem Fall würde die Topologie so aussehen:

![multi-sw-domains](https://www.packtpub.com/graphics/9781786461148/graphics/B05453_07_06.jpg)

Die gepunkteten Linien symbolisieren die Isolation, die Weave für uns im Overlay-Netzwerk bereitstellt. Da die `tenant1` Container leben, ist ein separates Subnetz aus dem `tenant2` Container, sie haben keine Konnektivität. Auf diese Weise verwendet Weave grundlegende Vernetzung, um die Containerisolation zu ermöglichen. Wir können beweisen, dass dies mit einigen Tests funktioniert:

```s
user@docker4:~$ docker exec -it web2tenant2 curl http://web1tenant2
<body>
  <html>
    <h1><span style="color:#FF0000;font-size:72px;">Web Server #1 - Running on port 80</span>
    </h1>
</body>
  </html>
user@docker4:~$ docker exec -it web2tenant2 curl http://web1tenant1
user@docker4:~$ docker exec -it web2tenant2 curl http://web2tenant1
user@docker4:~$
user@docker4:~$ docker exec -it web2tenant2 ping web1tenant1 -c 1
PING web1tenant1.weave.local (172.16.16.129): 48 data bytes
--- web1tenant1.weave.local ping statistics ---
1 packets transmitted, 0 packets received, 100% packet loss
user@docker4:~$
```

Sie werden feststellen, dass, wenn der `web2tenant2` Container versucht, auf einen Service innerhalb seines eigenen Mieters (Subnetz) zuzugreifen, es wie erwartet funktioniert. Versuche, auf einen Dienst in `tenant1` zuzugreifen, erhalten keine Antwort. Da jedoch DNS über das Weave-Netzwerk freigegeben wird, kann der Container die IP-Adresse der Container in `tenant1` noch auflösen.

Dies veranschaulicht auch ein Beispiel für die Verschlüsselung und wie können wir bestimmte Hosts als vertrauenswürdig spezifizieren. Unabhängig davon, welches Subnetz die Container leben, webt Weave immer noch Konnektivität zwischen allen Hosts. Da wir die Verschlüsselung während der Weave-Initialisierung aktiviert haben, sollten alle diese Verbindungen nun verschlüsselt werden. Wir haben aber auch ein vertrauenswürdiges Netzwerk angegeben. Das vertrauenswürdige Netzwerk definiert Knoten, die keine Verschlüsselung zwischen sich erfordern. In unserem Fall haben wir 192.168.50.0/24 als vertrauenswürdig angegeben. Da es zwei Knoten gibt, die diese IP-Adressen haben, `docker3` und `docker4`, sollten wir sehen, dass die Konnektivität zwischen ihnen unverschlüsselt ist. Wir können das mit dem  weave status befehl auf den Hosts bestätigen. Wir sollten folgende Antwort erhalten:

* `docker1` Ausgabe

```s
<- 10.10.10.102:45888    established encrypted   sleeve
<- 192.168.50.101:57880  established encrypted   sleeve
<- 192.168.50.102:45357  established encrypted   sleeve
```

* `docker2` Ausgabe
```
<- 192.168.50.101:35207  established encrypted   sleeve
<- 192.168.50.102:34640  established encrypted   sleeve
-> 10.10.10.101:6783     established encrypted   sleeve
```

* `docker3` Ausgabe

```s
-> 10.10.10.101:6783     established encrypted   sleeve
-> 192.168.50.102:6783   established unencrypted fastdp
-> 10.10.10.102:6783     established encrypted   sleeve
```

* `docker4` Ausgabe

```s
-> 10.10.10.102:6783     established encrypted   sleeve
<- 192.168.50.101:36315  established unencrypted fastdp
-> 10.10.10.101:6783     established encrypted   sleeve
```

Sie können sehen, dass alle Verbindungen mit Ausnahme der Verbindungen zwischen dem Host-`Docker3 `(`192.168.50.101`) und dem Host-`Docker4 `(`192.168.50.102`) verschlüsselt angezeigt werden. Da beide Gastgeber sich darauf einigen müssen, was ein vertrauenswürdiges Netzwerk ist, werden die Hosts `docker1 `und `docker2 `niemals damit einverstanden sein, dass ihre Verbindungen unverschlüsselt sind.
