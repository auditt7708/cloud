Wenn Sie beliebige Kubernetes-Objekte wie einen Pod, replication controller und Service erstellen, können Sie ihm einen Namen zuordnen. Die Namen in Kubernetes sind räumlich eindeutig, was bedeutet, dass du den gleichen Namen nicht in den Pods zuweisen kannst.
Fertig werden

Kubernetes erlaubt uns, einen Namen mit folgenden Einschränkungen zuzuordnen:

* maximal 253 characters
* Kleinbuchstaben aus alphabetischen und numerischen Zeichen
* Kann Sonderzeichen in der Mitte enthalten, aber nur Bindestrich (-) und Punkt (.)

### Wie es geht…

Das folgende Beispiel ist die pod-Definition, die den Pod-Namen als `my-pod` zuweist, dem Containernamen  `my-container`, kannst du ihn wie folgt erfolgreich erstellen:
```
# cat my-pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx

# kubectl create -f my-pod.yaml 
pod "my-pod" created

# kubectl get pods
NAME      READY     STATUS    RESTARTS   AGE
my-pod    0/1       Running   0          4s
```
Sie können den Befehl `kubectl describe` eingeben, um den Containernamen `my-container` wie folgt zu sehen:
```
# kubectl describe pod my-pod
Name:        my-pod
Namespace:      default
Image(s):      nginx
Node:        ip-10-96-219-25/10.96.219.25
Start Time:      Wed, 16 Dec 2015 00:46:33 +0000
Labels:        <none>
Status:        Running
Reason:        
Message:      
IP:        192.168.34.35
Replication Controllers:  <none>
Containers:
  my-container:
    Container ID:  docker://5501d115703e334ae44c1541b990a7e22ce4f310226eafea206594e4c85c90d9
    Image:    nginx
    Image ID:    docker://6ffc02088cb870652eca9ccd4c4fb582f75b29af2879792ed09bb46fd1c898ef
    State:    Running
      Started:    Wed, 16 Dec 2015 00:46:34 +0000
    Ready:    True
    Restart Count:  0
    Environment Variables:
```

Auf der anderen Seite enthält das folgende Beispiel zwei Container, weist aber denselben Namen wie `my-container` zu, daher gibt der Befehl `kubectl` einen Fehler zurück und kann den Pod nicht erstellen.
```
//delete previous pods 
# kubectl delete pods --all
pod "my-pod" deleted
# cat duplicate.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  - name: my-container
    image: centos
    command: ["/bin/sh", "-c", "while : ;do curl http://localhost:80/; sleep 3; done"]
# kubectl create -f duplicate.yaml 
The Pod "my-pod" is invalid.
spec.containers[1].name: duplicate value 'my-container'

```

###### Tip
Sie können das `--validate` Flag hinzufügen
Zum Beispiel: `kubectl create -f duplicate.yaml -validate`
Verwenden Sie ein Schema, um die Eingabe zu bestätigen, bevor Sie es senden

In einem anderen Beispiel enthält das YAML einen replication controller und einen Dienst, die beide denselben Namen `my-nginx` verwenden, aber er wird erfolgreich erstellt, da der replication controller und der Dienst unterschiedlich sind:
```
# cat nginx.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-nginx
spec:
  replicas: 2
  selector:
      sel : my-selector
  template:
    metadata:
        labels:
          sel : my-selector
    spec:
      containers:
      - name: my-container
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: my-nginx

spec:
  ports:
    - protocol: TCP
      port: 80
      nodePort: 30080
  type: NodePort
  selector:
     sel: my-selector

# kubectl create -f nginx.yaml 
replicationcontroller "my-nginx" created
service "my-nginx" created

# kubectl get rc
CONTROLLER   CONTAINER(S)   IMAGE(S)   SELECTOR          REPLICAS   AGE
my-nginx     my-container   nginx      sel=my-selector   2          8s

# kubectl get service
NAME         CLUSTER_IP       EXTERNAL_IP   PORT(S)   SELECTOR          AGE
kubernetes   192.168.0.1      <none>        443/TCP   <none>            6d
my-nginx     192.168.38.134   nodes         80/TCP    sel=my-selector   14s
```

### Wie es funktioniert…

Name ist nur eine eindeutige Kennung, alle Namenskonventionen sind gut, aber es wird empfohlen, nachschlagen und identifizieren das Container-Images eine Aussagekräftige benennung zu verwenden.
Beispielsweise:

* memcached-pod1
* haproxy.us-west
* my-project1.mysql

Auf der anderen Seite funktionieren die folgenden Beispiele wegen der Einschränkungen von Kubernetes nicht:

* Memcache-pod1 (beinhaltet einen Großbuschstaben)
* haproxy.us_west (beinhaltet einen unterstrich)
* my-project1.mysql. (Punkt am Ende)

Beachten Sie, dass Kubernetes ein Label unterstützt, das es erlaubt, eine key=value style identifier zuzuweisen. Es erlaubt auch die Vervielfältigung. Wenn Sie also etwas wie die unten stehenden Informationen zuordnen möchten, verwenden Sie stattdessen ein Label:

* environment (Zum Beispiel: staging, production)
* version (Zum Beispiel: v1.2)
* application role (Zum Beispiel: frontend, worker)

Darüber hinaus unterstützt Kubernetes auch Namespaces, um isolierte Namespaces zu haben. Dies bedeutet, dass Sie denselben Namen in verschiedenen Namespaces verwenden können (z.B: nginx). Wenn Sie also nur einen application name zuweisen möchten, verwenden Sie stattdessen Namespaces.

### Siehe auch

In diesem Abschnitt wurde beschrieben, wie Sie den Namen von Objekten zuordnen und finden können. Dies ist nur eine grundlegende Methodik, aber Kubernetes hat leistungsfähigere Namenswerkzeuge wie Namespace und Selektoren, um Cluster zu verwalten:

* Arbeiten mit pods
* Arbeiten mit einem replication controller
* Arbeiten mit Dienstleistungen
* Arbeiten mit Namespaces
* Arbeiten mit Etiketten und Selektoren

