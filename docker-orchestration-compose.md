Docker Compose (http://docs.docker.com/compose/) ist das native Docker-Tool, um die interdependenten Container auszuführen, aus denen eine Anwendung besteht. Wir definieren eine Multicontainer-Anwendung in einer einzigen Datei und füttern sie an Docker Compose, die die Anwendung einrichtet. Zum Zeitpunkt des Schreibens ist Compose noch nicht fertigungsbereit. In diesem Rezept werden wir wieder WordPress als Beispiel-Anwendung zu laufen.

### Fertig werden

Vergewissern Sie sich, dass Docker Version 1.3 oder höher auf dem System installiert ist. Um Docker Compose zu installieren, führen Sie den folgenden Befehl aus:

### Wie es geht…

1. Erstellen Sie ein Verzeichnis für die Anwendung, und in ihm erstellen Sie `docker-compose.yml`, um die App zu definieren:
```
cd wordpress_compose/
cat docker-compose.yml
wordpress:
  image: wordpress
  links:
    - db:mysql
  ports:
    - 8080:80

db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: example
```

2. Wir haben das vorhergehende Beispiel aus dem offiziellen WordPress Docker Repo auf Docker Hub benutzt.
(https://registry.hub.docker.com/_/wordpress/).

3. Führen Sie im App-Verzeichnis den folgenden Befehl aus, um die App zu erstellen:
`$ docker-compose up`

4. Sobald der Build abgeschlossen ist, greifen Sie auf die WordPress-Installations-Seite von `http://localhost:8080` oder `http://<host-ip>:8080` zu.

### Wie es funktioniert…

Docker Compose lädt sowohl die mariadb WordPress Bilder, wenn nicht lokal aus der offiziellen Docker Registry. Zuerst startet es den db-Container aus dem mariadb-Bild; Dann startet es den WordPress-Container. Als nächstes verbindet es mit dem db-Container und exportiert den Port zum Host-Rechner.

### Es gibt mehr…

Wir können sogar Bilder aus der Dockerfile während der Komposition bauen und dann für die App verwenden. Zum Beispiel, um das WordPress-Bild zu bauen, können wir die entsprechende Dockerfile und andere unterstützende Datei aus dem Verzeichnis Compose-Verzeichnis der Anwendung und aktualisieren Sie die Docker-compose.yml-Datei in ähnlicher Weise wie folgt:
```
cd wordpress_compose/
cat docker-compose.yml
wordpress:
  image: wordpress
  links:
    - db:mysql
  ports:
    - 8080:80

db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: example
```

Wir können anfangen, aufhören, wieder aufbauen und den Status der App bekommen. Besuchen Sie die Dokumentation auf der Docker-Website.

### Siehe auch

* Der Docker erstellt YAML-Datei-Referenz unter http://docs.docker.com/compose/yml/

* Die Docker-Befehlszeilenreferenz unter http://docs.docker.com/compose/cli/

* Der Docker verfasst das GitHub-Repository unter https://github.com/docker/compose