---
title: docker-praktischer-einsatz-app-openshift
description: 
published: true
date: 2021-06-09T15:14:54.464Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:14:48.920Z
---

# Docker Praxis mit Openshift

Platform-as-a-Service ist eine Art von Cloud-Service, bei dem der Verbraucher die Software-Bereitstellungen und Konfigurationseinstellungen für Anwendungen (meist Web) steuert und der Anbieter Server, Netzwerke und andere Dienste zur Verwaltung dieser Bereitstellungen bereitstellt. Der Anbieter kann extern sein (ein öffentlicher Anbieter) oder intern (eine IT-Abteilung in einer Organisation). Es gibt viele PaaS-Anbieter wie Amazon (http://aws.amazon.com/), Heroku (https://www.heroku.com/), OpenShift (https://www.openshift.com/), und so weiter. In der jüngsten Vergangenheit scheinen die Container die natürliche Wahl für Anwendungen zu haben, um sich zu entfalten.

Zuvor in diesem Kapitel haben wir untersucht, wie wir eine CI / CD-Lösung mit Shippable und OpenShift bauen können, wo wir unsere App zu OpenShift PaaS eingesetzt haben. Wir haben unsere App auf Openshift Online, dem Public Cloud Service, eingesetzt. Zum Zeitpunkt des Schreibens dieses Buches verwendet der OpenShift Public Cloud Service die Nicht-Docker-Container-Technologie, um Apps für den Public Cloud Service bereitzustellen. Das OpenShift-Team hat an OpenShift v3 (https://github.com/openshift/origin) gearbeitet, das ist ein PaaS, das Technologien wie Docker und Kubernetes (http://kubernetes.io) unter anderem einsetzt Ökosystem, um Ihre Cloud-fähigen Apps zu bedienen. Sie planen, dies in den Public Cloud Service noch in diesem Jahr zu bewegen. Wie wir über Kubernetes in Kapitel 8, Docker Orchestrations- und Hosting-Plattformen gesprochen haben, empfiehlt es sich, dieses Kapitel zuerst zu lesen, bevor es mit diesem Rezept weitergeht. Ich werde einige der Konzepte aus diesem Kapitel ausleihen.

![openshift-aio](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_09.jpg)
https://blog.openshift.com/openshift-v3-deep-dive-docker-kubernetes/

Kubernetes bietet Container-Cluster-Management mit Features wie Scheduling Pods und Service Discovery, aber es hat nicht das Konzept der vollständigen Anwendung, sowie die Fähigkeiten zu bauen und zu implementieren Docker Bilder aus dem Quellcode. OpenShift v3 erweitert das Basis-Kubernetes-Modell und füllt diese Lücken. Wenn wir in Kapitel 8, Docker Orchestrations- und Hosting-Plattformen vorankommen und auf die Kubernetes-Sektion schauen, werden Sie feststellen, dass für die Bereitstellung einer App Pods, Services und Replikations-Controller erforderlich sind. OpenShift v3 versucht, all diese Informationen zu abstrahieren und lässt Sie eine Konfigurationsdatei definieren, die sich um alle internen Verdrahtungen kümmert. Darüber hinaus bietet OpenShift v3 weitere Funktionen wie die automatisierte Bereitstellung durch Quellcode-Push, die zentrale Verwaltung und Verwaltung einer Applikation, Authentifizierung, Team- und Projekt-Isolation sowie Ressourcen-Tracking und Limitierung, die alle für die Enterprise-Implementierung benötigt werden.

In diesem Rezept werden wir All-in-One OpenShift v3 Origin auf einer VM einrichten und einen Pod starten. Im nächsten Rezept werden wir sehen, wie man eine App über Quellcode mit dem Source-to-Image (STI) Build-Feature erstellt und bereitstellt. Da es eine aktive Entwicklung auf OpenShift v3 Origin gibt, habe ich ein Tag aus dem Quellcode ausgewählt und diese Codebasis in diesem Rezept und das nächste verwendet. In der neueren Version können sich die Befehlszeilenoptionen ändern. Mit dieser Information in der Hand, sollten Sie in der Lage sein, sich an die neueste Version anzupassen. Das neueste Beispiel finden Sie unter https://github.com/openshift/origin/tree/master/examples/hello-openshift.

## Fertig werden

Richten Sie Vagrant (https://www.vagrantup.com/) ein und installieren Sie den VirtualBox-Provider (https://www.virtualbox.org/). Die Anleitung, wie man diese einrichtet, liegt außerhalb des Umfangs dieses Buches.

1.Klonen Sie das OpenShift Origin Repository:

`$ git clone https://github.com/openshift/origin.git`

2.Schauen Sie sich die v0.4.3 Tag:

```s
$ cd origin
$ git checkout tags/v0.4.3
```

3.Starten der vm:

`$ vagrant up --provider=virtualbox`

4.Melden Sie sich im Container an:

`$ vagrant ssh`

## Wie es geht…

1. Erstellen Sie die OpenShift-Binärdatei:

```s
$ cd /data/src/github.com/openshift/origin
$ make clean build
```

2.Gehen Sie zu den `hello-openshift` Beispielen:

`$  cd /data/src/github.com/openshift/origin/examples/hello-openshift`

3.Starten Sie alle OpenShift-Dienste in einem Dämon:

```s
$ mkdir logs
$ sudo /data/src/github.com/openshift/origin/_output/local/go/bin/openshift start --public-master=localhost &> logs/openshift.log & 
```

4.OpenShift-Dienste sind durch TLS gesichert. Unser Kunde muss die Serverzertifikate akzeptieren und sein eigenes Clientzertifikat präsentieren. Diese werden als Teil des Openshift-Starts im aktuellen Arbeitsverzeichnis generiert.

```s
$ export OPENSHIFTCONFIG=`pwd`/openshift.local.certificates/admin/.kubeconfig
$ export CURL_CA_BUNDLE=`pwd`/openshift.local.certificates/ca/cert.crt
$ sudo chmod a+rwX "$OPENSHIFTCONFIG"
```

5.Erstellen Sie die Pod aus der hallo-pod.json Definition:

`$ osc create -f hello-pod.json`

6.Verbinden Sie mit dem Pod:

`$ curl localhost:6061`

## Wie es funktioniert…

Wenn OpenShift startet, beginnen auch alle Kubernetes-Dienste. Dann verbinden wir uns mit dem OpenShift Master über CLI und fordern ihn an, einen Pod zu starten. Dieser Antrag wird dann an Kubernetes weitergeleitet, der die Pod startet. In der Pod-Konfigurationsdatei haben wir erwähnt, den Port `6061` der Host-Maschine mit dem Port `8080` des Pods zuzuordnen. Also, als wir den Gastgeber auf Port `6061` abgefragt haben, bekamen wir eine Antwort von der Pod.

## Es gibt mehr…

Wenn Sie den Befehl `docker ps` ausführen, sehen Sie die entsprechenden Container.
Siehe auch

Siehe auch

* Weitere Informationen finden Sie unter https://github.com/openshift/origin

* Das OpenShift 3 Beta 3 Video Tutorial unter https://blog.openshift.com/openshift-3-beta-3-training-commons-briefing-12/

* Das neueste OpenShift Training unter https://github.com/openshift/training

* Die OpenShift v3 Dokumentation unter http://docs.openshift.org/latest/welcome/index.html
