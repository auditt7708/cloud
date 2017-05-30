Wir können die Bilder auf dem System auflisten, auf dem der `docker`-Daemon läuft. Diese Bilder wurden möglicherweise aus der Registry gezogen, durch den Docker-Befehl importiert oder über Docker-Dateien erstellt.
Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Führen Sie den folgenden Befehl aus, um die Images aufzulisten:

`$ docker images`

### Wie es funktioniert…

Der Docker-Client spricht mit dem Docker-Server und bekommt die Liste der Bilder am Server-Ende.

### Es gibt mehr…
* All the images with the same name but different tags get downloaded. The interesting thing to note here is that they have the same name but different tags. Also, there are two different tags for the same `IMAGE ID`, which is `2d24f826cb16`.

* Sie können eine andere Ausgabe für `REPOSITORY` sehen, wie im folgenden Screenshot gezeigt, mit den neuesten Docker-Paketen.

Dies liegt daran, dass die Bildauflistung auch den Docker-Registrierungshostnamen druckt. Wie im vorigen Screenshot gezeigt, ist `docker.io` der Registrierungshostname.

