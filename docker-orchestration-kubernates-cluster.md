Kubernetes ist ein Open-Source-Container-Orchestrierungswerkzeug über mehrere Nodes im Cluster. Derzeit unterstützt es nur Docker. Es wurde von Google gestartet, und jetzt sind Entwickler von anderen Firmen dazu gekommen. Es bietet Mechanismen für application deployment, Terminierung, Aktualisierung, Wartung und Skalierung. Kubernetes 'Auto-Placement, Auto-Neustart, Auto-Replikation Features stellen sicher, dass der gewünschte Zustand der Anwendung beibehalten wird, die durch den Benutzer definiert sind. Benutzer definieren Anwendungen über YAML- oder JSON-Dateien, die wir später im Rezept sehen werden. Diese YAML- und JSON-Dateien enthalten auch die API-Version (das Feld `apiVersion`), um das Schema zu identifizieren. Das folgende Bild ist das architektonische Diagramm von Kubernetes:

![diagram-kubernates](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_15.jpg)

https://raw.githubusercontent.com/GoogleCloudPlatform/kubernetes/master/docs/architecture.png

Schauen wir uns einige der wichtigsten Komponenten und Konzepte von Kubernetes an.

> * **Pods**: Eine Pod, die aus einem oder mehreren Containern besteht, ist die Deployment Unit von Kubernetes. Jeder Container in einem Pod teilt verschiedene Namespaces mit anderen Containern in der gleichen Pod. Zum Beispiel hat jeder Container in einem Pod den gleichen Netzwerk-Namespace, was bedeutet, dass sie alle über localhost kommunizieren können.

> * **Node/Minion**: Ein Knoten, der früher als Minion bekannt war, ist ein Worker knoten im Kubernetes-Cluster und wird über Master verwaltet. Pods werden auf einem Knoten bereitgestellt, der die notwendigen Dienste hat, um sie auszuführen:
>
>> * Docker, um Container auszuführen
>>
>> * Kubelet, um mit meister zu interagieren
>>
>> * Proxy (kube-Proxy), der den Service mit dem entsprechenden Pod verbindet
>>
>
> * **Master**: Master beherbergt Cluster-Level-Control-Services wie die folgenden:
>
>> 
>> * API-Server: Dies hat RESTful APIs, um mit Master und Knoten zu interagieren. Dies ist die einzige Komponente, die mit der etcd-Instanz spricht.
>>
>> * Scheduler: Dies plant Aufträge in Clustern, wie z. B. das Erstellen von Pods auf Knoten.
>> 
>> * Replikations-Controller: Damit wird sichergestellt, dass die benutzerdefinierte Anzahl von Pod-Repliken zu einem beliebigen Zeitpunkt ausgeführt wird. Um Replikate mit dem Replikationscontroller zu verwalten, müssen wir eine Konfigurationsdatei mit der Replikatzahl für einen Pod definieren.
>>
>
> Master kommuniziert auch mit etcd, was ein verteiltes Schlüsselwertpaar ist. Etcd wird verwendet, um die Konfigurationsinformationen zu speichern, die sowohl von Master als auch von Knoten verwendet werden. Die Watch-Funktionalität von etcd wird verwendet, um die Änderungen im Cluster zu benachrichtigen. Etcd kann auf Master oder auf einem anderen Satz von Systemen gehostet werden.
>
