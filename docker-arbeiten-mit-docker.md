Im vorherigen Kapitel, nach der Installation von Docker, zogen wir ein Bild und erstellt einen Container daraus. Das primäre Ziel von Docker ist es, Container zu führen. In diesem Kapitel sehen wir die verschiedenen Operationen, die wir mit Containern wie Start, Stoppen, Auflistung, Löschen und so weiter machen können. Dies wird uns helfen, Docker für verschiedene Anwendungsfälle wie Testen, CI / CD, Einrichtung von PaaS und so weiter zu verwenden, die wir in späteren Kapiteln abdecken werden. Bevor wir anfangen, überprüfen wir die Docker-Installation, indem wir den folgenden Befehl ausführen:
`$ docker version`


Dies gibt die Docker-Client und Server-Version, sowie andere Details.

Ich benutze Fedora 20/21 als meine primäre Umgebung, um die Rezepte zu führen. Sie sollten auch mit dem anderen Umfeld arbeiten.

### Übersicht

* [nach einem Image Listing / Suchen ](../docker-benutzen-image-listing-suche)
* [Image Pulling](../docker-benutzen-image-pulling)
* [Images auflisten](../docker-benutzen-images-auflisten)
* [Starten eines Containers](../docker-benutzen-container-starten)
* [Listing Container](../docker-benutzen-container-auflisten)
* [Stoppen eines Containers](../docker-benutzen-container-stoppen)
* [Ein Blick auf die Logs der Container](../docker-benutzen-container-logs)
* [Löschen eines Containers](../docker-benutzen-container-loeschen)
* [Festlegen der Neustartrichtlinie auf einem Container](../docker-benutzen-container-regeln-neustart)
* [Privilegierter Zugriff innerhalb eines Containers](../docker-benutzen-container-privilegierter-zugriff)
* [Einen Port Exposing nutzen Wenn Sie einen Container starten](../docker-benutzen-container-exposing-ports)
* [Zugriff auf das Host-Gerät im Container](../docker-benutzen-container-zugriff-host)
* [Injizieren eines neuen Prozesses in einen laufenden Container](../docker-benutzen-container-neuer-prozess)
* [Rückkehr von Low-Level-Informationen über einen Container](../docker-benutzen-container-lowlevel-info)
* [Etikettier- und Filterbehälter](../docker-benutzen-container-labeling-filtering)