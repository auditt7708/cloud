# Docker API Programmierung

In den vorangegangenen Kapiteln haben wir verschiedene Befehle gelernt, um Images, Container und so weiter zu verwalten. Obwohl wir alle Befehle über die Befehlszeile ausführen, geschieht die Kommunikation zwischen dem Docker-Client (CLI) und dem Docker-Daemon durch APIs, die Docker-Daemon-Remote-APIs heißen.

Docker bietet auch APIs zur Kommunikation mit Docker Hub und Docker Registry, die der Docker Client auch verwendet. Zusätzlich zu diesen APIs haben wir Docker-Bindungen für verschiedene Programmiersprachen. Also, wenn Sie eine schöne GUI für Docker Bilder, Container-Management, und so weiter zu bauen, das Verständnis der APIs erwähnt wäre ein guter Ausgangspunkt.

Jetzt schauen wir in die Docker-Daemon-Remote-API und verwenden [Curl](http://curl.haxx.se/docs/manpage.html), um mit den Endpunkten verschiedener APIs zu kommunizieren, hier ein erster Befehl:

`$ curl -X <REQUEST> -H <HEADER> <OPTION> <ENDPOINT>`

Die vorhergehende Anforderung kehrt mit einem return code und einem output zurück, der dem Endpunkt und der Anforderung entspricht, die wir gewählt haben. `GET`, `PUT` und `DELETE` sind die verschiedenen Arten von Anfragen, und **GET** ist die Standardanforderung, wenn nichts angegeben ist. Jeder API-Endpunkt hat seine eigene Interpretation für den Rückkehrcode.

## Übersicht

* [Konfigurieren der Docker-Daemon-Remote-API](../docker-api-daemon-remote)

* [Durchführen von Imageoperationen mit entfernten APIs](../docker-api-image-operations-remote)

* [Durchführen von Containeroperationen mit Remote-APIs](../docker-api-container-remote)

* [Erkundung von Docker-Remote-API-Clientbibliotheken](../docker-api-client-remote)

* [Sichern der Docker-Daemon-Remote-API](../docker-api-remote-sicherheit)