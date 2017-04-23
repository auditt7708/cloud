Kubernetes ist ein Open-Source-Container-Management-Tool. Es ist ein Go-Lang-basierte (https://golang.org), leichte und tragbare Anwendung. Sie können einen Kubernetes-Cluster auf einem Linux-basierten Betriebssystem einrichten, um die Docker-Container-Anwendungen auf mehreren Hosts zu implementieren, zu verwalten und zu skalieren.

### Fertig werden

Kubernetes wird mit mehreren Komponenten wie folgt konstruiert:

* Kubernetes Meister

* Kubernetes-Nodes

* ctcd

* Overlay-Netzwerk (flannel)

Diese Komponenten sind über das Netzwerk verbunden, wie im folgenden Screenshot gezeigt:

![diagram-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_01.jpg)

Das vorangehende Bild lässt sich wie folgt zusammenfassen:

* **Kubernetes Master** verbindet sich mit **etcd** über HTTP oder HTTPS, um die Daten zu speichern. Es verbindet auch **flanell**, um auf die Containeranwendung zuzugreifen.

* Kubernetes-Nodes verbinden sich mit dem **Kubernetes-Master** über HTTP oder HTTPS, um einen Befehl zu erhalten und den Status zu melden.

* Kubernetes-Nodes verwenden ein Overlay-Netzwerk (z. B. **flanell**), um eine Verbindung zu ihren Containeranwendungen herzustellen.

### Wie es geht…

In diesem Abschnitt werden wir die Eigenschaften von Kubernetes Meister und Nodes erklären; Beide erkennen die Hauptfunktionen des Kubernetes-Systems.

### Kubernetes Meister

Kubernetes-Master ist die Hauptkomponente des Kubernetes-Clusters. Es dient mehreren Funktionalitäten, wie die folgenden Elemente:

* Autorisierung und Authentifizierung

* RESTful API Einstiegspunkt

* Container-Deployment-Scheduler zu den Kubernetes-Nodes

* Skalierung und Replikation des Controllers

* Lesen und speichern Sie die Konfiguration

* Befehlszeilenschnittstelle

Das nächste Bild zeigt, wie Master-Dämonen zusammengearbeitet haben, um die genannten Funktionalitäten zu erfüllen:
![master-controller](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_02.jpg)

Es gibt mehrere Daemon-Prozesse, die die Funktionalität des Kubernetes-Masters wie **kube-apiserver**, **kube-scheduler** und **kube-controller-manager**. Hypercube Wrapper startet alle von ihnen.

Darüber hinaus kann die Kubernetes Command Line Interface `kubectl` die Kubernetes Master Funktionalität steuern.

### API-Server (kube-apiserver)

Der API-Server stellt eine HTTP- oder HTTPS-basierte RESTful API bereit, die der Hub zwischen Kubernetes-Komponenten wie kubectl, Scheduler, replication controller, etcd datastore und kubelet und kube-proxy ist, der auf Kubernetes-Nodes läuft und so weiter.

### Scheduler (kube-scheduler)

Scheduler hilft, zu wählen, welcher Container von welchen Knoten ausgeführt wird. Es ist ein einfacher Algorithmus, der die Priorität zum Versand und Binden von Containern an Nodes definiert, zum Beispiel:

* CPU

* Memory

* Wieviele container sind am Laufen


### Controller Manager (kube-controller-manager)

Controller Manager führt Cluster-Operationen durch. Beispielsweise:

* Verwaltet Kuvernetes-Knoten

* Erstellt und aktualisiert die internen Informationen von Kubernetes

* Versucht, den aktuellen Status in den gewünschten Status zu ändern

* Befehlszeilenschnittstelle (kubectl)

Nach der Installation von Kubernetes Master können Sie mit dem Kubernetes Command Line Interface kubectl den Kubernetes Cluster steuern. Zum Beispiel gibt kubectl cs den Status jeder Komponente zurück. Auch kubectl bekommt nodes gibt eine Liste der Kubernetes-Knoten zurück: