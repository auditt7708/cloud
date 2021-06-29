---
title: docker-performence-netzwerkleistung
description: 
published: true
date: 2021-06-09T15:14:28.671Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:14:23.213Z
---

# Docker Netzwerkleistung

Netzwerk ist eines der wichtigsten Aspekte bei der Bereitstellung der Anwendungen in der Containerumgebung. Um Leistungsvergleich mit bare metal, VM und Containern durchzuführen, müssen wir verschiedene Szenarien wie folgt berücksichtigen:

* Bare metal nach bare metal

* VM zu VM

* Docker container zu container mit dem default netzwerk mode (bridge)

* Docker container zu container mit host net (--net=host)

* Docker-Container läuft in VM mit verbindung der Außenwelt

In einem der vorangegangenen Fälle können wir zwei Endpunkte abholen, um das Benchmarking zu machen. Wir können Werkzeuge wie `nuttcp` (http://www.nuttcp.net/) und `netperf` (http://netperf.org/netperf/) verwenden, um die Netzwerkbandbreite und die Anforderung / Antwort zu messen.

## Fertig werden

Stellen Sie sicher, dass beide Endpunkte einander erreichen können und die notwendigen Pakete / Software installiert haben. Auf Fedora 21 können Sie `nuttcp` mit folgendem Befehl installieren:
`$ yum install -y nuttcp`

Und Sie bekommen netperf von ihrer Webseite.

## Wie es geht…

Um die Netzwerkbandbreite mithilfe von nuttcp zu messen, führen Sie die folgenden Schritte aus:
1.Starten Sie den Nuttcp-Server auf einem Endpunkt:

$ nuttcp -S

2.Messen Sie den Sende-Durchsatz (Client zu Server) vom Client mit folgendem Befehl:

`$ nuttcp -t <SERVER_IP>`

3.Messen Sie den Empfangsdurchsatz auf dem Client (Server zu Client) mit dem folgenden Befehl:

`$ nuttcp -r <SERVER_IP>`

4.Um den Anforderungs- / Antwort-Benchmark mit `netperf` auszuführen, führen Sie die folgenden Schritte aus:

5.Starten Sie den `netserver` auf einem Endpunkt:

6.Verbinden Sie mit dem Server vom anderen Endpunkt und führen Sie den Request/Response-Test aus:

> Für TCP:
> `$ netperf  -H 172.17.0.6 -t TCP_RR`
>Für UDP
> `$ netperf  -H 172.17.0.6 -t UDP_RR`

## Wie es funktioniert…

In beiden früher erwähnten Fällen wird ein Endpunkt zum Client und sendet die Anfragen an den Server auf dem anderen Endpunkt.

## Es gibt mehr…

Wir können die Benchmark-Ergebnisse für verschiedene Szenarien sammeln und vergleichen. `netperf` kann auch für Durchsatztests verwendet werden.

### Siehe auch

* Schauen Sie sich die Netzwerk-Benchmark-Ergebnisse an, die von IBM und VMware in den Links veröffentlicht werden, auf die in diesem Kapitel verwiesen wird
