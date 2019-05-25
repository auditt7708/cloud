Wie wir in der früheren Rezeptur gesehen haben, wenn SELinux konfiguriert ist, kann ein nichtprivilegierter Container nicht auf Dateien auf dem Volume zugreifen, das nach der Montage des Verzeichnisses aus dem Host-System erstellt wurde. Allerdings ist es manchmal erforderlich, den Zugriff auf Host-Dateien aus dem Container zu ermöglichen. In diesem Rezept sehen wir, wie man den Zugang in solchen Fällen erlaubt.
Fertig werden

Ein Fedora / RHEL / CentOS Host mit der neuesten Version von Docker installiert, die über einen Docker Client zugegriffen werden kann. Außerdem ist SELinux auf den Durchsetzungsmodus eingestellt und der Docker-Daemon ist für die Verwendung von SELinux konfiguriert.

### Wie es geht…

Montieren Sie die Lautstärke mit der Option `z` oder `Z` wie folgt:
```
$ docker run -it -v /tmp/:/tmp/host:z docker.io/fedora bash
$ docker run -it -v /tmp/:/tmp/host:Z docker.io/fedora bash

```
mkdir ~/dir1
docker run -it -v ~/dir1/:/dir1:z docker.io/fedora bash
touch /dir1/file
```


### Wie es funktioniert…

Während des Mountens  der Volumes, wird Docker neu Labeln um auf die Volumes, um den Zugriff zu ermöglichen.

Die `z`-Option teilt dem Docker mit, dass der Volumeninhalt zwischen Containern geteilt wird. Docker wird den Inhalt mit einem freigegebenen Content-Label Labeln. Die gemeinsamen Labels erlauben es allen Containern, Inhalte zu ermöglichen zu lesen/schreiben. Die `Z`-Option teilt Docker mit, dass der Inhalt mit einem privaten, ungeteilten Label beschriftet wird. Private Volumes können nur vom aktuellen Container genutzt werden.

### Siehe auch

* Der Abschnitt "Volume" finden Sie unter http://opensource.com/business/14/9/security-for-docker