# Dotainer auflisten

Wir können sowohl laufende als auch gestoppte Container auflisten.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen. Du brauchst auch ein paar laufende und / oder gestoppte Container.

### Wie es geht…

1. Um die Container aufzulisten, führen Sie den folgenden Befehl aus:
`docker ps [ OPTIONS ]`

### Wie es funktioniert…

Der Docker-Daemon kann sich die mit den Containern verbundenen Metadaten anschauen und sie auflisten. Standardmäßig gibt der Befehl zurück:

* Die Container-ID

* Das Bild, aus dem es entstanden ist

* Der Befehl, der nach dem Starten des Containers ausgeführt wurde

* Die Details darüber, wann es geschaffen wurde

* Der aktuelle Status

* Die Häfen, die aus dem Container ausgesetzt sind

* Der Name des Containers

### Es gibt mehr…

* Um sowohl laufende als auch gestoppte Container aufzulisten, verwenden Sie die Option `-a` wie folgt:
`ps -a`

* Um nur die Container-IDs aller Container zurückzugeben, verwenden Sie die Option `-aq` wie folgt:
`ps aq`

* Um den zuletzt erstellten Container einschließlich des nicht laufenden Containers anzuzeigen, führen Sie den folgenden Befehl aus:
`$ docker ps -l`

* Mit der Option `--filter/-f` auf `ps` können wir Container mit bestimmten Labels auflisten. Schauen Sie sich die Beschriftung und Filterung Container Rezept in diesem Kapitel für weitere Details.

