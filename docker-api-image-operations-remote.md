# Docker API Image Operation Remote

Nach dem Aktivieren der Docker-Daemon-Remote-API können wir alle Imagebezogenen Operationen über einen Client durchführen. Um ein besseres Verständnis der APIs zu erhalten, verwenden wir `curl`, um eine Verbindung zum Remote-Daemon herzustellen und einige Image-bezogene Operationen durchzuführen.

## Fertig werden

Konfiguriere den Docker-Daemon und erlaube den Remote-Zugriff, wie im vorherigen Rezept beschrieben.

## Wie es geht…

In diesem Rezept werden wir ein paar Imageoperationen wie folgt betrachten:

1.Um Bilder aufzulisten, verwenden Sie die folgende API:

`GET /images/json`

Hier ist ein Beispiel für die vorhergehende Syntax:

`$ curl http://dockerhost.example.com:2375/images/json | python -m json.tool`

2.Um ein Bild zu erstellen, verwenden Sie die folgende API:

`POST /images/create`

Hier einige Beispiele:

* Holen Sie sich das Fedora-Bild von Docker Hub:

```s
curl -X POST
http://dockerhost.example.com:2375/images/create?fromImage=fedora
```

* Holen Sie sich das WordPress-Bild mit dem neuesten Tag:

```s
curl -X POST
http://dockerhost.example.com:2375/images/create?fromImage=wordpress&tag=latest
```

* Erstellen Sie ein Image aus der tar-Datei, die auf dem zugänglichen Webserver gehostet wird:

```s
curl -X POST
http://dockerhost.example.com:2375/images/create?fromSrc=http://localhost/image.tar
```

3.Um ein Image zu erstellen, verwenden Sie die folgende API:

`POST /commit`

Hier einige Beispiele:

* Erstellen Sie ein Bild aus dem Container (`container id = 704a7c71f77d`)

```s
curl -X POST
http://dockerhost.example.com:2375/commit?container=704a7c71f77d
```

* Build eines Images von einer Docker file:

```s
curl -X POST  -H "Content-type:application/tar" --data-binary '@/tmp/Dockerfile.tar.gz'  
http://dockerhost.example.com:2375/build?t=apache
```

Da die API den Inhalt als tar-Datei erwartet, müssen wir die Docker-Datei in eine tar datei umwandeln  und die API anrufen.

4.Um ein Bild zu löschen, verwenden Sie die folgende API:

`DELETE  /images/<name>`

Hier ist ein Beispiel für die vorhergehende Syntax:

```s
curl -X DELETE
http://dockerhost.example.com:2375/images/wordpress:3.9.1
```

### Wie es funktioniert…

In allen oben erwähnten Fällen werden die APIs mit dem Docker-Daemon verbunden und führen die angeforderten Operationen aus.

### Es gibt mehr…

Wir haben nicht alle Optionen der oben diskutierten APIs abgedeckt und Docker stellt APIs für andere Imagebezogene Operationen zur Verfügung. Weitere Informationen finden Sie in der API-Dokumentation.

### Siehe auch

Jeder API-Endpunkt kann unterschiedliche Eingaben zur Steuerung der Operationen haben. Weitere Informationen finden Sie in der Dokumentation auf der [Docker-Website](https://docs.docker.com/reference/api/docker_remote_api_v1.18/#22-images).
