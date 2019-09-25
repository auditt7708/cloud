# Kubernates Konzepte: Services

Der Netzwerkdienst ist eine Anwendung, die Anfragen empfängt und eine Lösung bietet. Clients greifen über eine Netzwerkverbindung auf den Service zu. Sie müssen die Architektur des Dienstes nicht kennen oder wie es läuft. Das einzige, was die Kunden zu überprüfen haben, ist, ob der Endpunkt des Dienstes kontaktierbar ist, und folgen Sie dann seiner Nutzungsrichtlinie, um Probleme zu lösen. Der Kubernetes Service hat ähnliche Ideen. Es ist nicht notwendig, jeden Pod zu verstehen, bevor er ihre Funktionalitäten erreicht. Für Komponenten außerhalb des Kubernetes-Systems greifen sie nur auf den Kubernetes-Service mit einem exponierten Netzwerkanschluss zu, um mit laufenden Pods zu kommunizieren. Es ist nicht notwendig, sich der IPs und ports der Container bewusst zu sein. Deshalb können wir für unsere Containerprogramme ein Null-Downtime-Update erfüllen, ohne zu schwierigkeiten:

![rep-con-service-pods](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_02.jpg)

Das vorangehende Bild zeigt die Grundstruktur des Dienstes und realisiert folgende Konzepte:

* Wie beim replication controller leitet der Service die Pods, die Labels mit dem Selektor des Servers enthalten. Mit anderen Worten, die von der Dienstleistung ausgewählten Pods basieren auf ihren Labels.

* Die Belastung der an die Dienste gesendeten Anfragen verteilt sich auf vier Pods.

* Der replication controller stellt sicher, dass die Anzahl der laufenden Pods den gewünschten Zustand erfüllt. Es überwacht die Pods für den Service, um sicherzustellen, dass jemand die Aufgaben aus dem Dienst übernimmt.

In diesem Rezept, werden Sie lernen, wie man Dienstleistungen zusammen mit Ihren Pods zu schaffen.

## Fertig werden

Vor dem Anwenden von Diensten ist es wichtig zu prüfen, ob alle Ihre Nodes im System `kube-proxy` betreiben. Daemon `kube-proxy` arbeitet als Netzwerk-Proxy im Knoten. Es hilft, Service-Einstellungen wie IPs oder Ports auf jedem Knoten zu reflektieren. Um zu überprüfen, ob der `kube-Proxy` aktiviert ist oder nicht, können Sie den Status des Daemons oder die laufenden Prozesse auf dem Knoten mit einem bestimmten Namen überprüfen:

```sh
// check the status of service kube-proxy
# service kube-proxy status
```

oder

```sh
// Check processes on each node, and focus on kube-proxy
// grep "kube-proxy" or "hyperkube proxy"
# ps aux | grep "kube-proxy"
```

Zur Demonstration in späteren Abschnitten können Sie auch eine private Netzwerkumgebung auf dem Masterknoten installieren. Die Dämonen, die sich auf die Netzwerkeinstellungen beziehen, sind `flanneld` und `kube-proxy`. Es ist einfacher für Sie, die Operation und Überprüfung auf einer einzigen Maschine durchzuführen. Andernfalls überprüfen Sie bitte Kubernetes-Dienste auf einem Node, der standardmäßig ein internes Netzwerk bereits hat.

### Wie es geht…

Wir können einen neuen Kubernetes-Service über die CLI oder eine Konfigurationsdatei definieren und erstellen. Hier wird erklärt, wie man die Dienste mit Befehlen einsetzt. Die Unterbefehle `expose` und `describe` werden in den folgenden Befehlen für verschiedene Szenarien verwendet. Die Version von Kubernetes, die wir in diesem Rezept verwenden, ist 1.1.3. Für die Erstellung von Dateiformaten gehen Sie bitte auf die Bearbeitung von Konfigurationsdateien [Spielen mit Containern](../kubernetes-container) für eine ausführliche Diskussion.

Bei der Erstellung von Diensten gibt es zwei Konfigurationen, bei denen wir auf folgendes achten müssen: Eines ist das Label, das andere ist der Pod. Wie das folgende Bild zeigt, hat der Service und die Pod ihre eigenen Key-Value-Label und Ports. Seien Sie sicher, die korrekten Tags für diese Einstellungen zu verwenden:
![create-service](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_03.jpg)

Um einen solchen Dienst zu erstellen, geben Sie den folgenden Befehl ein:

```sh
# kubectl expose pod <POD_NAME> --labels="Name=Amy-log-service" --selector="App=LogParser,Owner=Amy" --port=8080 --target-port=80
```

