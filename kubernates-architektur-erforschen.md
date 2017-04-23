Kubernetes ist ein Open-Source-Container-Management-Tool. Es ist ein Go-Lang-basierte (https://golang.org), leichte und tragbare Anwendung. Sie können einen Kubernetes-Cluster auf einem Linux-basierten Betriebssystem einrichten, um die Docker-Container-Anwendungen auf mehreren Hosts zu implementieren, zu verwalten und zu skalieren.

### Fertig werden

Kubernetes wird mit mehreren Komponenten wie folgt konstruiert:

* Kubernetes Meister

* Kubernetes-Knoten

* ctcd

* Overlay-Netzwerk (flannel)

Diese Komponenten sind über das Netzwerk verbunden, wie im folgenden Screenshot gezeigt:

![diagram-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_01.jpg)

Das vorangehende Bild lässt sich wie folgt zusammenfassen:

    Kubernetes Master verbindet sich mit etcd über HTTP oder HTTPS, um die Daten zu speichern. Es verbindet auch Flanell, um auf die Containeranwendung zuzugreifen.

    Kubernetes-Knoten verbinden sich mit dem Kubernetes-Master über HTTP oder HTTPS, um einen Befehl zu erhalten und den Status zu melden.

    Kubernetes-Knoten verwenden ein Overlay-Netzwerk (z. B. Flanell), um eine Verbindung zu ihren Containeranwendungen herzustellen.

### Wie es geht…

In diesem Abschnitt werden wir die Eigenschaften von Kubernetes Meister und Knoten erklären; Beide erkennen die Hauptfunktionen des Kubernetes-Systems.
Kubernetes Meister

Kubernetes-Master ist die Hauptkomponente des Kubernetes-Clusters. Es dient mehreren Funktionalitäten, wie die folgenden Elemente:

    Autorisierung und Authentifizierung

    RESTful API Einstiegspunkt

    Container-Deployment-Scheduler zu den Kubernetes-Knoten

    Skalierung und Replikation des Controllers

    Lesen und speichern Sie die Konfiguration

    Befehlszeilenschnittstelle

Das nächste Bild zeigt, wie Master-Dämonen zusammengearbeitet haben, um die genannten Funktionalitäten zu erfüllen: