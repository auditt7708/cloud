---
title: docker-daten-mgmnt-lamp-example
description: 
published: true
date: 2021-06-09T15:09:30.307Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:09:23.967Z
---

# Docker lamp Management

Lassen Sie uns das vorherige Rezept verlängern, indem Sie eine LAMP-Anwendung (WordPress) erstellen, indem Sie die Container verknüpfen.

## Fertig werden

Um MySQL und WordPress Bilder aus der Docker Registry zu ziehen:

    * Für MySQL:

        * Für Bild, besuchen Sie https://registry.hub.docker.com/_/mysql/

        * Für Dockerfile besuchen Sie https://github.com/docker-library/docker-mysql

    * Für WordPress:

        * Für Bild, besuchen Sie https://registry.hub.docker.com/_/wordpress/

        * Für Dockerfile besuchen Sie https://github.com/docker-library/wordpress

## Wie es geht…

1. Zuerst einen `mysql`-Container starten:
`$ docker run --name mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql`

2. Dann starten Sie den `wordpress` -Container und verknüpfen Sie ihn mit dem `mysql`-Container:
`$ docker run -d --name wordpress --link mysql:mysql -p 8080:80 wordpress`

Wir haben den `8080`-Port des Docker-Hosts zum Container-`80`-Port verbunden, so dass wir WordPress anschließen können, indem wir auf den 8080-Port des Docker-Hosts mit der `http://<DockerHost>:8080` URL zugreifen.

### Wie es funktioniert…

Zwischen den `WordPress`- und `MySQL`-Containern wird ein Link erstellt. Immer wenn der `WordPress`-Container eine DB-Anforderung erhält, übergibt er ihn an den `mysql`-Container und erhält die Ergebnisse. Schauen Sie sich das vorhergehende Rezept für weitere Details an.
