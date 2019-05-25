Wir brauchen ein Bild, um den Container zu starten. Mal sehen, wie wir Bilder auf der Docker-Registrierung durchsuchen können. Wie wir in [Einleitung und Installation](../docker-einleitung-und-Installation) gesehen haben, hält ein Registry die Docker-Bilder und es kann sowohl öffentlich als auch privat sein. Standardmäßig wird die Suche auf der Standard-Public Registry, die Docker Hub genannt wird, geschehen und befindet sich unter https://hub.docker.com/.
Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

1. Um ein Bild auf einer Docker-Registrierung zu durchsuchen, führen Sie den folgenden Befehl aus:
`docker search TERM`

Das folgende ist ein Beispiel, um ein Fedora-Bild zu durchsuchen:

`$ docker search fedora |  head -n5`

Der vorherige Screenshot listet den Namen, die Beschreibung und die Anzahl der Sterne auf, die dem Bild zugewiesen wurden. Es zeigt auch, ob das Bild offiziell und automatisiert ist oder nicht. `STARS` bedeutet, wie viele Leute das gegebene Bild mochten. Die `OFFICIAL`-Spalte hilft uns zu identifizieren, ob das Bild aus einer vertrauenswürdigen Quelle aufgebaut ist oder nicht. Die `AUTOMATED`-Spalte ist ein Weg, um zu ermitteln, ob ein Bild automatisch mit Push in GitHub oder Bitbucket Repositories gebaut wird. Weitere Details zu `AUTOMATED` finden Sie im nächsten Kapitel.

### Tip
Die Konvention für Bildname ist `<user> / <name>`, aber es kann alles sein.

### Wie es funktioniert…

Docker sucht nach Bildern auf der Docker Public Registry, die ein Repository für Bilder unter https://registry.hub.docker.com/ hat.

Wir können auch unseren privaten Index konfigurieren, den er suchen kann.

### Es gibt mehr…
* Um die Bilder aufzulisten, die mehr als 20 Sterne bekommen und automatisiert sind, führen Sie den folgenden Befehl aus:
`$ docker search -s 20 --automated fedora`

In [Arbeiten mit Docker Images](../docker-arbeiten-mit-docker-images), werden wir sehen, wie man automatisierte Builds einrichtet.

* Von Docker 1.3 an wird die Option `--insecure-registry` zum Docker-Daemon bereitgestellt, die es uns ermöglicht, Bilder aus einer unsicheren Registry zu durchsuchen / zu platzieren / zu verknüpfen. Weitere Informationen finden Sie unter https://docs.docker.com/reference/commandline/cli/#insecure-registries.

* The Docker package on RHEL 7 and Fedora provides options to add and block the registry with the `--add-registry` and `--block-registry` options respectively, to have better control over the image search path. For more details, look at the following links:

* http://rhelblog.redhat.com/2015/04/15/understanding-the-changes-to-docker-search-and-docker-pull-in-red-hat-enterprise-linux-7-1/
* https://github.com/docker/docker/pull/10411

