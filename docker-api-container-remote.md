# Docker API Container Remote

In ähnlicher Weise wie wir Bildoperationen mit APIs durchgeführt haben, können wir auch alle Container-bezogenen Operationen mit APIs durchführen.

## Fertig werden

Konfiguriere den Docker-Daemon und erlaube den Remote-Zugriff, wie im früheren Rezept beschrieben.

## Wie es geht…

In diesem Rezept werden wir uns einige Container-Operationen anschauen:

1.Um die Container aufzulisten, verwenden Sie folgende API:

`GET /containers/json`

Hier einige Beispiele:

* Holen Sie sich alle Laufenden container:

`curl -X GET http://shadowfax.example.com:2375/containers/json`

* Holen Sie sich alle laufenden Container, einschließlich der gestoppten

`curl -X GET http://shadowfax.example.com:2375/containers/json?all=True`

2.Um einen neuen Container zu erstellen, verwenden Sie die folgende API:

`POST /containers/create`

Hier sind ein paar Beispiele:

* Erstellen Sie einen Container aus dem Fedora-Image:

`curl -X POST  -H "Content-type:application/json" -d '{"Image": "fedora", "Cmd": ["ls"] }' http://dockerhost.example.com:2375/containers/create`

* Erstellen Sie einen Container aus dem Fedora-Bild und nennen Sie es f21:

`curl -X POST  -H "Content-type:application/json" -d '{"Image": "fedora", "Cmd": ["ls"] }' http://dockerhost.example.com:2375/containers/create?name=f21`

3.Um einen Container zu starten, verwenden Sie die folgende API:

`POST /containers/<id>/start`

Zum Beispiel starten Sie einen Container mit der 591ab8ac2650 ID:

`curl -X POST  -H "Content-type:application/json" -d '{"Dns":  ["4.2.2.1"] }' http://dockerhost.example.com:2375/containers/591ab8ac2650/start`

Beachten Sie, dass beim Starten des gestoppten Containers auch die DNS-Option bestanden hat, die die DNS-Konfiguration des Containers ändert.

4.Um einen Container zu untersuchen, verwenden Sie folgende API:

`GET /containers/<id>/json`

Zum Beispiel, untersuchen Sie einen Container mit der 591ab8ac2650 ID:

`curl -X GET http://dockerhost.example.com:2375/containers/591ab8ac2650/json`

5.Um eine Liste von Prozessen zu erhalten, die in einem Container laufen, verwenden Sie die folgende API:

`GET /containers/<id>/top`

Zum Beispiel, die Prozesse laufen in den Container mit der 591ab8ac2650 ID:

`curl -X GET http://dockerhost.example.com:2375/containers/591ab8ac2650/top`

6.Um einen Container zu stoppen, verwenden Sie die folgende API:

`POST /containers/<id>/stop`

Zum Beispiel stoppen Sie einen Container mit der 591ab8ac2650 ID:

`curl -X POST http://dockerhost.example.com:2375/containers/591ab8ac2650/stop`

## Wie es funktioniert

Wir haben nicht alle Optionen der oben diskutierten APIs abgedeckt und Docker stellt APIs für andere Container-bezogene Operationen zur Verfügung. Weitere Informationen finden Sie in der API-Dokumentation.

## Siehe auch

* Die Dokumentation auf der [Docker-Website](https://docs.docker.com/reference/api/docker_remote_api_v1.18/#21-container)