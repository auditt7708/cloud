Ich leihe dieses Rezept aus dem nächsten Kapitel, um einige Konzepte vorzustellen. Mach dir keine Sorgen, wenn du nicht die ganze Erklärung in diesem Rezept findest. Wir werden alle Themen im Detail in diesem Kapitel oder in den nächsten Kapiteln abdecken. Jetzt wollen wir ein Bild ziehen und es laufen lassen. Wir werden uns auch mit der Docker-Architektur und ihren Komponenten in diesem Rezept vertraut machen.
Fertig werden

Zugriff auf ein System mit installiertem Docker erhalten.

### Wie es geht…

1. Um ein Bild zu ziehen, führen Sie den folgenden Befehl aus:
`$ docker pull fedora`

2. Auflisten der vorhandenen Bilder mit folgendem Befehl:
`$ docker images`

3.Create a container using the pulled image and list the containers as:
`docker run -id --name f21 docker.io/fedora bash`


### Wie es funktioniert…

Docker hat Client-Server-Architektur. Seine Binärdatei besteht aus dem Docker-Client und Server-Daemon, und es kann sich im selben Host befinden. Der Client kann über Sockets oder die RESTful API entweder einem lokalen oder entfernten Docker-Daemon kommunizieren. Der Docker-Dämon baut, läuft und verteilt Container. Wie im folgenden Diagramm gezeigt, sendet der Docker-Client den Befehl an den Docker-Daemon, der auf dem Hostcomputer läuft. Der Docker-Daemon verbindet sich entweder mit dem öffentlichen oder lokalen Index, um die vom Client angeforderten Bilder zu erhalten:

![docker-client-server](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_13.jpg)
Docker Client-Server-Architektur (https://docs.docker.com/introduction/understanding-docker/)

In unserem Fall sendet der Docker-Client eine Anfrage an den auf dem lokalen System laufenden Daemon, der dann mit dem öffentlichen Docker-Index verbindet und das Bild herunterlädt. Einmal heruntergeladen, können wir es ausführen.

### Es gibt mehr…

Lassen Sie uns einige Schlüsselwörter erforschen, die wir früher in diesem Rezept angetroffen haben:

* Images: Docker Images sind schreibgeschützte Vorlagen und sie geben uns Container zur Laufzeit. Es gibt die Vorstellung von einem Basisbild und Schichten darüber. Zum Beispiel können wir ein Basisbild von Fedora oder Ubuntu haben und dann können wir Pakete installieren oder Änderungen über das Basisbild vornehmen, um eine neue Ebene zu erstellen. Das Basisbild und die neue Ebene können als neues Bild behandelt werden. Zum Beispiel ist in der folgenden Abbildung Debian das Basisbild und Emacs und Apache sind die beiden Ebenen, die oben hinzugefügt werden. Sie sind sehr tragbar und können leicht geteilt werden:
![Docker-Images-leyers](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_01_14.jpg)
Docker Image layers (http://docs.docker.com/terms/images/docker-filesystems-multilayer.png)


Ebenen werden transparent auf das Basisbild gelegt, um ein einziges kohärentes Dateisystem zu erzeugen.

* Registries(Registrierungen): Ein Registry hält Docker Bilder. Es kann öffentlich oder privat sein, von wo aus Sie Bilder herunterladen oder hochladen können. Die öffentliche Docker-Registry heißt Docker Hub, die wir später abdecken werden.

* Index: Ein Index verwaltet Benutzerkonten, Berechtigungen, Suche, Tagging und all das schöne Zeug, das in der öffentlichen Web-Oberfläche der Docker-Registrierung ist.

* Containers: Container laufen Bilder, die durch die Kombination des Basisbildes und der Ebenen darüber erstellt werden. Sie enthalten alles, was benötigt wird, um eine Anwendung auszuführen. Wie im vorigen Diagramm gezeigt, wird auch eine temporäre Ebene hinzugefügt, während der Container gestartet wird, der verworfen würde, wenn er nicht begangen wird, nachdem der Container gestoppt und gelöscht wurde. Wenn begangen, dann würde es eine andere Schicht erstellen.

* Repository: Verschiedene Versionen eines Bildes können von mehreren Tags verwaltet werden, die mit verschiedenen GUID gespeichert werden. Ein Repository ist eine Sammlung von Bildern, die von GUIDs verfolgt werden.


