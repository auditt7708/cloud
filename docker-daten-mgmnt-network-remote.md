Sobald der Container verfügbar ist, möchten wir von außen auf ihn zugreifen. Wenn Sie den Container mit der Option `--net=host` gestartet haben, können Sie über die Docker-Host-IP aufrufen. Mit `--net=none` können Sie die Netzwerkschnittstelle vom öffentlichen Nets erreichen  oder über andere komplexe Einstellungen hinzufügen . Lassen Sie uns sehen, was passiert - wie Pakete von der Host-Netzwerk-Schnittstelle an den Container weitergeleitet werden.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und dass Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Lassen Sie uns einen Container mit der Option `-P` starten:
`$ docker run --expose 80 -i -d -P --name centos1  centos /bin/bash`

Dadurch werden alle Netzwerk-Port des Containers automatisch an einen zufälligen High-Port des Docker-Hosts zwischen 49000 und 49900 abgebildet.

Im Bereich `PORTS` sehen wir `0.0.0.0:49159->80/tcp`, was folgende Form hat:
`<Host Interface>:<Host Port> -> <Container Interface>/<protocol>`

Also, falls eine Anfrage auf Port `49159` von einer beliebigen Schnittstelle auf dem Docker-Host kommt, wird die Anforderung an Port `80` des `centos1` Containers weitergeleitet.

Wir können auch einen bestimmten Port des Containers an den spezifischen Port des Hosts mit der Option `-p` abbilden:
`$  docker run -i -d -p 5000:22 --name centos2 centos /bin/bash`

In diesem Fall werden alle Anfragen, die auf Port `5000` von einer beliebigen Schnittstelle auf dem Docker-Host kommen, an Port `22` des Centos2-Containers weitergeleitet.

### Wie es funktioniert…

Mit der Standardkonfiguration richtet Docker die Firewall-Regel ein, um die Verbindung vom Host zum Container weiterzuleiten und die IP-Weiterleitung auf dem Docker-Host zu ermöglichen:
`iptables -t nat -L n`

Wie wir aus dem vorstehenden Beispiel sehen können, wurde eine `DNAT`-Regel eingerichtet, um den gesamten Verkehr auf Port `5000` des Hosts an Port 22 des Containers weiterzuleiten.

### Es gibt mehr…

Standardmäßig wird mit der Option `-p` Docker alle Anfragen an eine beliebige Schnittstelle an den Host weiterleiten. Um an eine bestimmte Schnittstelle zu binden, können wir so etwas wie folgendes angeben:
`$ docker run -i -d -p 192.168.1.10:5000:22 --name f20 fedora /bin/bash`

In diesem Fall werden nur Anfragen, die auf Port `5000` auf der Schnittstelle kommen, die die IP `192.168.1.10` auf dem Docker-Host hat, an Port `22` des `f20`-Containers weitergeleitet. Um den Port `22` des Containers dem dynamischen Port des Hosts zuzuordnen, können wir folgenden Befehl ausführen:
`$ docker run -i -d -p 192.168.1.10::22 --name f20 fedora /bin/bash`

Wir können mehrere Ports auf Containern an Ports auf Hosts wie folgt binden:
`$  docker run -d -i -p 5000:22 -p 8080:80 --name f20 fedora /bin/bash`

Wir können den öffentlich public-facing mappen, dem des Containers zugeordnen :
```
$ docker port f20 80
0.0.0.0:8080
```

Um alle Netzwerkeinstellungen eines Containers zu betrachten, können wir den folgenden Befehl ausführen:
`$ docker inspect   -f "{{ .NetworkSettings }}" f20`

### Siehe auch

     Netzwerkdokumentation auf der Docker-Website unter https://docs.docker.com/articles/networking/.