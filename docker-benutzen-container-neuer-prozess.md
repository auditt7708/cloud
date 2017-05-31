Bei der Entwicklung und dem Debugging möchten wir vielleicht in den bereits laufenden Container schauen. Es gibt ein paar Dienstprogramme wie z. B. `nsenter` (https://github.com/jpetazzo/nsenter), die es uns erlauben, in den Namespace des Containers einzutreten, um ihn zu inspizieren. Mit der `exec`-Option, die in Docker 1.3 hinzugefügt wurde, können wir einen neuen Prozess in einem laufenden Container einspritzen.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen. Sie können auch einen laufenden Container benötigen, um einen Prozess zu injizieren.

### Wie es geht…

1. Sie können einen Prozess in einem laufenden Container mit folgendem Befehl einspritzen:
` $ docker exec [-d|--detach[=false]] [--help] [-i|--interactive[=false]] [-t|--tty[=false]] CONTAINER COMMAND [ARG...]`

2. Lass uns einen `nginx`-Container anfangen und dann in diesen `bash` einfügen:
```
$ ID='docker run -d nginx'
$ docker run -it $ID bash
```

### Wie es funktioniert…

Der Befehl exec tritt in den Namespace des Containers ein und startet den neuen Prozess.