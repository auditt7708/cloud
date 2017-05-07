Continuous Delivery ist ein Konzept. Durch die Automatisierung des Tests, der Erstellung und der Bereitstellung kann das Tempo der Software-Veröffentlichung die Zeit zum Markt sein. Es hilft auch bei der Zusammenarbeit zwischen Entwicklern, Operationen und Testern, wodurch Kommunikationsaufwand und Bugs reduziert werden. CD-Pipeline zielt darauf ab, ein zuverlässiger und wiederholbarer Prozess und Werkzeuge für die Bereitstellung von Software zu sein.

Kubernetes ist eines der Ziele in der CD-Pipeline. In diesem Abschnitt wird beschrieben, wie Sie Ihre neue Release-Software in Kubernetes von Jenkins und Kubernetes bereitstellen können.

### Fertig werden

Die Voraussetzung für diesen Abschnitt ist es Jenkins zu kennen. Vor der Einrichtung unserer Continuous Delivery Pipeline mit Kubernetes, sollten wir wissen, was Kubernetes macht. Die Bereitstellung in Kubernetes könnte eine bestimmte Anzahl von Pods und Replikationscontroller-Repliken erzeugen. Wenn eine neue Software freigegeben wird, können Sie dann Updates aktualisieren oder die Pods neu erstellen, die in der Deployment-Konfigurationsdatei aufgeführt sind, mit denen man sicherstellen kann, dass Ihr Service immer leuft .

Genau wie Jobs ist deployment ein Teil der extensions API Gruppe und ist immer noch in der `v1beta`-Version. Um eine deployment ressource zu aktivieren, legen Sie beim Start den folgenden Befehl in der API-Serverkonfiguration fest. Wenn Sie den Server bereits gestartet haben, ändern Sie einfach die Konfigurationsdatei `/etc/kubernetes/apiserver` und starten den `kube-apiserver`-Dienst neu. Bitte beachten Sie, eventuell kann man später die erweiterung normal benutzen und bekommt dann Fehlermeldungen :

`--runtime-config=extensions/v1beta1/deployments=true`

Nachdem der API-Dienst erfolgreich gestartet wurde, konnten wir mit dem Aufbau des Dienstes beginnen und das Beispiel **my-calc** app erstellen. Diese Schritte sind erforderlich, da das Konzept der _Continuous Delivery_ ist, um Ihre Software aus dem Quellcode zu liefern, zu bauen, und zu testen und danach in die gewünschte Umgebung\(Testen ,Productiv oder Entwicklung \) zu bringen. Wir müssen zuerst die Umgebung schaffen.

Sobald wir den ersten `docker push` Befehl in der Docker-Registrierung haben, beginnen wir mit der Erstellung einer Bereitstellung namens `my-calc-deployment`:

```
# cat my-calc-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: my-calc-deployment
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: my-calc
    spec:
      containers:
      - name: my-calc
        image: msfuko/my-calc:1
        ports:
        - containerPort: 5000

// create deployment resource 
# kubectl create -f deployment.yaml
deployment "my-calc-deployment" created
```

Erstellen Sie auch einen Service, um den Port der Außenwelt verfügbar zu machen:

```
# cat deployment-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-calc
spec:
  ports:
    - protocol: TCP
      port: 5000
  type: NodePort
  selector:
     app: my-calc
// create service resource
# kubectl create -f deployment-service.yaml
You have exposed your service on an external port on all nodes in your cluster. If you want to expose this service to the external internet, you may need to set up firewall rules for the service port(s) (tcp:31725) to serve traffic.
service "my-calc" created
```

### Wie es geht…

Um die Pipeline Continuous Delivery einzurichten, führen Sie die folgenden Schritte aus:

1. Zuerst starten wir ein Jenkins-Projekt namens `Deploy-My-Calc-K8S` wie im folgenden Screenshot gezeigt:  
   ![new-jenkins-projekt](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_18.jpg)

2. Dann importiere man die Quellcode-Informationen in den Abschnitt **Source Code Management**:  
   ![source-code-management](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_19.jpg)

3. Als nächstes fügen Sie die Docker-Registrierungsinformationen in das **Docker Build and Publish** in den **Build**-Schritt ein:  
   ![jenkins-docker-biold-bublish](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_20.jpg)

4. Fügen Sie am Ende den Abschnitt **Execute Shell** im Schritt **Build** und legen Sie den folgenden Befehl an:

