Linux teilt die Privilegien, die traditionell mit Superuser verbunden sind, in verschiedene Einheiten, bekannt als Fähigkeiten (Run `man capabilities` auf einem Linux-basierten System), die unabhängig aktiviert und deaktiviert werden können. Zum Beispiel ermöglicht die `net_bind_service` Funktion, dass nonuser-Prozesse den Port unter 1.024 binden können. Standardmäßig startet Docker Container mit eingeschränkten Funktionen. Mit privilegiertem Zugriff innerhalb des Containers geben wir mehr Fähigkeiten, um Operationen durchzuführen, die normalerweise von root ausgeführt werden. Zum Beispiel wollen wir versuchen, ein Loopback-Gerät zu erstellen, während ein Disk-Image installiert wird.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Verwenden Sie den folgenden Befehl, um den privilegierten Modus zu verwenden:
`$ docker run --privileged [ OPTIONS ]  IMAGE[:TAG]  [COMMAND]  [ARG...] `

2. Nun wollen wir das vorhergehende Beispiel mit dem privilegierten Zugriff versuchen:
`$ docker run  --privileged  -i -t fedora /bin/bash`

Wie es funktioniert…

Durch die Bereitstellung fast aller Fähigkeiten innerhalb des Containers.

### Es gibt mehr…

Dieser Modus verursacht Sicherheitsrisiken, da Container den Root-Level-Zugriff auf den Docker-Host erhalten können. Mit Docker 1.2 oder neu wurden zwei neue Flaggen `--cap-add` und `--cap-del` hinzugefügt, um feinkörnige Kontrolle in einem Container zu geben. Um zum Beispiel in dem Container `chown` zu verhindern, verwenden Sie den folgenden Befehl:

$ Docker run --cap-drop = CHOWN [OPTIONEN] IMAGE [: TAG] [COMMAND] [ARG ...]

Sehen Sie [Docker Sicherheit](../docker-sicherheit) für weitere Details.