Das `--labels` Tag `expose` im Unterkomando ist für die Kennzeichnung der Dienste mit Schlüsselwertpaaren. Es wird verwendet, um die Dienste zu markieren. Um den Selektor des Dienstes zu definieren, verwenden Sie den Tag `--selector`. Ohne den Selektor für den Dienst einzustellen, wäre der Selektor derselbe wie die Labels der Ressource. Im vorigen Bild hätte der Selektor ein Zusatzetikett: **Version=1.0**.

Um den Service-Port freizugeben, senden wir eine Portnummer mit dem Tag `--port` im Unterbefehl aus. Der Dienst nimmt die Container-Portnummer als exponierter Port, wenn keine bestimmte Nummer zugewiesen ist. Auf der anderen Seite zeigt das Tag `--target-Port` den Container-Port für den Service an. Während sich der Zielport von dem exponierten Port des Containers unterscheidet, erhält der Benutzer eine leere Antwort. Zur gleichen Zeit, wenn wir nur den Service-Port zuordnen, wird der Ziel-Port kopiert. Wenn man das vorhergehende image als Beispiel nimmt, wird der Verkehr auf den Container-Port `8080` gerichtet, vorausgesetzt, wir verwenden nicht das Tag `--target-port`, was einen verweigerten Verbindungsfehler hervorbringt.

### Erstellen von Diensten für verschiedene Ressourcen

Sie können einen Dienst an einen Pod, einen replication controller  und einen Endpunkt außerhalb des Kubernetes-Systems oder einen anderen Dienst anhängen. Wir zeigen Ihnen diese, eins nach dem anderen, auf den nächsten Seiten.
Die Diensterstellung ist im Format: `kubectl expose RESOURCE_TYPE RESOURCE_NAME [TAGS]` oder `kubectl expose -f CONFIGURATION_FILE [TAGS]`. Einfach ausgedrückt, die Ressourcentypen pod, Replikationscontroller und Service werden vom Unterbefehl `expose` unterstützt. So ist die Konfigurationsdatei, die der Typbegrenzung folgt.

### Erstellen eines Dienstes für eine Pod

Die Pods, die durch den Service abgeschirmt sind, müssen Labels enthalten, denn der Service nimmt dies als notwendige Bedingung auf der Grundlage des Selektors:

```sh
// Create a pod, and add labels to it for the selector of service.
# kubectl run nginx-pod --image=nginx --port=80 --restart="Never" --labels="app=nginx"
pod "nginx-pod" created
# kubectl expose pod nginx-pod --port=8000 --target-port=80 --name="service-pod"
service "service-pod" exposed
```

> Tip
> Die Abkürzung von Kubernetes Ressourcen
>
> Bei der Verwaltung von Ressourcen über CLI können Sie ihre Abkürzungen anstelle der vollständigen Namen eingeben,
> um Zeit zu sparen und Tippfehler zu vermeiden.

|Resourcen typ|alias Abkürzung|
|Component stati|`cs`|
|Events|`ev`|
|Endpoints|`ep`|
|Horizontalpodautoscaler|`hpa`|
|Limitranges|`limits`|
|Nodes|`no`|
|Namespaces|`ns`|
|Pods|`po`|
|Persistentvolumes|`pvs`|
|Persistentvolumesclaims|`qotas`|
|Resourcequotas|`rc`|
|Replicationcontrollers|`svc`|
|Services|`svc`|
|Ingress|`inc`|

```sh
// "svc" is the abbreviation of service
# kubectl get svc service-pod
NAME          CLUSTER_IP        EXTERNAL_IP   PORT(S)    SELECTOR    AGE
service-pod   192.168.195.195   <none>        8000/TCP   app=nginx   11s
```

Wie Sie in diesen Befehlen sehen, öffnen wir einen Service mit Port `8000`. Der Grund, warum wir den Container-Port angeben, ist weil, dass der Service `8000` nicht als Container-Port übernimmt. Um zu überprüfen, ob der Dienst funktionsfähig ist oder nicht, gehen Sie mit dem folgenden Befehl in einer internen Netzwerkumgebung (die mit dem Kubernetes-Cluster CIDR installiert wurde) wie folgt vor.

```sh
// accessing by services CLUSTER_IP and PORT
# curl 192.168.195.195:8000
```

### Erstellen eines Dienstes für den Replikationscontroller und Hinzufügen einer externen IP