```
curl -XPUT -d'{"apiVersion":"extensions/v1beta1","kind":"Deployment","metadata":{"name":"my-calc-deployment"},"spec":{"replicas":3,"template":{"metadata":{"labels":{"app":"my-calc"}},"spec":{"containers":[{"name":"my-calc","image":"msfuko/my-calc:${BUILD_NUMBER}","ports":[{"containerPort":5000}]}]}}}}' http://54.153.44.46:8080/apis/extensions/v1beta1/namespaces/default/deployments/my-calc-deployment
```

Lassen Sie uns den Befehl hier erklären; Es ist eigentlich der gleiche Befehl mit der folgenden Konfigurationsdatei, nur mit einem anderen Format und Start-Methode. Einer ist mit der RESTful API, eine ander ist der Befehl `kubectl`.

5. Das  `${BUILD_NUMBER} tag` ist eine Umgebungsvariable in Jenkins, die als aktuelle Imagenummer des Projekts exportiert wird:

```
   apiVersion: extensions/v1beta1
   kind: Deployment
   metadata:
   name: my-calc-deployment
   spec:
   replicas: 3
   template:
    metadata:
      labels:
        app: my-calc
    spec:
      containers:
      - name: my-calc
        image: msfuko/my-calc:${BUILD_NUMBER}
        ports:
         containerPort: 5000
```

6. Nach dem Speichern des Projektes können wir unseren Bau beginnen. Klicken Sie auf **Build Now**. Dann downloadet\(pull\) Jenkins den Quellcode aus deinem Git-Repository, baut und uploaded\(pushed\) das Image. Am Ende rufen Sie die RESTful API von Kubernetes auf:
```
# showing the log in Jenkins about calling API of Kubernetes
   ...
   [workspace] $ /bin/sh -xe /tmp/hudson3881041045219400676.sh
   + curl -XPUT -d'{"apiVersion":"extensions/v1beta1","kind":"Deployment","metadata":{"name":"my-cal-deployment"},"spec":{"replicas":3,"template":{"metadata":{"labels":{"app":"my-cal"}},"spec":{"containers":[{"name":"my-cal","image":"msfuko/my-cal:1","ports":[{"containerPort":5000}]}]}}}}' http://54.153.44.46:8080/apis/extensions/v1beta1/namespaces/default/deployments/my-cal-deployment
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed

     0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
   100  1670  100  1407  100   263   107k  20534 --:--:-- --:--:-- --:--:--  114k
   {
     "kind": "Deployment",
     "apiVersion": "extensions/v1beta1",
     "metadata": {
       "name": "my-calc-deployment",
       "namespace": "default",
       "selfLink": "/apis/extensions/v1beta1/namespaces/default/deployments/my-calc-deployment",
       "uid": "db49f34e-e41c-11e5-aaa9-061300daf0d1",
       "resourceVersion": "35320",
       "creationTimestamp": "2016-03-07T04:27:09Z",
       "labels": {
         "app": "my-calc"
       }
     },
     "spec": {
       "replicas": 3,
       "selector": {
         "app": "my-calc"
       },
       "template": {
         "metadata": {
           "creationTimestamp": null,
           "labels": {
             "app": "my-calc"
           }
         },
         "spec": {
           "containers": [
             {
               "name": "my-calc",
               "image": "msfuko/my-calc:1",
               "ports": [
                 {
                   "containerPort": 5000,
                   "protocol": "TCP"
                 }
               ],
               "resources": {},
               "terminationMessagePath": "/dev/termination-log",
               "imagePullPolicy": "IfNotPresent"
             }
           ],
           "restartPolicy": "Always",
           "terminationGracePeriodSeconds": 30,
           "dnsPolicy": "ClusterFirst"
         }
       },
       "strategy": {
         "type": "RollingUpdate",
         "rollingUpdate": {
           "maxUnavailable": 1,
           "maxSurge": 1
         }
       },
       "uniqueLabelKey": "deployment.kubernetes.io/podTemplateHash"
     },
     "status": {}
   }
   Finished: SUCCESS
```

7. Benutze das `kubectl` kommando nach einigen miniten zum uberprüfen des vorgangs
```
// check deployment status
# kubectl get deployments
NAME                UPDATEDREPLICAS   AGE
my-cal-deployment   3/3               40m

```

Wir können sehen, dass es eine Bereitstellung namens m`y-cal-deployment `gibt.

8. Mit `kubectl` beschreiben können Sie die Details überprüfen:

