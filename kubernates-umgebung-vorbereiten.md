Bevor wir auf die Reise des eigenen Clusters gehen, müssen wir die Umgebung vorbereiten, um folgende Komponenten zu bauen:
![schema-kubernates](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_04.jpg)

Es gibt verschiedene Lösungen für die Schaffung eines solchen Kubernetes-Clusters, zum Beispiel:

> * Local-Machine-Lösungen, die Folgendes beinhalten:
>
>> * Docker-basierte
>>
>> * Vagrant
>>
>> * Linux-Maschine
>
> * Hosted Lösung, die beinhaltet:
>
>>
>> * Google Container Engine
>>
>
> * Kundenspezifische Lösungen
>


Eine lokale Maschinenlösung eignet sich, wenn wir nur eine Entwicklungsumgebung aufbauen oder den Durchführung des Konzepts schnell machen wollen. Durch die Verwendung von **Docker** (https://www.docker.com) oder **Vagrant** (https://www.vagrantup.com) konnten wir ganz einfach die gewünschte Umgebung in einer einzigen Maschine bauen; Allerdings ist es nicht praktisch, wenn wir eine Produktionsumgebung aufbauen wollen. Eine gehostete Lösung ist der einfachste Ausgangspunkt, wenn wir es in der Cloud bauen wollen.

**Google Container Engine**, die seit vielen Jahren von Google verwendet wurde, hat natürlich die umfangreiche  Unterstützung  und wir brauchen nicht viel über die Installation und Einstellung zu sorgen. Kubernetes können auch auf verschiedenen Cloud- und VM-VMs nach kundenspezifischen Lösungen laufen. Wir werden in den folgenden Kapiteln die Kubernetes-Cluster von Grund auf auf Linux-basierten virtuellen Maschinen (CentOS 7.1) aufbauen. Die Lösung eignet sich für alle Linux-Rechner in Cloud- und On-Premise-Umgebungen.

### Fertig werden

Es wird empfohlen, wenn Sie mindestens vier Linux-Server für Master, etcd und zwei Nodes haben. Wenn Sie es als Hochverfügbarkeits-Cluster erstellen möchten, werden mehr Server für jede Komponente bevorzugt. Wir werden in den folgenden Abschnitten drei Arten von Servern erstellen:

* Kubernetes master

* Kubernetes node

* etcd

Flannel befindet sich nicht in einer Maschine, die in allen Nodes benötigt wird. Die Kommunikation zwischen Containern und Diensten erfolgt durch Flanell, das ist ein etcd Backend Overlay Netzwerk für Container.

### Hardware-Ressource

Die Hardware-Spezifikation jeder Komponente wird in der folgenden Tabelle vorgeschlagen. Bitte beachten Sie, dass es zu einer längeren Reaktionszeit bei der Manipulation des Clusters kommen kann, wenn die Anzahl der Anfragen zwischen dem API-Server und dem Betriebssystem groß ist. In einer normalen Situation können zunehmende Ressourcen dieses Problem lösen:

|Compunente | Kubernates master|etcd|
| :---: | :---: | :---: |
|CPU Anzahl|1|1|
|RAM GB|2G|2G|
