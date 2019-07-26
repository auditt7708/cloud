# Docker arbeiten mit Images: Private Registry

Wie wir schon früher gesehen haben, ist die öffentliche Docker-Registrierung die verfügbare [Docker Hub](https://registry.hub.docker.com/), über die Benutzer Bilder hochladen / ziehen können. Wir können auch eine private Registrierung entweder in einer lokalen Umgebung oder auf der Cloud. Es gibt ein paar Möglichkeiten, die lokale Registrierung einzurichten:

* Verwenden Sie die Docker-Registrierung von Docker Hub

* Erstellen Sie ein Image aus Dockerfile und führen Sie einen Registrieren Sie den container:

[Fedora-Dockerfiles/tree/master/registry](Https://github.com/fedora-cloud/Fedora-Dockerfiles/tree/master/registry)

* Konfigurieren Sie das distribution-specifische Paket wie Fedora, das das Docker-Registry-Paket bereitstellt, das Sie installieren und konfigurieren können.

Der einfachste Weg, um es einzurichten, ist durch den Registry-Container selbst.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und dass Sie über den Docker-Client eine Verbindung herstellen können.

### Wie es geht…

1. Um die Registrierung auf dem Container auszuführen, führen Sie den folgenden Befehl aus:
`$ docker run -p 5000:5000 registry`

2.Um die neu erstellte Registrierung zu testen, führen Sie die folgenden Schritte aus:
 1.Starten Sie einen Container und seine ID mit dem folgenden Befehl:
    `$ ID='docker run -d -i fedora /bin/bash'`
  2.Falls erforderlich, commiten Sie den neu erstellten Container und nehmen Sie einige Änderungen vor.
    Fügen Sie dann diese Änderungen in das lokale Repository ein:
       `$ docker commit $ID fedora-20`
3.Um das Image in die lokale Registry zu puschen, müssen wir das Bild mit dem Hostnamen oder der IP-Adresse des Registry-Hosts markieren. Lassen Sie uns annehmen, unsere Registry-Host ist Registry-Host; Dann,müssen wir um es zu markieren, verwenden Sie den folgenden Befehl:
`$ docker tag fedora-20 registry-host:5000/nkhare/f20`

4.Da wir HTTPS beim Starten der Registry nicht richtig konfiguriert haben, erhalten wir einen Fehler wie der `ping attempt failed with error: Get https://dockerhost:5000/v1/_ping`. Für unser Beispiel, müssen wir die -`-insecure-registry registry-host: 5000` Option zum Dämon hinzufügen. Wenn du den Docker-Daemon manuell gestartet hast, dann müssen wir den Befehl wie folgt ausführen, um eine unsichere Registry zu ermöglichen:
`$ docker -d   --insecure-registry registry-host:5000`

Um das Bild zu betätigen, verwenden Sie den folgenden Befehl:
`$ docker push registry-host:5000/nkhare/f20`

6.Um einen Pull des Images aus der lokalen Registrierung durchzuführen, führen Sie den folgenden Befehl aus:
`$ docker pull registry-host:5000/nkhare/f20`

### Wie es funktioniert…

Der vorherige Befehl, das Image zu pullen, lädt das offizielle Registry-Image von Docker Hub herunter und führt es auf Port `5000` aus. Die Option `-p` veröffentlicht den Container-Port zum Port des Host-Systems. Wir werden uns die Details zum Port-Publishing im nächsten Kapitel anschauen.

Die Registry kann auch auf beliebigen Servern mit der Docker-Registry App konfiguriert werden. Die Schritte dazu finden Sie auf der Docker-Registry GitHub Seite:

[docker-registry](Https://github.com/docker/docker-registry)

### Es gibt mehr…

Schauen wir uns die Dockerfile von Docker-Registry an, um zu verstehen, wie das Registry-Image erstellt wird und wie man verschiedene Konfigurationsoptionen festlegt:

```sh
# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependencies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Latest Ubuntu LTS
FROM ubuntu:14.04

# Update
RUN apt-get update \
# Install pip
    && apt-get install -y \
        swig \
        python-pip \
# Install deps for backports.lzma (python2 requires it)
        python-dev \
        python-mysqldb \
        python-rsa \
        libssl-dev \
        liblzma-dev \
        libevent1-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /docker-registry
COPY ./config/boto.cfg /etc/boto.cfg

# Install core
RUN pip install /docker-registry/depends/docker-registry-core

# Install registry
RUN pip install file:///docker-registry#egg=docker-registry[bugsnag,newrelic,cors]

RUN patch \
 $(python -c 'import boto; import os; print os.path.dirname(boto.__file__)')/connection.py \
 < /docker-registry/contrib/boto_header_patch.diff

ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config_sample.yml
ENV SETTINGS_FLAVOR dev
EXPOSE 5000
CMD ["docker-registry"]
```

Mit der vorherigen Dockerfile werden wir:

* Ubuntus Basisbild Benutzen und Packete installieren / aktualisieren

* Kopiere den Docker-Registry-Quellcode in das Image

* Verwenden der `pip install` docker-registry

* Richten Sie die Konfigurationsdatei ein, die beim Ausführen der Registrierung mit der Umgebungsvariablen verwendet werden soll

* Richten Sie die Richtung ein, der beim Ausführen der Registrierung mit der Umgebungsvariable verwendet werden soll

* Exponieren Sie Port 5000

* Führen Sie die ausführbare Datei aus

Ziele in der Konfigurationsdatei (`/docker-registry/config/config_sample.yml`) bieten verschiedene Möglichkeiten, die Registrierung zu konfigurieren. Mit der vorherigen Dockerfile werden wir den `dev`-Richtung mit den Umgebungsvariablen einstellen. Die verschiedenen Arten von Zielen sind:

* Local: Dies speichert Daten im lokalen Dateisystem

* S3: Dies speichert Daten in einem AWS S3 bucket

* Dev: Dies ist die grundlegende Konfiguration mit den lokalen Zielen

* Test: Dies wird von Unit-Tests verwendet

* Prod: Dies ist die Produktionskonfiguration (im Grunde ein Synonym für den S3-bucket)

* Gcs: Dies speichert Daten in Google Cloud Storage

* Schnell: Dies speichert Daten in OpenStack Swift

* Blick: Dies speichert Daten im OpenStack Glance, mit einem Fallback auf die lokale Speicherung

* Glight-swift: Dies speichert Daten im OpenStack Glance, mit einem Fallback to Swift

* Elliptics: Dies speichert Daten in Elliptics Key-Value-Speicher

Für jeden der vorherigen Zile stehen verschiedene Konfigurationsoptionen wie Loglevel, Authentifizierung und so weiter zur Verfügung. Die Dokumentation für alle Optionen gibt es auf der GitHub-Seite der Docker-Registry.

Die documentation on [GitHub](https://github.com/docker/docker-registry) ist veraltet.