```
   // check the details of my-cal-deployment
   # kubectl describe deployment my-cal-deployment
   Name:        my-cal-deployment
   Namespace:      default
   CreationTimestamp:    Mon, 07 Mar 2016 03:20:52 +0000
   Labels:        app=my-cal
   Selector:      app=my-cal
   Replicas:      3 updated / 3 total
   StrategyType:      RollingUpdate
   RollingUpdateStrategy:      1 max unavailable, 1 max surge, 0 min ready seconds
   OldReplicationControllers:  <none>
   NewReplicationController:    deploymentrc-1448558234 (3/3 replicas created)
   Events:
   FirstSeen  LastSeen  Count  From        SubobjectPath  Reason  Message
   ─────────  ────────  ─────  ────        ─────────────  ──────    ───────
   46m    46m    1  {deployment-controller }      ScalingRC  Scaled up rc deploymentrc-3224387841 to 3
   17m    17m    1  {deployment-controller }      ScalingRC  Scaled up rc deploymentrc-3085188054 to 3
   9m    9m    1  {deployment-controller }      ScalingRC  Scaled up rc deploymentrc-1448558234 to 1
   2m    2m    1  {deployment-controller }      ScalingRC  Scaled up rc deploymentrc-1448558234 to 3
```

Wir konnten eine interessante Einstellung namens `RollingUpdateStrategy` sehen. Wir haben `1 max unavailable`, `1 max surge` und `0 min ready seconds`. Es bedeutet, dass wir unsere Strategie einrichten können, um das Update zu auszurollen. Derzeit ist es die Standardeinstellung. Höchstens ein Pod ist während des Einsatzes nicht verfügbar, ein Pod könnte neu erstellt werden, und null Sekunden, um auf den neu geschaffenen Pod zu warten, um bereit zu sein. Wie wäre es mit Replikations-Controller? Wird es richtig erstellt?

```
// check ReplicationController
# kubectl get rc
CONTROLLER                CONTAINER(S)   IMAGE(S)               SELECTOR                                                          REPLICAS   AGE
deploymentrc-1448558234   my-cal         msfuko/my-cal:1        app=my-cal,deployment.kubernetes.io/podTemplateHash=1448558234    3          1m
```

Wir konnten vorher sehen, dass wir drei Repliken in diesem RC mit dem Namen `deploymentrc-${id}` haben. Lassen Sie uns auch die Pod überprüfen:

```
// check Pods
# kubectl get pods
NAME                            READY     STATUS           RESTARTS   AGE
deploymentrc-1448558234-qn45f   1/1       Running          0          4m
deploymentrc-1448558234-4utub   1/1       Running       0          12m
deploymentrc-1448558234-iz9zp   1/1       Running       0          12m
```

Wir könnten herausfinden, dass Deployment Trigger RC-Erstellung, und RC Trigger Pods Schaffung. Überprüfen Sie die Antwort von unserer App `my-calc`:

```
# curl http://54.153.44.46:31725/
Hello World!
```

Angenommen, wir haben eine neu veröffentlichte Anwendung. Wir machen `Hello world!` `Hello Calculator!`. Nachdem Sie den Code in GitHub geuploadet(push) haben, könnte Jenkins entweder durch den SCM-Webhook ausgelöst, periodisch ausgeführt oder manuell ausgelöst werden:

```
[workspace] $ /bin/sh -xe /tmp/hudson877190504897059013.sh
+ curl -XPUT -d{"apiVersion":"extensions/v1beta1","kind":"Deployment","metadata":{"name":"my-calc-deployment"},"spec":{"replicas":3,"template":{"metadata":{"labels":{"app":"my-calc"}},"spec":{"containers":[{"name":"my-calc","image":"msfuko/my-calc:2","ports":[{"containerPort":5000}]}]}}}} http://54.153.44.46:8080/apis/extensions/v1beta1/namespaces/default/deployments/my-calc-deployment
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  1695  100  1421  100   274  86879  16752 --:--:-- --:--:-- --:--:-- 88812
{
  "kind": "Deployment",
  "apiVersion": "extensions/v1beta1",
  "metadata": {
    "name": "my-calc-deployment",
    "namespace": "default",
    "selfLink": "/apis/extensions/v1beta1/namespaces/default/deployments/my-calc-deployment",
    "uid": "db49f34e-e41c-11e5-aaa9-061300daf0d1",
    "resourceVersion": "35756",
    "creationTimestamp": "2016-03-07T04:27:09Z",
    "labels": {
      "app": "my-calc"
    }
  },
  "spec": {
    "replicas": 3,
    "selector": {
      "app": "my-calc"
    },
    "template": {
      "metadata": {
        "creationTimestamp": null,
        "labels": {
          "app": "my-calc"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "my-calc",
            "image": "msfuko/my-calc:2",
            "ports": [
              {
                "containerPort": 5000,
                "protocol": "TCP"
              }
            ],
            "resources": {},
            "terminationMessagePath": "/dev/termination-log",
            "imagePullPolicy": "IfNotPresent"
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst"
      }
    },
    "strategy": {
      "type": "RollingUpdate",
      "rollingUpdate": {
        "maxUnavailable": 1,
        "maxSurge": 1
      }
    },
    "uniqueLabelKey": "deployment.kubernetes.io/podTemplateHash"
  },
  "status": {}
}
Finished: SUCCESS
```

