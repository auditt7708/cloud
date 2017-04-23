Wenn wir ein Image erstellen, wird der Docker standardmäßig versuchen, die zwischengespeicherten Ebenen zu verwenden, so dass es weniger Zeit zum Erstellen benötigt. Allerdings ist es manchmal notwendig, von Grund auf neu zu bauen. Zum Beispiel müssen Sie ein System-Update wie yum -y Update erzwingen. Mal sehen, wie wir das in diesem Rezept machen können.

### Fertig werden

Holen Sie sich eine Dockerfile, um das Bild zu bauen.

### Wie es geht…

1. Beim Aufbau des Bildes, ignoire die `--no-cache`-Option wie folgt:
`$ docker build -t test --no-cache - < Dockerfile`

### Wie es funktioniert…

Die Option `--no-cache` wird jede zwischengespeicherte Ebene verwerfen und eine Dockerfile erstellen, indem sie die Anweisungen befolgt.

### Es gibt mehr…

Manchmal wollen wir auch den Cache nach nur wenigen Anweisungen verwerfen. In solchen Fällen können wir beliebigen Befehl hinzufügen, der das Bild nicht beeinflusst, wie z.B. Erstellung oder Einrichtung einer Umgebungsvariablen.