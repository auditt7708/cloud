# Docker arbeiten mit Images: Images

In diesem Kapitel werden wir uns auf die Bilder konzentrieren. Wie wir wissen, sind Bilder erforderlich, um Container zu führen. Sie können entweder vorhandene Bilder verwenden oder neue benutzerdefinierte Bilder erstellen. Sie müssen benutzerdefinierte Bilder erstellen, um Ihre Entwicklungs- und Bereitstellungsumgebung anzupassen. Sobald Sie ein Bild erstellen, können Sie es über die öffentliche oder private Registrierung zu teilen. Bevor wir mehr über Docker-Bilder erforschen, schauen wir uns die Ausgabe des `docker info`-Befehls an:

* Es hat 21 Behälter und 21 Bilder.

Der aktuelle Speicher-Treiber, `devicemapper` und seine damit zusammenhängenden Informationen, wie zB Dünn-Pool-Namen, Daten, Metadaten-Datei und so weiter. Andere Arten von Speicher-Treiber sind aufs, btrfs, overlayfs, vfs, und so weiter. Devicemapper, btrfs und overlayfs haben native Unterstützung im Linux-Kernel. Die AUFS-Unterstützung benötigt einen gepatchten Kernel.

* Um die Kernel-Features zu nutzen, die die Containerisierung ermöglichen, muss der Docker-Daemon mit dem Linux-Kernel sprechen. Dies geschieht durch den Ausführungstreiber. `libconatiner` oder `native` ist eine dieser Art. Die anderen sind `libvirt`, `lxc` und so weiter.

* Die Kernel-Version auf dem Host-Betriebssystem.

* Das Benutzerkonto, das in der im nächsten Abschnitt erwähnten Registrierung registriert ist, um Images zu  pull/push platzieren.

## Übersicht

* [Erstellen eines Kontos mit Docker Hub](../docker-arbeiten-images-konto-docker-hub)
* [Erstellen eines Bildes aus dem Container](../docker-arbeiten-images-von-container)
* [Veröffentlichen eines Bildes in der Registry](../docker-arbeiten-images-veroefendlichen)
* [Blick auf die Geschichte eines Images](../docker-arbeiten-images-geschichte)
* [Löschen eines Images](../docker-arbeiten-images-loeschen)
* [Images exportieren](../docker-arbeiten-images-exportieren)
* [Images importieren](../docker-arbeiten-images-importieren)
* [Images mit Dockerfiles erstellen](../docker-arbeiten-images-dockerfiles-build)
* [Erstellen eines Apache-Bildes - ein Dockerfile-Beispiel](../docker-arbeiten-images-apache-dockerfile)
* [Zugriff auf Firefox aus einem Container - ein Dockerfile-Beispiel](../docker-arbeiten-images-firefox-example)
* [Erstellen eines WordPress-Images - ein Dockerfile-Beispiel](../docker-arbeiten-images-wordpress-example)
* [Einrichten eines privaten Index / Registry](../docker-arbeiten-images-private-registry)
* [Automatisierte Builds - mit GitHub und Bitbucket](../docker-arbeiten-images-auto-github-bitbucket)
* [Erstellen des BasisImages - mit Supermin](../docker-arbeiten-images-supermin)
* [Erstellen des BasisImages - Verwenden von Debootstrap](../docker-arbeiten-images-debootstrap)
* [Visualisierung von Abhängigkeiten zwischen Ebenen](../docker-arbeiten-images-visual-abhaengigkeiten)