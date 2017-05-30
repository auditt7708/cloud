Zuvor in diesem Kapitel haben wir gesehen, wie man den Docker-Daemon konfiguriert, um Remote-Verbindungen zu akzeptieren. Doch mit dem Ansatz, den wir folgten, kann jeder mit unserem Docker-Dämon verbinden. Wir können unsere Verbindung mit Transport Layer Security (http://de.wikipedia.org/wiki/Transport_Layer_Security) sichern.

Wir können TLS entweder mit der vorhandenen Certificate Authority (CA) oder durch die Erstellung unserer eigenen konfigurieren. Zur Vereinfachung werden wir unsere eigenen schaffen, die für die Produktion nicht empfohlen werden. Für dieses Beispiel gehen wir davon aus, dass der Host, der den Docker-Daemon ausführt, dockerhost.example.com ist.

### Fertig werden

Stellen Sie sicher, dass die openssl-Bibliothek installiert ist.

### Wie es geht...

1. Erstellen Sie ein Verzeichnis auf Ihrem Host, um unsere CA und andere verwandte Dateien:
```
$ mkdirc-p /etc/docker
$ cd  /etc/docker
```

2. Erstellen Sie die privaten und öffentlichen Schlüssel der CA:
```
$ openssl genrsa -aes256 -out ca-key.pem 2048 
$ openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem 
```

3. Nun, lassen Sie uns die Server-Taste und Zertifikat Signierung Anfrage. Stellen Sie sicher, dass `Common Name` mit dem Hostname des Docker-Daemon-Systems übereinstimmt. In unserem Fall ist es `dockerhost.example.com`.
```
$ openssl genrsa -out server-key.pem 2048 
$ openssl req -subj "/CN=dockerhost.example.com" -new -key server-key.pem -out server.csr 
```

4. Um Verbindungen von 127.0.0.1 und einen bestimmten Host zu ermöglichen, z. B. 10.70.1.67, erstellen Sie eine Erweiterungskonfigurationsdatei und unterzeichnen den öffentlichen Schlüssel mit unserer CA:
```
$ echo subjectAltName = IP:10.70.1.67,IP:127.0.0.1 > extfile.cnf 
$ openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem    -CAcreateserial -out server-cert.pem -extfile extfile.cnf 
```

5. Für die Clientauthentifizierung erstellen Sie einen Clientschlüssel und eine Zertifikatsignierungsanforderung:
```
$ openssl genrsa -out key.pem 2048 
$ openssl req -subj '/CN=client' -new -key key.pem -out client.csr 
```

6. Um den Schlüssel für die Client-Authentifizierung geeignet zu machen, erstellen Sie eine Erweiterungs-Konfigurationsdatei und unterzeichnen den öffentlichen Schlüssel:
```
$ echo extendedKeyUsage = clientAuth > extfile_client.cnf 
$ openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem  -CAcreateserial -out cert.pem -extfile_client.cnf 
```
7. Nach der Erstellung von cert.pem und server-cert.pem können wir die Zertifikatsignierungsanforderungen sicher entfernen:
`$ rm -rf client.csr server.csr `

8. Um die Sicherheit zu schützen und die Schlüssel vor versehentlichem Schaden zu schützen, ändern wir die Berechtigungen:
`$ chmod -v 0600 ca-key.pem key.pem server-key.pem ca.pem server-cert.pem cert.pem`

9. Stoppen Sie den Dämon, wenn es auf `dockerhost.example.com` läuft. Dann starten Sie den Docker-Daemon manuell aus `/etc/docker`:
```
$ pwd
   /etc/docker
    $ docker -d --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem    --tlskey=server-key.pem   -H=0.0.0.0:2376 
```

10. Von einem anderen Terminal aus gehen Sie zu `/etc/docker`. Führen Sie den folgenden Befehl aus, um eine Verbindung zum Docker-Daemon herzustellen:
```
$ cd /etc/docker
$ docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=127.0.0.1:2376 version
```

Sie werden sehen, dass eine TLS-Verbindung aufgebaut ist und Sie die Befehle über sie ausführen können. Sie können auch den CA-öffentlichen Schlüssel und das TLS-Zertifikat des Clients eingeben und den `.docker`-Ordner im Home-Verzeichnis des Benutzers eingeben und die Umgebungsvariablen `DOCKER_HOST` und `DOCKER_TLS_VERIFY` verwenden, um eine sichere Verbindung standardmäßig herzustellen.

11. Um eine Verbindung von dem entfernten Host herzustellen, den wir bei der Signierung des Serverschlüssels mit unserer CA erwähnt haben, müssen wir den öffentlichen CA-Schlüssel und das TLS-Zertifikat des Clients und den Schlüssel auf den Remotecomputer kopieren und dann mit dem Docker-Host verbinden, wie im vorherigen Screenshot gezeigt.

### Wie es funktioniert…

Wir setzen die TLS-Verbindung zwischen dem Docker-Daemon und dem Client für eine sichere Kommunikation ein.

### Es gibt mehr…

* Um den Docker-Daemon einzurichten, um mit der TLS-Konfiguration standardmäßig zu beginnen, müssen wir die Docker-Konfigurationsdatei aktualisieren. Zum Beispiel, auf Fedora, aktualisierst du den `OPTIONS`-Parameter wie folgt in `/etc/sysconfig/docker`:
```
OPTIONS='--selinux-enabled -H tcp://0.0.0.0:2376 --tlsverify     --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem' 
```

* Wenn Sie sich erinnern, in  Einführung und Installation, haben wir gesehen, wie wir den Docker-Host mit der Docker-Maschine (http://docs.docker.com/machine/) und als Teil dieses Setups das TLS-Setup einrichten können Passiert zwischen dem Client und dem Host, auf dem der Docker-Daemon läuft. Nach dem Konfigurieren des Docker-Hosts mit der Docker-Maschine, überprüfen Sie den `.docker/maschine` für den Benutzer auf dem Client-System.