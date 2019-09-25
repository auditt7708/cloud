Kubernetes hat einen Scheduler, um den Container dem rechten Knoten zuzuordnen. Darüber hinaus können Sie leicht skalieren und skalieren die Anzahl der Container. Die Kubernetes-Skalierungsfunktion führt den replication controller aus, um die Anzahl der Container anzupassen.

### Fertig werden

Bereiten Sie die folgende YAML-Datei vor, die ein einfacher replication controller ist, um zwei Nginx-Container zu starten. Außerdem wird der Dienst den TCP-Port `30080` frei geben:

```
# cat nginx-rc-svc.yaml
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
```

###### Tip
`NodePort` wird alle Kubernetes-Knoten binden; Stellen Sie daher sicher, dass `NodePort` nicht von anderen Prozessen verwendet wird.


Verwenden Sie den Befehl `kubectl`, um Ressourcen wie folgt zu erstellen:
```
# kubectl create -f nginx-service.yaml
replicationcontroller "my-nginx" created
service "my-nginx" created
```

Warten Sie einen Moment, um zwei Nginx-Container wie folgt vollständig zu starten:
```
# kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
my-nginx-iarzy   1/1       Running   0          7m
my-nginx-ulkvh   1/1       Running   0          7m

# kubectl get services
NAME         CLUSTER_IP       EXTERNAL_IP   PORT(S)   SELECTOR          AGE
kubernetes   192.168.0.1      <none>        443/TCP   <none>            44d
my-nginx     192.168.95.244   nodes         80/TCP    sel=my-selector   7m

```

### Wie es geht…

Kubernetes hat einen Befehl, der die Anzahl der Replikate für den Dienst ändert:

1. Geben Sie den Befehl `kubectl scale` wie folgt ein, um die gewünschten Repliken anzugeben:
```
# kubectl scale --replicas=4 rc my-nginx
replicationcontroller "my-nginx" scaled
```
Dieses Beispiel zeigt an, dass der replication controller, der mit dem Namen `my-nginx` bezeichnet wird, die Repliken auf `4` ändert.

2. Geben Sie `kubectl get pods` ein, um das Ergebnis wie folgt zu überprüfen:
```
# kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
my-nginx-iarzy   1/1       Running   0          20m
my-nginx-r5lnq   1/1       Running   0          1m
my-nginx-uhe8r   1/1       Running   0          1m
my-nginx-ulkvh   1/1       Running   0          20m
```

### Wie es funktioniert…

Das `kubectl scale `kann die Anzahl der Repliken ändern; Nicht nur erhöhen, sondern auch abnehmen. Zum Beispiel können Sie zurück zu zwei Repliken wie folgt ändern:
```
# kubectl scale --replicas=2 rc my-nginx
replicationcontroller "my-nginx" scaled

# kubectl get pods
NAME             READY     STATUS        RESTARTS   AGE
my-nginx-iarzy   0/1       Terminating   0          40m
my-nginx-r5lnq   1/1       Running       0          21m
my-nginx-uhe8r   1/1       Running       0          21m
my-nginx-ulkvh   0/1       Terminating   0          40m
# kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
my-nginx-r5lnq   1/1       Running   0          25m
my-nginx-uhe8r   1/1       Running   0          25m

```
Es gibt eine Option `--current-replicas`, die die erwarteten aktuellen Repliken spezifiziert. Wenn es nicht übereinstimmt, führt Kubernetes die skalierungs funktion nicht wie folgt aus:
```
//abort scaling, because current replica is 2, not 3
# kubectl scale --current-replicas=3 --replicas=4
rc my-nginx
Expected replicas to be 3, was 2

# kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
my-nginx-r5lnq   1/1       Running   0          27m
my-nginx-uhe8r   1/1       Running   0          27m
```
Es wird helfen, menschliche Fehler zu verhindern. 
Standardmäßig ist `--current-replicas` gleich `-1`, was bedeutet eine umleitung bedeutet, um die aktuelle Anzahl von Repliken zu überprüfen:
```
//no matter current number of replicas, performs to change to 4
# kubectl scale --current-replicas=-1 --replicas=4
 rc my-nginx
replicationcontroller "my-nginx" scaled

# kubectl get pods
NAME             READY     STATUS    RESTARTS   AGE
my-nginx-dimxj   1/1       Running   0          5s
my-nginx-eem3a   1/1       Running   0          5s
my-nginx-r5lnq   1/1       Running   0          35m
my-nginx-uhe8r   1/1       Running   0          35m
```
