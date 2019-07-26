# Docker Kost Zugriff

Ab Docker 1.2 können wir den Zugriff auf das Host-Gerät auf einen Container mit der Option --device zum Befehl run ausgeben. Früher hat man es mit der Option -v gebunden, und das musste mit der --privilegierten Option gemacht werden.

## Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen. Sie benötigen auch ein Gerät, um zum Container zu gelangen.

## Wie es geht…

1. Sie können den Zugriff auf ein Host-Gerät an den Container über die folgende Syntax geben:

`$ docker run --device=<Host Device>:<Container Device Mapping>:<Permissions>   [ OPTIONS ]  IMAGE[:TAG]  [COMMAND]  [ARG...]`

Hier ist ein Beispiel für einen Befehl:

`$ docker run --device=/dev/sdc:/dev/xvdc -i -t fedora /bin/bash`

### Wie es funktioniert…

Der vorherige Befehl wird in `/dev/sdc` innerhalb des Containers zugreifen.
