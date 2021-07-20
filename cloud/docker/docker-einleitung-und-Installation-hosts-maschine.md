---
title: docker-einleitung-und-Installation-hosts-maschine
description: 
published: true
date: 2021-06-09T15:10:51.188Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:10:45.160Z
---

# Docker Installation der Host maschienen

Anfang dieses Jahres veröffentlichte Docker Orchestrierungswerkzeuge (https://blog.docker.com/2015/02/orchestrating-docker-with-machine-swarm-and-compose/) und Maschinen-, Schwarm- und Compose-Container nahtlos. In diesem Rezept decken wir Docker Machine ab und betrachten die anderen in späteren Kapiteln. Mit dem Docker-Tool (https://github.com/docker/machine/) können Sie Docker-Hosts lokal auf Cloud mit einem Befehl einrichten. Es ist derzeit im Beta-Modus und wird nicht für die Produktion verwendet. Es unterstützt Umgebungen wie VirtualBox, OpenStack, Google, Digital Ocean und andere. Für eine vollständige Liste können Sie https://github.com/docker/machine/tree/master/drivers besuchen. Nutzen wir dieses Tool und richten einen Host in Google Cloud ein.

## Hinweis

Wir werden Docker Machine nur für dieses Rezept verwenden. Rezepte, die in diesem oder anderen Kapiteln erwähnt werden, können oder dürfen nicht auf dem Host arbeiten, der von Docker Machine eingerichtet wurde.

### Fertig werden

Docker-Maschine wird nicht mit der Standardinstallation angezeigt. Sie müssen es aus seinem GitHub-Versions-Link herunterladen (https://github.com/docker/machine/releases). Bitte überprüfen Sie die neueste Version und den Vertrieb vor dem Herunterladen. Als Root-Benutzer laden Sie die Binärdatei herunter und machen sie ausführbar:

```s
$ curl -L https://github.com/docker/machine/releases/download/v0.2.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
$ chmod a+x  /usr/local/bin/docker-machine 
```

Wenn Sie noch kein Konto bei Google Compute Engine (GCE) haben, können Sie sich für eine kostenlose Testversion (https://cloud.google.com/compute/docs/signup) anmelden, um dieses Rezept auszuprobieren. Ich gehe davon aus, dass Sie ein Projekt auf GCE haben und das Google Cloud SDK auf dem System installiert haben, auf dem Sie Docker Machine binary heruntergeladen haben. Wenn nicht, dann können Sie diese Schritte ausführen:

1.Richten Sie das Google Cloud SDK auf Ihrem lokalen System ein:
`$ curl https://sdk.cloud.google.com | bash`

2.Create a project on GCE (https://console.developers.google.com/project) and get its project ID. Please note that the project name and its ID are different.

3.Gehen Sie zur Projekt-Homepage und wählen Sie im **APIs & auth**-Bereich **APIs** aus und aktivieren Sie die Google Compute Engine-API.

## Wie es geht…

1. Weisen Sie die Projekt-ID zu, die wir einer Variablen gesammelt haben: `GCE_PROJECT`: 
`$ export  GCE_PROJECT="<Your Project ID>"`

2.Führen Sie den folgenden Befehl aus und geben Sie den Code ein, der auf dem aufgetauchten Webbrowser bereitgestellt wird:

```s
$ docker-machine  create -d google --google-project=$GCE_PROJECT  --google-machine-type=n1-standard-2 --google-disk-size=50 cookbook
INFO[0000] Opening auth URL in browser.
......
......
INFO[0015] Saving token in /home/nkhare/.docker/machine/machines/cookbook/gce_token

INFO[0015] Creating host...
INFO[0015] Generating SSH Key
INFO[0015] Creating instance.
INFO[0016] Creating firewall rule.
INFO[0020] Waiting for Instance...
INFO[0066] Waiting for SSH...
INFO[0066] Uploading SSH Key
INFO[0067] Waiting for SSH Key
INFO[0224] "cookbook" has been created and is now the active machine.
INFO[0224] To point your Docker client at it, run this in your shell: eval "$(docker-machine_linux-amd64 env cookbook)"
```

3.Liste der vorhandenen Hosts, die von Docker Machine verwaltet werden:

`$ ./docker-machine_linux-amd64 ls`
`docker-maschine ls`

Sie können mehrere Hosts mit Docker Machine verwalten. Das * zeigt das aktive an.

4.Um die Befehle anzuzeigen, um die Umgebung für den Docker-Client einzurichten:

`$  ./docker-machine_linux-amd64 env cookbook`

`docker-machine env cookbook`

Also, wenn Sie den Docker-Client mit den vorherigen Umgebungsvariablen zeigen, würden wir uns mit dem Docker-Daemon verbinden, der auf der GCE läuft.

5.Und um den Docker-Client auf unsere neu erstellte Maschine zu verweisen, führen Sie den folgenden Befehl aus:

`$ eval "$(./docker-machine_linux-amd64 env  cookbook)"`

Von nun an werden alle Docker-Befehle auf der Maschine laufen, die wir auf GCE bereitgestellt haben, bis die vorherigen Umgebungsvariablen gesetzt sind.

## Wie es funktioniert…

Docker-Maschine verbindet sich mit dem Cloud-Provider und richtet eine Linux-VM mit Docker Engine ein. Es schafft ein `.docker/machine/` Verzeichnis unter dem aktuellen Benutzerverzeichnis, um die Konfiguration zu speichern.

Es gibt mehr…

Docker-Maschine bietet Management-Befehle wie `create`, `start`, `stop`, `restart`, `kill`, `remove`, `ssh` und andere, um Maschinen zu verwalten. Für detaillierte Optionen, suchen Sie nach der Hilfe-Option von Docker Machine:

`$ docker-machine  -h`

Sie können die Option `--driver/-d` verwenden, um eine der vielen Endpunkte zu erstellen, die für die Bereitstellung verfügbar sind. Um beispielsweise die Umgebung mit VirtualBox einzurichten, führen Sie den folgenden Befehl aus:
`$ docker-machine create --driver virtualbox dev`

Auf der Docker Maschiene
`ls`
