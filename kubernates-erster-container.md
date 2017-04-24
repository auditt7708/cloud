Glückwünsche! Du hast in den vorherigen Abschnitten deinen eigenen Kubernetes-Cluster aufgebaut. Nun, lasst uns mit dem Ausführen deines ersten Containers nginx (http://nginx.org/) fortfahren, das ist ein Open-Source-Reverse-Proxy-Server, Load Balancer und Web-Server.

### Fertig werden

Bevor wir mit dem ersten Container in Kubernetes beginnen, ist es besser zu prüfen, ob jede Komponente wie erwartet funktioniert. Bitte befolgen Sie diese Schritte auf ihrem Master, um zu überprüfen, ob die Umgebung betriebsbereit ist:

1. Prüfen Sie, ob die Kubernetes-Komponenten laufen:

### Notiz:
Wenn eine der Komponenten nicht läuft, schauen Sie sich die Einstellungen in den vorherigen Abschnitten an. Starten Sie die zugehörigen Dienste neu, z.B. `service kube-apiserver start`.

2- Master status Überprüfen:
```
# Check master is running
$ kubectl cluster-info
Kubernetes master is running at http://localhost:8080
```

### Notiz:
Wenn der Kubernetes master nicht läuft dann starte den service folgendermassen
`service kubernetes-master start` oder `/etc/init.d/kubernetes-master start` .

3. Prüfen, dass alle nodes erreichbar sind:
```
# check nodes are all Ready
$ kubectl get nodes
NAME          LABELS                               STATUS
kub-node1   kubernetes.io/hostname=kub-node1   Ready
kub-node2   kubernetes.io/hostname=kub-node2   Ready
```
### Notiz
Wenn es vorkommen, dass ein Node als `Ready` erkannt wird aber nicht erreichbar ist dann kann es hilfreich sein Docker und den Node service neu zu starten `service docker start` und `service kubernetes-node start`.

Bevor wir zum nächsten Abschnitt gehen, stellen Sie sicher, dass die Nodes für die Docker-Registrierung zugänglich sind. Wir verwenden das nginx Bild von Docker Hub (https://hub.docker.com/) als Beispiel. Wenn du deine eigene Anwendung ausführen möchtest, solltest du es zuerst dockerisieren! Was Sie für Ihre benutzerdefinierte Anwendung tun müssen, ist, eine Dockerfile (https://docs.docker.com/v1.8/reference/builder) zu schreiben, den Build durchführen und in die öffentliche / private Docker-Registrierung kopieren.

### Tip
Testen Sie Ihre Node verbindung mit der öffentlichen / privaten Docker-Registrierung

Auf deinem Knoten versuchet Docker, nginx zu testen, um zu testen, ob du das Image von Docker Hub Downloaden kannst. Wenn du hinter einem Proxy steckst, füge bitte `HTTP_PROXY` in deine Docker-Konfigurationsdatei (normalerweise in `/etc/sysconfig/docker`) ein. Wenn Sie das Image aus dem privaten Repository im Docker Hub ausführen möchten, können Sie die Anmeldeinformationen in `/var/lib/kubelet/.dockercfg `kopieren, indem Sie das Docker-Login auf dem Node verwenden, um Ihre Anmeldeinformationen in `~/.docker/config.json` zu platzieren im Json format und neu starten Docker:
```
# put the credential of docker registry
$ cat /var/lib/kubelet/.dockercfg

{
        "<docker registry endpoint>": {
                "auth": "SAMPLEAUTH=",
                "email": "noreply@sample.com"
        }
}
```
Wenn Sie Ihre eigene private Registrierung verwenden, geben Sie `INSECURE_REGISTRY` in der Docker-Konfigurationsdatei an.

### Wie es geht…

Wir verwenden das offizielle Docker-Image von nginx als Beispiel. Das Image wird im Docker Hub angeboten (https://hub.docker.com/_/nginx/).

Viele offizielle und öffentliche Images sind auf Docker Hub verfügbar,so dass Sie es nicht von Grund auf neu zu bauen müssen. Laden Sie es einfach runter und richten Sie Ihre benutzerdefinierte Einstellung wie beschrieben ein.

### Einen HTTP-Server ausführen (nginx)

1. Auf dem Kubernetes-Meister konnten wir `kubectl run` laufen lassen, um eine bestimmte Anzahl von Containern zu erstellen. Der Kubernetes-Master wird dann die Pods für die zu laufenden Nodes planen:
`$ kubectl run <replication controller name> --image=<image name> --replicas=<number of replicas> [--port=<exposing port>]`

2. Im folgenden Beispiel werden zwei Repliken mit dem Namen `my-first-nginx` aus dem nginx-Image erstellt und der Port `80` frei gegeben. Wir könnten einen oder mehrere Container in einem sogenannten Pod bereitstellen. In diesem Fall werden wir einen Container pro Pod einsetzen. Genau wie ein normale Docker-Umgebung, wenn das nginx-Bild nicht lokal existiert, wird es es aus Docker Hub standardmäßig geladen:
```
# Pull the nginx image and run with 2 replicas, and expose the container port 80
$ kubectl run my-first-nginx --image=nginx --replicas=2 --port=80
CONTROLLER       CONTAINER(S)     IMAGE(S)   SELECTOR             REPLICAS
my-first-nginx   my-first-nginx   nginx      run=my-first-nginx   2
```

### Tip
Der Name des Replikationscontrollers <my-first-nginx> kann nicht dupliziert werden

Die Ressource (Pods, Services, Replikationscontroller usw.) in einem Kubernetes-Namespace kann nicht dupliziert werden. Wenn Sie den vorherigen Befehl zweimal ausführen, wird der folgende Fehler angezeigt:

Fehler vom Server: replikationController "my-first-nginx" existiert bereits.

Lassen Sie sich also nicht verwirren.


3. Lasst uns den aktuellen Status aller Pods mit `kubectl get pods` ausgeben. Normalerweise wird der Status der Pods für eine Weile im `Pending` stehen, da es einige Zeit dauert, bis die Nodes das Bild von Docker Hub gedownloadet haben:

```
# get all pods
$ kubectl get pods
NAME                     READY     STATUS    RESTARTS   AGE
my-first-nginx-nzygc     1/1       Running   0          1m
my-first-nginx-yd84h     1/1       Running   0          1m
```

### Tip

Wenn der Pod-Status für eine lange Zeit nicht läuft

Sie könnten immer `kubectl get pods`, um den aktuellen Status der Pods zu überprüfen und kubectl beschreiben pods $ pod_name, um die detaillierten Informationen eines Pod zu überprüfen. Wenn Sie einen Tippfehler des Bildnamens machen, erhalten Sie möglicherweise die Fehlermeldung des Bildes nicht, und wenn Sie die Bilder aus einem privaten Repository oder einer Registrierung ohne ordnungsgemäße Anmeldeinformationen ziehen, können Sie die `Authentication error` erhalten. Wenn Sie den Status "Ausstehen" für eine lange Zeit erhalten und die Knotenkapazität überprüfen, stellen Sie sicher, dass Sie nicht zu viele Repliken ausführen, die die Knotenkapazität überschreiten, die im Abschnitt "Vorbereiten der Umgebung" beschrieben wurde. Wenn es noch andere unerwartete Fehlermeldungen gibt, kannst du entweder die Pods oder den gesamten Replikationscontroller stoppen, um den Master zu zwingen, die Aufgaben erneut zu planen.