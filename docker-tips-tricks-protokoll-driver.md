Mit dem Release von Docker 1.6 wurde eine neue Funktion hinzugefügt, um den Logging-Treiber beim Starten des Docker-Daemons auszuwählen. Derzeit werden drei Arten von Logging-Treibern unterstützt:

* none

* Json-file (default)

* syslog

### Fertig werden

Installiere Docker 1.6 oder höher auf dem System.

### Wie es geht…

1. Starten Sie den Docker-Daemon mit dem erforderlichen Logging-Treiber wie folgt:
```
$ docker -d --log-driver=none
$ docker -d --log-driver=syslog
```

Sie können diese Option auch in der Konfigurationsdatei des Dockers hinzufügen, abhängig von der distribution.

Der Befehl `docker logs `unterstützt nur die Standardprotokollierungs-Treiber-JSON-Datei.

Wie es funktioniert…

Abhängig von der Protokolltreiberkonfiguration wählt der Docker-Daemon den entsprechenden Protokolltreiber aus.

Es gibt mehr…

Es ist Arbeit im Gange, um `journald` als einen der Logging-Treiber hinzuzufügen. Es wird von Docker 1.7 unter http://www.projectatomic.io/blog/2015/04/logging-docker-container-output-to-journald/ verfügbar sein.
Siehe auch

     Die Dokumentation auf der Docker-Website http://docs.docker.com/reference/run/#logging-drivers-log-driver