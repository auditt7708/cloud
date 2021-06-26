---
title: docker-daten-mgmnt-verknuepfen
description: 
published: true
date: 2021-06-09T15:10:00.337Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:09:55.166Z
---

# Docker Verknüpfungen

Mit der Containerisierung möchten wir unseren Stapel erstellen, indem wir services auf verschiedenen Containern ausführen und diese dann miteinander verknüpfen. 
Im vorherigen Kapitel haben wir einen WordPress-Container erstellt, indem wir sowohl einen Webserver als auch eine Datenbank im selben Container nutzen. Allerdings können wir sie auch in verschiedene container stecken und miteinander verknüpfen. Container-Verknüpfung schafft eine Eltern-Kind-Beziehung zwischen ihnen, in denen die Eltern ausgewählte Informationen ihrer Kinder sehen können. Die Verknüpfung beruht auf der Namensgebung von Containern.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie über den Docker-Client eine Verbindung herstellen können.

## Wie es geht…

1.Erstellen Sie einen benannten Container namens `centos_server`:
`$ docker run  -d -i -t --name centos_server centos /bin/bash`

2.Nun, lasst uns einen anderen Container mit dem `name`-Client starten und ihn mit dem `centos_server`-Container mit der Option `--link` verknüpfen, die den `name:alias` Argument annimmt. Dann schau dir die Datei `/etc/hosts` an:

`$ docker run  -i -t --link centos_server:server --name client fedora /bin/bash`

## Wie es funktioniert…

Im vorigen Beispiel haben wir den `centos_server` Container mit dem Client-Container mit einem alias Server verknüpft. Durch die Verknüpfung der beiden Container wird ein Eintrag des ersten Containers, der in diesem Fall `centos_server` ist, der `/etc/hosts` Datei im Clientcontainer hinzugefügt. Außerdem wird eine Umgebungsvariable namens `SERVER_NAME` innerhalb des Clients gesetzt, um auf den Server zu verweisen.

## Es gibt mehr…

Jetzt erstellen wir einen mysql-Container:

`$ docker run --name mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql`

Dann verknüpfen wir es von einen Client und überprüfen die Umgebungsvariablen:
`$ docker run  -i -t --link mysql:mysql-server --name client fedora /bin/bash`

Auch schauen wir uns die `docker ps` Ausgabe an:

Wenn Sie genau hinschauen, haben wir nicht die Optionen `-P` oder `-p` angegeben, um Ports zwischen zwei Containern zuzuordnen, während Sie den `client` container starten. 
Abhängig von dem Ports, die von einem Container angeboten sind, schafft Docker einen internen sicheren Tunnel in den Container, die mit ihm verknüpft sind. 
Und um das zu tun, setzt Docker Umgebungsvariablen innerhalb des Linker-Containers. 
Im vorigen Fall ist `mysql` der verknüpfte Container und der Client ist der Linker-Container. Da der mysql-Container Port `3306` freigibt, sehen wir im Umgebungsvariablen (`MYSQL_SERVER_*`) im Clientcontainer entsprechende Umgebungsvariablen.

## Tip

Wenn die Verknüpfung von dem Namen des Containers abhängt, wenn Sie einen Namen wiederverwenden möchten, müssen Sie den alten Container löschen.