### Wie es funktioniert…

Lass uns die letzte Aktion fortsetzen. Wir haben ein neues Image mit dem Tag `$BUILD_NUMBER` erstellt und Kubernetes ausgelöst, um einen replication controller durch eine Bereitstellung zu ersetzen. Lassen Sie uns das Verhalten des replication controller beobachten:

```
# kubectl get rc
CONTROLLER                CONTAINER(S)   IMAGE(S)               SELECTOR                                                          REPLICAS   AGE
deploymentrc-1705197507   my-calc        msfuko/my-calc:1       app=my-calc,deployment.kubernetes.io/podTemplateHash=1705197507   3          13m
deploymentrc-1771388868   my-calc        msfuko/my-calc:2       app=my-calc,deployment.kubernetes.io/podTemplateHash=1771388868   0          18s
```

Wir können sehen, das Deployment erstellt für Sie einen anderen RC namens `deploymentrc-1771388868`, dessen Pod-Nummer ist derzeit 0. Warten Sie eine Weile und lassen Sie uns noch einmal alles überprüfen:

```
# kubectl get rc
CONTROLLER                CONTAINER(S)   IMAGE(S)               SELECTOR                                                          REPLICAS   AGE
deploymentrc-1705197507   my-calc        msfuko/my-calc:1       app=my-calc,deployment.kubernetes.io/podTemplateHash=1705197507   1          15m
deploymentrc-1771388868   my-calc        msfuko/my-calc:2       app=my-calc,deployment.kubernetes.io/podTemplateHash=1771388868   3          1m
```

Die Anzahl der Pods im RC(replication controller) mit dem alten Bild `my-calc:1` reduziert auf 1 und das neue Images erhöht jetzt sich auf 3:

```
# kubectl get rc
CONTROLLER                CONTAINER(S)   IMAGE(S)               SELECTOR                                                          REPLICAS   AGE
deploymentrc-1705197507   my-calc        msfuko/my-calc:1       app=my-calc,deployment.kubernetes.io/podTemplateHash=1705197507   0          15m
deploymentrc-1771388868   my-calc        msfuko/my-calc:2       app=my-calc,deployment.kubernetes.io/podTemplateHash=1771388868   3          2m
```

Nach ein paar Sekunden sind die alten Pods alle weg und die neuen Pods haben sie ersetzt, um den Nutzern zu dienen. Lassen Sie uns die Antwort durch den Service überprüfen:

```
# curl http://54.153.44.46:31725/
Hello Calculator!
```

Die Pods haben das neue Image einzeln aktualisiert. Im Folgenden ist die Illustration, wie es funktioniert Basierend auf der `RollingUpdateStrategy` ersetzt Kubernetes Pods eins nach dem anderen. Nachdem die neue Pod erfolgreich gestartet ist, wird die alte Pod entfernt. Die Blase in der Zeitleiste  zeigt das Timing der Protokolle, die wir in den vorherigen Beispielen gesehen haben. Am Ende werden die neuen Pods alle alten Pods ersetzen:  
![pods](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_21.jpg)

### Es gibt mehr…

Die deployment funktion befindet sich noch in der Beta-Version, während einige Funktionen noch in der Entwicklung sind, z. B. das Löschen einer Bereitstellung Ressource und die Wiederherstellung der Strategieunterstützung. Allerdings gibt es die Möglichkeit, Jenkins, um die Continuous Delivery Pipeline zur Verfügung zu stellen. Es ist ziemlich einfach und stellt sicher, dass alle Dienste immer online sind, um sie zu aktualisieren. Weitere Informationen zur RESTful API finden Sie unter `http://YOUR_KUBERNETES_MASTER_ENDPOINT:KUBE_API_PORT/swagger-ui/#!/v1beta1/listNamespacedDeployment`.