Ein Replikationscontroller ist der ideale Ressourcentyp für einen Service. Für Pods, die von der Replikationssteuerung überwacht werden, verfügt das Kubernetes-System über einen Controller-Manager, um den Lebenszyklus von ihnen zu betrachten. Es ist auch hilfreich für die Aktualisierung der Version oder des Status des Programms durch die Bindung bestehender Dienste an einen anderen Replikations-Controller:

```sh
// Create a replication controller with container port 80 exposed
# kubectl run nginx-rc --image=nginx --port=80 --replicas=2
replicationcontroller "nginx-rc" created
# kubectl expose rc nginx-rc --name="service-rc" --external-ip="<USER_SPECIFIED_IP>"
service "service-rc" exposed
```

In diesem Fall können wir den Service mit einer anderen IP-Adresse versorgen, die nicht im Cluster-Netzwerk sein muss. Das Tag `--external-ip` des Unterbefehls `expose` kann diese statische IP-Anforderung realisieren. Beachten Sie, dass die benutzerdefinierte IP-Adresse beispielsweise mit dem Master-Knoten Public IP kontaktiert werden könnte:

```sh
// EXTERNAL_IP has Value shown on
# kubectl get svc service-rc
NAME         CLUSTER_IP      EXTERNAL_IP          PORT(S)     SELECTOR       AGE
service-rc   192.168.126.5   <USER_SPECIFIED_IP>  80/TCP    run=nginx-rc   4s
```

jetzt kann man den service von `192.168.126.5:80` oder `<USER_SPECIFIED_IP>:80` überprüfen :

```sh
// Take a look of service in details
# kubectl describe svc service-rc
Name:      service-rc
Namespace:    default
Labels:      run=nginx-rc
Selector:    run=nginx-rc
Type:      ClusterIP
IP:      192.168.126.5
Port:      <unnamed>  80/TCP
Endpoints:    192.168.45.3:80,192.168.47.2:80
Session Affinity:  None
No events.
```

Sie werden feststellen, dass das Label und der Selektor eines Dienstes der Standard des Replikationscontrollers ist. Darüber hinaus gibt es mehrere Endpunkte, die Repliken des Replikationscontrollers sind, die für den Umgang mit Anfragen aus dem Dienst verfügbar sind.
Erstellen eines No-Selector-Dienstes für einen Endpunkt

Zuerst sollten Sie einen Endpunkt mit einer IP-Adresse haben. Zum Beispiel können wir einen einzelnen Container in einer Instanz erzeugen, wo er sich außerhalb unseres Kubernetes-Systems befindet, aber noch kontaktierbar ist:

```sh
// Create an nginx server on another instance with IP address <FOREIGN_IP>
# docker run -d -p 80:80 nginx
2a17909eca39a543ca46213839fc5f47c4b5c78083f0b067b2df334013f62002
# docker ps
CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS              PORTS                         NAMES
2a17909eca39        nginx                                  "nginx -g 'daemon off"   21 seconds ago      Up 20 seconds       0.0.0.0:80->80/tcp, 443/tcp   goofy_brown
```

Dann können wir im Master einen Kubernetes Endpunkt erstellen, indem wir die Konfigurationsdatei verwenden. Der Endpunkt heißt `service-foreign-ep`. Wir konnten mehrere IP-Adressen und Ports in der Vorlage konfigurieren:

```sh
# cat nginx-ep.json
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "service-foreign-ep"
    },
    "subsets": [
        {
            "addresses": [
                { "ip": "<FOREIGN_IP>" }
            ],
            "ports": [
                { "port": 80 }
            ]
        }
    ]
}
# kubectl create -f nginx-ep.json
endpoints "service-foreign-ep" created
# kubectl get ep service-foreign-ep
NAME                    ENDPOINTS                         AGE
service-foreign-ep      <FOREIGN_IP>:80                   16s
```

Wie im vorherigen Abschnitt erwähnt, können wir einen Service für eine Ressourcen-konfigurierte Vorlage mit dem Unterbefehl `expose`. Allerdings kann die CLI nicht in der Lage sein, einen Endpunkt im Dateiformat auszusetzen:

```sh
// Give it a try!
# kubectl expose -f nginx-ep.json
error: invalid resource provided: Endpoints, only a replication controller, service or pod is accepted
```

Deshalb erstellen wir den Service über eine Konfigurationsdatei:

```sh
# cat service-ep.json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "service-foreign-ep"
    },
    "spec": {
        "ports": [
            {
                "protocol": "TCP",
                "port": 80,
                   "targetPort" : 80
            }
        ]
    }
}
```

Das Wichtigste ist, dass in der Vorlage kein Selektor definiert ist. Das ist zu empfehlen, da die Endpunkte nicht im Kubernetes-System sind. Die Beziehung zwischen Endpunkten und Service wirden durch Ressourcenname aufgebaut. Wie Sie sehen können, muss der Name des Dienstes mit dem Namen des Endpunkts identisch sein:

