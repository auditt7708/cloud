Wie wir wissen, hat Docker eine Client-Server-Architektur. Wenn wir Docker installieren, starten ein user space Programm und ein Daemon von der gleichen Binärdatei. Der Dämon bindet auf `unix://var/run/docker.sock` standardmäßig auf demselben Host. Dies erlaubt uns nicht, den Dämon remote zugänglich zu machen. Um den Fernzugriff zu ermöglichen, müssen wir den Docker so starten, dass er den Fernzugriff ermöglicht, was durch die entsprechende Änderung der `-H` Flags erfolgen kann.

### Fertig werden

Abhängig von der Linux-Distribution, die Sie ausführen, finden Sie die Docker-Daemon-Konfigurationsdatei, die Sie ändern müssen. Für Fedora,/Red Hat Distributionen wäre es `/etc/sysconfig/docker` und für Ubuntu / Debian Distributionen wäre es wahrscheinlich `/etc/default/docker`.

### Wie es geht…

1. Bei Fedora 20-Systemen füge die Option `-H tcp://0.0.0.0:2375` in der Konfigurationsdatei (`/etc/sysconfig/docker`) wie folgt hinzu:

`OPTIONS=--selinux-enabled -H tcp://0.0.0.0:2375`

2. Starten Sie den Docker-Dienst neu. Führen Sie auf Fedora den folgenden Befehl aus:

`$ sudo systemctl restart docker`

3. Verbinden Sie sich mit dem Docker-Host vom Remote-Client:

`$ docker -H <Docker Host>:2375 info`

Stellen Sie sicher, dass die Firewall den Zugriff auf Port `2375` auf dem System ermöglicht, auf dem der Docker-Daemon installiert ist.

### Wie es funktioniert…

Mit dem vorherigen Befehl haben wir dem Docker-Daemon erlaubt, alle Netzwerkschnittstellen über Port `2375` mit TCP zu hören.

### Es gibt mehr…

* Mit der Kommunikation, die wir früher zwischen dem Client und dem Docker erwähnt haben, ist der Gastgeber unsicher. 
Später in diesem Kapitel sehen wir, wie man TLS zwischen ihnen aktiviert.

* Der Docker CLI sucht nach Umgebungsvariablen; Wenn es gesetzt ist, dann verwendet die CLI diesen Endpunkt, um zB eine Verbindung herzustellen, wie folgt:

`$ export DOCKER_HOST=tcp://dockerhost.example.com:2375`

Dann werden die zukünftigen Docker-Befehle in dieser Sitzung standardmäßig mit dem Remote-Docker-Host verbunden und führen diese aus:

`$ docker info`

### Siehe auch

Die Dokumentation auf der Docker-Website https://docs.docker.com/reference/api/docker_remote_api/