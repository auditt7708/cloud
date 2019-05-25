# Docker arbeiten mit Images: Docker Apache

Ich werde Dockerfiles aus dem Fedora-Dockerfiles [GitHub Repo](https://github.com/fedora-cloud/Fedora-Dockerfiles) verweisen. Wenn du Fedora benutzt hast, kannst du auch das Paket `fedora-dockerfiles`installieren, um die Probe Dockerfiles in `/usr/share/fedora-dockerfiles` zu bekommen. In jedem der Unterverzeichnisse werden Sie ein Dockerfile, die unterstützenden Dateien und eine README-Datei.

Die Fedora-Dockerfiles GitHub Repo hat die neuesten Beispiele und ich empfehle Ihnen, die letzten auszuprobieren.

## Fertig werden

Klonen Sie die Fedora-Dockerfiles Git Repo mit dem folgenden Befehl:
`$ git clone https://github.com/nkhare/Fedora-Dockerfiles.git`

Gehen Sie nun zum Apache-Unterverzeichnis:

```sh
$ cd Fedora-Dockerfiles/apache/
$ cat Dockerfile
FROM fedora:20
MAINTAINER "Scott Collier" <scollier@redhat.com>

RUN yum -y update && yum clean all
RUN yum -y install httpd && yum clean all
RUN echo "Apache" >> /var/www/html/index.html

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-apache.sh /run-apache.sh
RUN chmod -v +x /run-apache.sh

CMD ["/run-apache.sh"]
```

Die anderen unterstützenden Dateien sind:

* README.md: eine README Datei.

* run-apache.sh: Dies ist das Skript, um HTTPD im Vordergrund auszuführen.

* LICENSE: Dies ist die GPL-Lizenz

### Wie es geht…

Mit dem folgenden `Build`-Befehl können wir ein neues Image erstellen:

```sh
$ docker build -t fedora/apache .
Sending build context to Docker daemon 23.55 kB
Sending build context to Docker daemon
Step 0 : FROM fedora:20
 ---> 6cece30db4f9
Step 1 : MAINTAINER "Scott Collier" <scollier@redhat.com>
 ---> Running in 2048200e6338
 ---> ae8e3c258061
Removing intermediate container 2048200e6338
Step 2 : RUN yum -y update && yum clean all
 ---> Running in df8bc8ee3117
.... Installing/Update packages ...
Cleaning up everything
 ---> 5a6d449e59f6
Removing intermediate container df8bc8ee3117
Step 3 : RUN yum -y install httpd && yum clean all
 ---> Running in 24449e520f18
.... Installing HTTPD ...
Cleaning up everything
 ---> ae1625544ef6
Removing intermediate container 24449e520f18
Step 4 : RUN echo "Apache" >> /var/www/html/index.html
 ---> Running in a35cbcd8d97a
 ---> 251eea31b3ce
Removing intermediate container a35cbcd8d97a
Step 5 : EXPOSE 80
 ---> Running in 734e54f4bf58
 ---> 19503ae2a8cf
Removing intermediate container 734e54f4bf58
Step 6 : ADD run-apache.sh /run-apache.sh
 ---> de35d746f43b
Removing intermediate container 3eec9a46da64
Step 7 : RUN chmod -v +x /run-apache.sh
 ---> Running in 3664efba393f
mode of '/run-apache.sh' changed from 0644 (rw-r--r--) to 0755 (rwxr-xr-x)
 ---> 1cb729521c3f
Removing intermediate container 3664efba393f
Step 8 : CMD /run-apache.sh
 ---> Running in cd5e7534e815
 ---> 5f8041b6002c
Removing intermediate container cd5e7534e815
Successfully built 5f8041b6002c
```

### Wie es funktioniert…

Der Build-Prozess nimmt ein Basisimage  auf, installiert das erforderliche `HTTPD`-Paket und erstellt eine HTML-Seite.
Dann macht es Port `80` verfügbar, um die Webseite zu bedienen und setzt Anweisungen, um Apache zu Beginn des Containers zu starten.

### Es gibt mehr…

Lass uns den Container aus dem erstellten Bild heraus ausführen, seine IP-Adresse abrufen und von dort aus auf die Webseite zugreifen:

```sh
ID=`docker run -d -p 80 fedora/apache`
docker inspect --format='{{.NetworkSettings.IPAddress}}' $ID
# ausgabe deiner IP
curl DeineIP

```