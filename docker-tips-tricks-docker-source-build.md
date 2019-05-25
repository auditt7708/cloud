Manchmal wird es notwendig, eine Docker-Binärdatei aus der Quelle zum Testen eines Patches zu erstellen. Es ist sehr einfach, die Docker-Binärdatei aus der Quelle zu bauen.

### Fertig werden

1. Laden Sie den Docker-Quellcode mit `git` herunter:
`$ git clone https://github.com/docker/docker.git`

2. Install `make` auf Fedora
`$ yum install -y make`

3. Vergewissern Sie sich, dass Docker auf dem Host läuft, auf dem Sie den Code erstellen und dass Sie  über den Docker-Client darauf zugreifen können, da der Build, den wir hier besprechen, in einem Container passiert.

### Wie es geht…

1. Gehe in das geklonte Verzeichnis:
`$ cd docker`

2. Führen Sie das `make` kommando aus:
`$ sudo make`

### Wie es funktioniert…

* Dies wird einen Container erstellen und den Code innerhalb des Master-Zweigs kompilieren. Sobald es fertig ist, spuckt es die binären inneren Bündel / <version> / binary aus.

### Es gibt mehr…
* Ähnlich wie beim Quellcode können Sie auch die Dokumentation erstellen:
`$ sudo make docs`

* Sie können auch Tests mit dem folgenden Befehl ausführen:
` $ sudo make test `

### Siehe auch

* Schauen Sie sich die Dokumentation auf der Docker-Website an https://docs.docker.com/contributing/devenvironment/