```sh
# kubectl create -f service-ep.json
service "service-foreign-ep" created
// Check the details in service
# kubectl describe svc service-foreign-ep
Name:      service-ep
Namespace:    default
Labels:      <none>
Selector:    <none>
Type:      ClusterIP
IP:      192.168.234.21
Port:      <unnamed>  80/TCP
Endpoints:    <FOREIGN_IP>:80
Session Affinity:  None
No events.
```

Schließlich wird der no-selector-Dienst für den externen Endpunkt angelegt. Überprüfen Sie das Ergebnis mit <FOREIGN_IP>: 80.

### Erstellen eines Dienstes mit sessin affinität basierend auf einem anderen Dienst

Durch den Unterbefehl `expose` wir auch die Einstellungen eines Dienstes auf einen anderen kopieren:

```sh
// Check the service we created for replication controller in previous section
# kubectl describe svc service-rc
Name:      service-rc
Namespace:    default
Labels:      run=nginx-rc
Selector:    run=nginx-rc
Type:      ClusterIP
IP:      192.168.126.5
Port:      <unnamed>  80/TCP
Endpoints:    192.168.45.3:80,192.168.47.2:80
Session Affinity:  None
No events.
//Create a new service with different name and service port
# kubectl expose svc service-rc --port=8080 --target-port=80 --name=service-2nd --session-affinity="ClientIP"
service "service-2nd" exposed
```

Der neue Service namens `service-2nd` wird mit Service Port `8080` zurückgesetzt und Session Affinity ist aktiviert:

```sh
# kubectl describe svc service-2nd
Name:      service-2nd
Namespace:    default
Labels:      run=nginx-rc
Selector:    run=nginx-rc
Type:      ClusterIP
IP:      192.168.129.65
Port:      <unnamed>  8080/TCP
Endpoints:    192.168.45.3:80,192.168.47.2:80
Session Affinity:  ClientIP
No events.
```

Derzeit ist das `ClientIP` die einzige verfügbare Einstellung für den Tag `--session-affinity`. Während die Session-Affinität zum `ClientIP` aktiviert ist, wird statt des Round-Robins die Anforderung, von welcher Endpunkt der Service gesendet werden soll, vom `ClientIP` entschieden. Wenn zum Beispiel die Anfragen vom Client im CIDR-Bereich `192.168.45.0/24`an den Service-Service-2 gesendet werden, werden sie auf den Endpunkt `192.168.45.3:80` übertragen.

### Erstellen eines Dienstes in einem anderen Typ

Es gibt drei Arten von Service: **ClusterIP**, **NodePort** und **LoadBalancer**:
![service-different-type](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_04.jpg)

```sh
// Create a service with type NodePort, attaching to the replication controller we created before
# kubectl expose rc nginx-rc --name=service-nodeport --type="NodePort"
service "service-nodeport" exposed
# kubectl describe svc service-nodeport
Name:      service-nodeport
Namespace:    default
Labels:      run=nginx-rc
Selector:    run=nginx-rc
Type:      NodePort
IP:      192.168.57.90
Port:      <unnamed>  80/TCP
NodePort:    <unnamed>  31841/TCP
Endpoints:    192.168.45.3:80,192.168.47.2:80
Session Affinity:  None
No events.
```

Im vorherigen Fall wird der Netzwerkanschluss `31841`, der auf einem Node exponiert ist, zufällig vom System zugewiesen; Der Standard-Port-Bereich ist `30000` bis `32767`. Beachten Sie, dass der Port auf jedem Knoten im System ausgesetzt ist, also ist es gut, auf den Service über `<NODE_IP>:31841` zuzugreifen, zum Beispiel über den Domain-Namen eines Knotens wie `kube-node1:31841`

### Löschen eines Dienstes

Sie können einfach mit dem Unterbefehl löschen, in Fällen, in denen Sie einen Dienst beenden möchten:

```sh
# kubectl delete svc <SERVICE_NAME>
service "<SERVICE_NAME>" deleted
```

### Wie es funktioniert…

Die Hauptdarsteller im Kubernetes-System, die die Serviceumgebung durchführen, sind `flanneld` und `kube-proxy`. Daemon `flanneld` baut ein Cluster-Netzwerk auf, indem es eine Subnet-Lease aus einem vorkonfigurierten Adressraum zuteilt und die Netzwerkkonfiguration in `etcd` speichert, während der `kube-proxy` die Endpunkte von Diensten und Pods leitet.