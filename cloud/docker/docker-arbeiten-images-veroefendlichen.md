---
title: docker-arbeiten-images-veroefendlichen
description: 
published: true
date: 2021-06-09T15:06:55.397Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:06:50.380Z
---

# Docker arbeiten mit Images: Veröfentlischen

Angenommen, Sie haben ein Image erstellt, das der Entwicklungsumgebung in Ihrer Organisation entspricht. Sie können es entweder mit einem Teerball teilen, was wir später in diesem Kapitel sehen werden, oder in eine zentrale Lagern, von wo aus der Benutzer es herhollen kann.
Diese zentrale Lage kann entweder eine öffentliche oder eine private Registrierung sein. In diesem Rezept werden wir sehen, wie man das Image in die Registry mit dem Docker-Push-Befehl holt.
Später in diesem Kapitel werden wir entdecken, wie man die private Registrierung einrichtet.

## Fertig werden

Sie benötigen ein gültiges Konto auf Docker Hub, um Images / Repositories abzulegen.

Eine lokale Registrierung muss eingerichtet werden, wenn Sie Images / Repositories lokal ablegen wollen.

### Wie es geht…

`$ docker push NAME[:TAG]`

Standardmäßig verwendet der vorherige Befehl den Benutzernamen und die Registrierung, die im `docker info` Befehl angezeigt wird, um die Images zu übertragen. Wie im vorigen Beispiel gezeigt, verwendet der Befehl `nkhare` als den Benutzernamen und `https://index.docker.io/v1/` als Registry.

Um das Image zu senden, das wir im vorherigen Abschnitt erstellt haben, führen Sie den folgenden Befehl aus:

`$ docker push nkhare/fedora:httpd`

Angenommen, du willst das Image in die lokale Registry senden, die auf einem Host namens `local-registry` gehostet wird. Um dies zu tun, müssen Sie zuerst das Image mit dem Namen des Registrierungshosts oder der IP-Adresse mit der Portnummer markieren, auf der die Registrierung ausgeführt wird, und dann die Images senden.

```sh
docker tag [-f|--force[=false] IMAGE [REGISTRYHOST/][USERNAME/]NAME[:TAG]
docker push [REGISTRYHOST/][USERNAME/]NAME[:TAG]
```

Zum Beispiel, sagen wir, unsere Registrierung ist auf `shadowfax.example.com` konfiguriert, um dann das Image auszuwählen verwenden Sie den folgenden Befehl:
`docker tag nkhare/fedora:httpd shadowfax.example.com:5000/nkhare/fedora:http`

Dann, um das Bild zu senden, verwenden Sie den folgenden Befehl:

`$ docker push shadowfax.example.com:5000/nkhare/fedora:httpd`

### Wie es funktioniert…

Es werden zuerst alle Zwischenschichten aufgelistet, die erforderlich sind, um dieses spezifische Image zu erstellen. Es wird dann überprüft, um zu sehen, aus diesen Schichten, wie viele sind bereits in der Registrierung vorhanden sind. Nun Endlich wird es alle Ebenen kopieren, die in der Registry nicht mit ihren Metadaten vorhanden sind, die zum Erstellen des Bildes erforderlich sind.

### Es gibt mehr…

Als wir unser Image in die öffentliche Registrierung kopiert haben, können wir uns bei Docker Hub anmelden und nach dem Image suchen:
