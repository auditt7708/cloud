Zum Nutzen von Containern können wir problemlos neue Programme veröffentlichen, indem wir das neueste Bild ausführen und die Kopfschmerzen der Umgebungseinstellung reduzieren. Aber was ist mit der Veröffentlichung des Programms auf laufenden Containern? Mit nativen Docker-Befehlen müssen wir die laufenden Container vor dem Booten neuer mit den neuesten Bildern und den gleichen Konfigurationen stoppen. Es gibt eine einfache und effiziente Null-Downtime-Methode, um Ihr Programm im Kubernetes-System zu aktualisieren. Es heißt Rolling-Update. Wir werden Ihnen diese Lösung in diesem Rezept zeigen.

### Fertig werden

Rolling-Update funktioniert auf den Einheiten des Replikationscontrollers. Der Effekt ist, neue Pods eins nach dem anderen zu schaffen, um das alte zu ersetzen. Die neuen Pods im Zielreplikationscontroller sind den Originaletiketten beigefügt. Wenn also ein Service diesen Replikationscontroller ausführt, übernimmt er die neu erstellten Pods direkt.

Für eine spätere Demonstration werden wir ein neues Nginx-Image aktualisieren. Darüber hinaus werden wir sicherstellen, dass die Knoten Ihr angepasstes Bild erhalten, uploaded(push) es an Docker Hub, die öffentliche Docker-Registrierung oder private Registry.

Zum Beispiel können Sie das Image erstellen, indem Sie Ihre eigene `Dockerfile` schreiben:
```
$ cat Dockerfile
FROM nginx
RUN echo "Happy Programming!" > /usr/share/nginx/html/index.html
```

In diesem Docker-Image haben wir den Inhalt der Standard-index.html Seite geändert. Dann können Sie Ihr Image aufbauen und es mit den folgenden Befehlen uploaden(push):
```
// push to Docker Hub
$ docker build -t <DOCKERHUB_ACCOUNT>/common-nginx . && docker push <DOCKERHUB_ACCOUNT>/common-nginx
// Or, you can also push to your private docker registry
$ docker build -t <RESITRY_NAME>/common-nginx . && docker push <RESITRY_NAME>/common-nginx

```
Um die Zugriffs-Authentifizierungen der Nodes der privaten Docker-Registrierung hinzuzufügen, nehmen Sie bitte das Arbeiten mit dem privaten Docker-Registrierungsrezept in [Einrichten einer Continuous Delivery Pipeline](../kubernetes-cd-pipline) als Referenz.

### Wie es geht…

Sie lernen jetzt, wie man ein Docker-Bild veröffentlicht. Die folgenden Schritte helfen Ihnen, ein Docker-Image erfolgreich zu veröffentlichen:

1. Am Anfang erstellen Sie ein Paar Replikations-Controller und einen Service für Rolling-Update-Tests. Wie in der folgenden Anweisung gezeigt, wird ein Replikations-Controller mit fünf Repliken erstellt. Das nginx-Programm gibt den Port 80 auf dem Container frei, während der Kubernetes-Service den Port auf `8080` im internen Netzwerk überträgt:
```
// Create a replication controller named nginx-rc
# kubectl run nginx-rc --image=nginx --replicas=5 --port=80 --labels="User=Amy,App=Web,State=Testing"
replicationcontroller "nginx-rc" created
// Create a service supporting nginx-rc
# kubectl expose rc nginx-rc --port=8080 --target-port=80 --name="nginx-service"
service "nginx-service" exposed
# kubectl get service nginx-service
NAME            CLUSTER_IP       EXTERNAL_IP   PORT(S)    SELECTOR                         AGE
nginx-service   192.168.163.46   <none>        8080/TCP   App=Web,State=Testing,User=Amy   35s
```
Sie können prüfen, ob die Komponenten gut funktionieren oder nicht, indem Sie `<POD_IP>:80` und `<CLUSTER_IP>:8080` untersuchen.

2. Gut jetzt sind wir bereit, um auf den Container-Update-Schritt zu gehen! Das Unterkommando `rolling-update` von Kubernetes hilft, den Live-Replikations-Controller auf dem neuesten Stand zu halten. Im folgenden Befehl müssen die Benutzer den Namen des replication controller und das neue Image angeben. Hier werden wir das Image verwenden, das auf Docker Hub hochgeladen wird:
```
# kubectl rolling-update nginx-rc --image=<DOCKERHUB_ACCOUNT>/common-nginx
Created nginx-rc-b6610813702bab5ad49d4aadd2e5b375
Scaling up nginx-rc-b6610813702bab5ad49d4aadd2e5b375 from 0 to 5, scaling down nginx-rc from 5 to 0 (keep 5 pods available, don't exceed 6 pods)
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 1

```

3. Sie können sehen, dass der Prozess hängt. Weil `rolling-update` eine einzelne neue Pod zur Zeit starten kann und auf ein zeitfenster wartet; Die Voreinstellung ist eine Minute, um einen alten Pod zu stoppen und einen zweiten neuen Pod zu erstellen. In diesem fall, ist während der Aktualisierung, da ist immer noch ein Pod auf dem Serving, ein weiterer Pod als der gewünschte Zustand des replication controller. In diesem Fall gäbe es sechs Pods. Beim Aktualisieren des replication controller greifen Sie bitte auf ein anderes Terminal für einen neuen Prozess zu.

4. Überprüfen Sie den Zustand des replication controller auf weitere Konzepte:
```
# kubectl get rc
CONTROLLER                                  CONTAINER(S)      IMAGE(S)                                                   SELECTOR                                                                     REPLICAS   AGE
nginx-rc                                    nginx-rc          nginx                                                      App=Web,State=Testing,User=Amy,deployment=313da350dea9227b89b4f0340699a388   5          1m
nginx-rc-b6610813702bab5ad49d4aadd2e5b375   nginx-rc          <DOCKERHUB_ACCOUNT>/common-nginx                                         App=Web,State=Testing,User=Amy,deployment=b6610813702bab5ad49d4aadd2e5b375   1          16s
```

5. Wie Sie heraus finden werden, erstellt das System einen fast identischen replication controller mit einem Postfixnamen. Eine neue Label schlüssel `deployment` wird den replication controller hinzugefügt, um sie zu unterscheiden. Auf der anderen Seite ist ein neues `nginx-rc` an den anderen Original labels angebracht. Der Service kümmert sich auch um die neuen Pods zur gleichen Zeit:
```
// Check service nginx-service while updating
# kubectl describe service nginx-service
Name:      nginx-service
Namespace:    default
Labels:      App=Web,State=Testing,User=Amy
Selector:    App=Web,State=Testing,User=Amy
Type:      ClusterIP
IP:      192.168.163.46
Port:      <unnamed>  8080/TCP
Endpoints:    192.168.15.5:80,192.168.15.6:80,192.168.15.7:80 + 3 more...
Session Affinity:  None
No events.
```
Es gibt sechs Endpunkte von Pods, die von nginx-service abgedeckt werden, was durch die Definition von Rolling-Update unterstützt wird.

6. Gehen Sie zurück zur Konsole, die den Aktualisierungsvorgang ausführt. Nachdem Sie das Update abgeschlossen haben, können Sie wie folgt vorgehen:
```
Created nginx-rc-b6610813702bab5ad49d4aadd2e5b375
Scaling up nginx-rc-b6610813702bab5ad49d4aadd2e5b375 from 0 to 5, scaling down nginx-rc from 5 to 0 (keep 5 pods available, don't exceed 6 pods)
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 1
Scaling nginx-rc down to 4
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 2
Scaling nginx-rc down to 3
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 3
Scaling nginx-rc down to 2
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 4
Scaling nginx-rc down to 1
Scaling nginx-rc-b6610813702bab5ad49d4aadd2e5b375 up to 5
Scaling nginx-rc down to 0
Update succeeded. Deleting old controller: nginx-rc
Renaming nginx-rc-b6610813702bab5ad49d4aadd2e5b375 to nginx-rc
replicationcontroller "nginx-rc" rolling updated
```
Der alte `nginx-rc` wird allmählich außer Betrieb gesetzt.

7. In den letzten Schritten des Updates wird der neue replication controller auf fünf Pods skaliert, um den gewünschten Zustand zu erfüllen und den alten zu ersetzen:
```
// Take a look a current replication controller
// The new label "deployment" is remained after update
# kubectl get rc nginx-rc
CONTROLLER   CONTAINER(S)   IMAGE(S)             SELECTOR                                                                     REPLICAS   AGE
nginx-rc     nginx-rc       <DOCKERHUB_ACCOUNT>/common-nginx   App=Web,State=Testing,User=Amy,deployment=b6610813702bab5ad49d4aadd2e5b375   5          40s
```

8. Checking Service mit ClusterIP und Port, können wir jetzt alle unsere Pods in dem Replikation Controller aktualisieren:
```
# curl 192.168.163.46:8080
Happy Programming!
```

9. Nach der bisherigen Demonstration kostet es etwa fünf Minuten, ein neues Docker-Bild zu veröffentlichen. Es liegt daran, dass die Aktualisierungszeit standardmäßig auf eine Minute eingestellt ist, um die Prozedur der Skalierung nach oben und unten zu starten. Es ist möglich für Sie, ein schnelleres oder langsameres Tempo des Updates zu haben, indem Sie auf dem Tag `--update-period` zurück greifen. Die gültigen Zeiteinheiten sind `ns`, `us`, `ms`, `s`, `m` und `h`. Zum Beispiel `--update-period=1m0s`:
```
// Try on this one!
# kubectl rolling-update <REPLICATION_CONTROLLER_NAME> --image=<IMAGE_NAME> --update-period=10s
```

### Wie es funktioniert…

In diesem Abschnitt diskutieren wir das Rolling-Update im Detail. Wie wäre es mit der Erneuerung eines replication controller mit N Sekunden als Aktualisierungszeitraum? Siehe folgendes Bild:

![live-updates](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_01.jpg)

Das vorherige Bild zeigt jeden Schritt des Aktualisierungsvorgangs an. Wir können einige wichtige Ideen vom Rolling-Update bekommen:

* Jeder Pod in beiden Replikations-Controller hat ein neues Label, aber einen ungleichen Wert, um den Unterschied aufzuzeigen. Außerdem sind die anderen Labels gleich, so dass der Service auch die replications controller durch Selektoren während der Aktualisierung abdecken kann.

* Wir würden **# pod in Replikation Controller * update period** Zeit sparen bei Migration einer neuen Konfiguration.

* Bei der Null-Downtime-Aktualisierung sollte die Gesamtzahl der vom Dienst abgedeckten Pods den gewünschten Zustand erfüllen. Zum Beispiel, im vorigen Bild, sollte es immer drei Pods laufen zu einer Zeit für den Service.

* Rolling-Update-Verfahren versichert den Benutzern nicht, wann der neu erstellte Pod in **HAPPY-RC- <HashKey2>** im laufenden Zustand ist. Deshalb brauchen wir einen Aktualisierungszeitraum. Nach einer gewissen Zeit, **N** Sekunden im vorigen Fall, sollte ein neuer Pod bereit sein, an die Stelle eines alten Pod zu treten. Dann ist es gut, eine alte Pod zu beenden.

* Die Zeit der Aktualisierungszeit sollte der schlechteste Fall die Zeit sein, die von einem neuen Pod benötigt wird, um ein Image zum Laufen zu downloaden.

### Es gibt mehr…

Während des Rolling-Updates können wir das Image für einen neuen replication controller angeben. Aber manchmal können wir das neue Iamge nicht erfolgreich aktualisieren. Es ist wegen der Container-Image-Pull-policy.

Um mit einem bestimmten Image zu aktualisieren, wird es großartig sein, wenn Benutzer ein Tag anbieten, damit die Version des Images gezeichnet werden soll, ist klar und genau. Allerdings ist die meiste Zeit, die latest, auf die Benutzer suchen und die mit latest Tagged Image könnte als das gleiche in der lokalen Installation betrachtet werden, da sie auch mit latest genannt werden. Wie der Befehl `<DOCKERHUB_ACCOUNT>/common-nginx:latest image` wird in diesem Update verwendet:
`# kubectl rolling-update nginx-rc --image=<DOCKERHUB_ACCOUNT>/common-nginx --update-period=10s`

Dennoch werden die Knoten ignorieren, um die neueste Version von `common-nginx` zu ziehen, wenn sie ein Bild finden, das als dieselbe Anforderung gekennzeichnet ist. Aus diesem Grund müssen wir sicherstellen, dass das angegebene Bild immer aus der Registry gezogen wird.

Um die Konfiguration zu ändern, kann die Unterbefehlsbearbeitung `edit` auf diese Weise helfen:

`# kubectl edit rc <REPLICATION_CONTROLLER_NAME>`

Anschließend können Sie die Konfiguration des replication controller im YAML-Format bearbeiten. Die policy des Image **pulling** konnte in der folgenden Klassenstruktur gefunden werden:
```
apiVersion: v1
kind: replicationcontroller
spec: 
  template:
    spec:
      containers:
      - name: <CONTAINER_NAME>
        image: <IMAGE_TAG>
                 imagePullPolicy: IfNotPresent
:
```

Der Wert `IfNotPresent` teilt dem Knoten mit, das nur auf dem lokalen Datenträger nicht dargestellte Image zu Laden(pull). Durch das Ändern der Richtlinie auf `Always` können Benutzer in der Lage sein, den fehler zu vermeiden. Es ist praktisch, den Schlüsselwert in der Konfigurationsdatei einzurichten. So ist das angegebene Image garantiert dasjenige in der Image registrierung.