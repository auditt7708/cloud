Docker auf einem einzigen Host kann gut für die Entwicklungsumgebung sein, aber der reale Wert kommt, wenn wir mehrere Hosts überspannen. Das ist aber keine leichte Aufgabe. Sie müssen diese Container orchestrieren. Also, in diesem Kapitel werden wir einige der Orchestrierungswerkzeuge und Hosting-Plattformen abdecken.

Docker Inc. hat zwei solche Tools angekündigt:

Docker Compose (https://docs.docker.com/compose), um Apps zu erstellen, die aus mehreren Containern und Docker Swarm (https://docs.docker.com/swarm/) bestehen, um mehrere Docker-Hosts zu gruppieren. Docker Compose wurde zuvor als fig (http://www.fig.sh/) bezeichnet.

CoreOS (https://coreos.com/) erstellt etcd (https://github.com/coreos/etcd) für Konsens und Service Discovery, fleet (https://coreos.com/using-coreos/clustering) zu implementieren von Container in einem Cluster und Flanell (https://github.com/coreos/flannel) für Overlay-Netzwerke.

Google hat Kubernetes (http://kubernetes.io/) für die Docker-Orchestrierung gestartet. 
Kubernetes bietet Mechanismen für Anwendungsbereitstellung, Terminierung, Aktualisierung, Wartung und Skalierung.

Red Hat startete ein Container-spezifisches Betriebssystem namens Project Atomic (http://www.projectatomic.io/), das die Orchestrierungsmöglichkeiten von Kubernetes nutzen kann.

Auch Microsoft kündigte ein spezialisiertes Betriebssystem für Docker an (http://azure.microsoft.com/blog/2015/04/08/microsoft-unveils-new-container-technologies-for-the-next-generation-cloud/).

Apache Mesos (http://mesos.apache.org/), die Ressourcen-Management und Scheduling über ganze Rechenzentrum und Cloud-Umgebungen bietet auch Unterstützung für Docker (http://mesos.apache.org/documentation/latest/docker- Containerizer /).

VMware startete auch den Containerspezifischen Host VMware Photon (http://vmware.github.io/photon/).

Das ist definitiv ein sehr interessanter Raum, aber die Richtlinienmanagement-Tools vieler Orchestrierungsmotoren machen das Leben von Entwicklern und Betreibern nicht einfach. Sie müssen verschiedene Werkzeuge und Formate lernen, wenn sie sich von einer Plattform zur anderen bewegen. Es wäre toll, wenn wir einen Standard haben könnten, um Composite-, Multicontainer-Apps zu erstellen und zu starten. Das Project Atomic Community scheint an einer solchen Plattform-neutralen Spezifikation namens Nulecule (https://github.com/projectatomic/nulecule/) zu arbeiten. Eine gute Beschreibung über Nulecule finden Sie unter http://www.projectatomic.io/blog/2015/05/announcing-the-nulecule-specification-for-composite-applications/:


"Nulecule definiert ein Muster und ein Modell für die Verpackung komplexer Multi-Container-Anwendungen, wobei alle ihre Abhängigkeiten, einschließlich der Orchestrierung von Metadaten, in einem einzigen Container-Image für den Aufbau, die Bereitstellung, Überwachung und aktive Verwaltung. Erstellen Sie einfach einen Container mit einer Nulecule-Datei und die In der Nulecule-Spezifikation definieren Sie Orchestrierungsanbieter, Containerstandorte und Konfigurationsparameter in einem Graphen, und die Atomic App-Implementierung wird sie zusammen mit Ihnen mit Hilfe von Providern zusammenstellen. Die Nulecule-Spezifikation unterstützt die Aggregation von Multiple Composite-Anwendungen, und es ist auch Container und Orchestrierung agnostisch, so dass die Verwendung von Container und Orchestrierung Motor. "

AtomicApp ist eine Referenzimplementierung (https://github.com/projectatomic/atomicapp/) der Nulecule-Spezifikation. Es kann verwendet werden, um Container-Anwendungen zu booten und zu installieren und zu starten. AtomicApp hat derzeit eine begrenzte Anzahl von Anbietern (Docker, Kubernetes, OpenShift), aber die Unterstützung für andere wird bald hinzugefügt.

Auf einer verwandten Notiz baut die CentOS-Community eine CI-Umgebung auf, die Nulecule und AtomicApp nutzen wird. Weitere Informationen finden Sie unter http://wiki.centos.org/ContainerPipeline.

Alle vorangehenden Werkzeuge und Plattformen benötigen für sich selbst separate Kapitel. In diesem Kapitel werden wir Compose, Swarm, CoreOS, Project Atomic und Kubernetes kurz erforschen.

### Übersicht

[Ausführen von Anwendungen mit Docker Compose](../docker-orchestration-compose)

[Cluster mit Docker Swarm einrichten](../docker-orchestration-swarm)

[CoreOS für Docker-Orchestrierung einrichten](../docker-orchestration-coreos)

[Einrichten eines Projektes Atomic Host](../docker-orchestration-atomic-host)

[Atom-Update / Rollback mit Project Atomic durchführen](../docker-orchestration-atomic-update-rollback)

[Hinzufügen von mehr Speicher für Docker in Project Atomic](../docker-orchestration-atomic-speicher)

[Cockpit für Project Atomic einrichten](../docker-orchestration-atomic-cockpit)

[Einrichten eines Kubernetes-Clusters](../docker-orchestration-kubernates-cluster)

[Skalierung auf und ab in einem Kubernetes-Cluster](../docker-orchestration-kubernetes-skalierung)

[Einrichten von WordPress mit einem Kubernetes-Cluster](../docker-orchestration-kubernetes-wordpress-)