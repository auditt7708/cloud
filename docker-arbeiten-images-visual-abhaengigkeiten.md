Wenn die Anzahl der Images wächst, wird es schwierig, eine Beziehung zwischen ihnen zu finden. Es gibt ein paar Dienstprogramme, für die Sie die Beziehung zwischen den Images finden können.

### Fertig werden

Ein oder mehrere Docker-Images auf dem Host, auf dem der Docker-Daemon läuft.

### Wie es geht…

1. Führen Sie den folgenden Befehl aus, um eine baumartige Ansicht der Bilder zu erhalten:
`$ docker images -t `

### Wie es funktioniert…

Die Abhängigkeiten zwischen den Ebenen werden aus den Metadaten der Docker-Images abgerufen.

### Es gibt mehr…

Von `--viz` bis `docker Images`, können wir Abhängigkeiten grafisch sehen ; Um dies zu tun, müssen Sie das grafische Paket installiert haben:
```
$ docker images --viz | dot -Tpng -o /tmp/docker.png
$ display /tmp/docker.png
```

Wie die Warnung sagt, die beim Ausführen der vorhergehenden Befehle auftritt, können die Optionen `-t` und `--viz` bald veraltet sein.

### Siehe auch

Das folgende Projekt versucht, Docker-Daten zu visualisieren, indem sie rohe JSON-Ausgabe von Docker https://github.com/justone/dockviz verwenden