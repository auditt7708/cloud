# Kubernates CD/CI Piplines Integration mit Jenkins

In Software Engineering, [Continuous Integration (CI)](https://de.wikipedia.org/wiki/Continuous_integration) und [Continuous Delivery (CD)](https://de.wikipedia.org/wiki/Continuous_delivery), abgekürzt als CI/CD, haben die Idee, das Verfahren des traditionellen Entwicklungsprozesses mit einem kontinuierlichen Testmechanismus zu vereinfachen, um die Panik der ernsten Konflikte zu reduzieren, nämlich, um kleine Fehler sofort zu lösen, sobald man einen gefunden hat.
Darüber hinaus kann durch ein automatisches Werkzeug ein Produkt, das auf dem CI/CD-System läuft, eine bessere Effizienz für Bugfixes oder neue Feature-Delivery erzielen. Jenkins ist eine der bekannten CI/CD-Anwendungen. Projekte in Jenkins ziehen Codes aus dem Code Base Server und testen oder implementieren ihn. In diesem Rezept zeigen wir Ihnen, wie das Kubernetes-System Jenkins-Server als CI/CD-Gruppe beitritt.

## Fertig werden

Bevor Sie dieses Beispiel starten, bereiten Sie ein [Docker Hub-Konto](https://hub.docker.com) vor, wenn Sie nicht über Ihre Docker-Registrierung verfügen erstellen Sie sich bitte iens. Wir werden die von Jenkins hier gebauten Images anbieten. Es auch dort, wo Kubernetes Images downloaded(pull). Als nächstes stellen Sie sicher, dass beide Kubernetes-Server und Ihre Jenkins-Server bereit sind. Sie können Ihren eigenen eigenständigen Jenkins-Server auch über das Docker-Image einrichten. Die Details sind hier angegeben.

### Installiere einen Jenkins-Server, der ein Docker-Programm erstellen kann

Zuerst benötigen Sie eine Maschine mit installiertem Docker. Dann können Sie mit diesem Befehl einen Jenkins-Server erstellen.

```sh
// Pull the Jenkins image from Docker Hub
$ docker run -p 8080:8080 -v /your/jenkins_home/:/var/jenkins_home -v $(which docker):/bin/docker jenkins
```

Port `8080` ist das Portal einer Website. Es wird empfohlen, ein Host verzeichnis zum Mounten des Jenkins-Home-Verzeichnisses zu benutzen. Daher können Sie die Daten auch bei der Abschaltung des Containers behalten. Wir werden auch die Docker-Binärdatei in unseren Jenkins-Container einbinden, da dieses offizielle Image von Jenkins den Docker-Befehl nicht installiert hat. Nachdem Sie diesen Befehl ausgeführt haben, werden die Protokolle für die Installation auf Ihrem Terminal angezeigt. Sobald Sie diese Informationen sehen, ist **INFO: Jenkins is fully up and running**, es ist eine gute Idee, die Webkonsole von Jenkins mit `DOCKER_MACHINE_IP_ADDRESS:8080` zu überprüfen:

![Jenkins-welcome](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_09.jpg)

Danach musst du die Git- und Docker-Plugins für Jenkins installieren. Installieren von Plugins ist die Möglichkeit, Ihren Jenkins Server anzupassen. Hier können Sie diese beiden Plugins dazu veranlassen, den Workflow vom Code in Ihrem Laptop/Computer zu den Containern auf dem Kubernetes System zu erfüllen. Sie können sich auf folgende Schritte beziehen:

1. Klicken Sie auf Jenkins im linken Menü.
2. Auswählen von Plugins.
3. Wählen Sie das Tag Verfügbar.
4. Key in Git Plugin und check it; Mach das gleiche für CloudBees Docker Build und veröffentlichen Plugin.
5. Starten Sie die Installation und starten Sie neu.

### Wie es geht…

Wir werden Kubernetes zum Arbeitsplatz machen, um Testcontainer zum laufen zu bringen oder offiziell Container einzusetzen. Derzeit gibt es keine Jenkins-Plugins für den Einsatz von Pods auf den Kubernetes-Systemen. Deshalb werden wir die Kubernetes API für unsere Nutzung aufrufen. Um einen Programmtest durchführen zu können, können wir den Kubernetes-Job verwenden, der in der Sicherstellung der flexiblen Nutzung Ihres Container-Rezepts in [Spielen mit Containern](../kubernetes-container) erwähnt wird, die den Job-ähnlichen Pod erstellen wird, der nach Beendigung beendet werden könnte. Es eignet sich zum Testen und Verifizieren. Auf der anderen Seite können wir direkt den  replication controller und den Service für die offizielle Bereitstellung erstellen.

### Erstellen Sie Ihr Jenkins Projekt

Als Programm-Build werden wir für jedes Programm ein einziges Jenkins-Projekt erstellen. Jetzt kannst du im Menü auf der linken Seite auf **New Item** klicken. In diesem Rezept wählen Sie **Freestyle-Projekt**; Es ist gut genug für die Build beispiele später. Benennen Sie das Projekt und klicken Sie auf **OK**:

![jenkins-freestyle-projekt01](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_10.jpg)

Dann sehen Sie auf der Konfigurationsseite folgende Kategorien von der Kategorien Seite:

* Advanced Project Options
* Source Code Management
* Build Triggers
* Build
* Post-build Actions

Mit diesen Einstellungen kann Ihr Projekt flexibler und näher an die Anforderungen angepasst werden, die Sie benötigen. Wir werden uns aber nur auf die `Source Code Management`- und `Build` Teile konzentrieren, um unsere Anforderungen zu erfüllen. Source Code Management ist, wo wir unsere Codebasis Lage definieren. In den späteren Abschnitten wählen wir Git und setzen das entsprechende Repository ein:

![jenkins-git-repo](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_11.jpg)

In der Kategorie **Build** werden mehrere Schritte wie **Docker Build und Publish** und **Execute Shell** dazu beitragen, Docker Images zu bauen, Images in die Docker Registry zu uploaden(push) und das Kubernetes System auszulösen, um die Programme auszuführen:

![jenkins-docker-build-git](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_12.jpg)

Die folgenden zwei Szenarien zeigen, wie Sie die Konfigurationen für das Ausführen Ihrer Programme auf den Kubernetes-Systemen festlegen können.

### Führen Sie einen Programmtest durch

Die Aufgabe von Kubernetes besteht darin, einige Programme zu behandeln, die über terminal zugriff verfügen, wie z. B. Unit-Tests. Hier haben wir ein kurzes dockerisiertes Programm, das für diese Situation geeignet ist. Fühlen Sie sich frei, es auf GitHub zu überprüfen: [kubernetes-cookbook sleeper](https://github.com/kubernetes-cookbook/sleeper). Wie in `Dockerfile` angedeutet, wird dieses kleine Programm nach 10 Sekunden ausgeführt und nichts beendet. Die folgenden Schritte führen Sie zur Konfiguration der Projektkonfigurationen:

1. Bei der **Source Code Management** wählen Sie **Git**, setzen Sie die **HTTPS-URL** Ihres GitHub-Repositorys auf die **Repository-URL**. Zum Beispiel [kubernetes-cookbook sleeper](https://github.com/kubernetes-cookbook/sleeper). Und Sie werden feststellen, dass die WARNING-Nachricht für ein öffentliches Repository verschwunden ist. Oder Sie müssen eine Berechtigung hinzufügen.

2. Bei Build benötigen wir die folgenden zwei Schritte:

> 1. Add **Docker Build and Publish** zuerst, um Ihr Programm als Image zu bauen. Ein Repository-Name ist ein erforderliches Element. In diesem Fall verwenden wir Docker Hub als Registry; Bitte nennen Sie Ihr Repository als `DOCKERHUB_ACCOUNT:YOUR_CUSTOMIZED_NAME`. Zum Beispiel, `nosus:sleeper`. Das Hinzufügen eines Tags, wie z. B. `v$BUILD_NUMBER`, könnte Ihr Docker-Image mit der Jenkins-Buildnummer markieren. Lassen Sie Docker Host URI und Server Anmeldeinformationen leer, wenn Ihre Jenkins Server bereits das Docker Paket installiert haben. Aber wenn Sie den Anweisungen auf der vorherigen Seite folgen, um den Jenkins-Server als Container zu installieren, überprüfen Sie bitte die folgenden Tipps für detaillierte Einstellungen dieser beiden Elemente. Lassen Sie die Docker-Registrierungs-URL leer, da wir Docker Hub als Docker-Registrierung verwendet haben. Legen Sie jedoch eine neue Berechtigung fest, damit Ihr Docker Hub auf die Berechtigung zugreift.
>
> 2. Als nächstes fügen Sie einen Shell Block für den Aufruf der Kubernetes-API hinzu. Wir setzen zwei API-Anrufe für unseren Zweck: man solle einen Kubernetes-Job mit der JSON-Formatvorlage erstellen und der andere ist zu fragen, ob der Job erfolgreich abgeschlossen ist oder nicht:
>
>

```sh
#run a k8s job
curl -XPOST -d'{"apiVersion":"extensions/v1beta1","kind": "Job","metadata":{"name":"sleeper"}, "spec": {"selector": {"matchLabels": {"image": "ubuntu","test": "jenkins"}},"template": {"metadata": {"labels": {"image": "ubuntu","test": "jenkins"}},"spec": {"containers": [{"name": "sleeper","image": "nosus/sleeper"}],"restartPolicy": "Never"}}}}' http://YOUR_KUBERNETES_MASTER_ENDPOINT/apis/extensions/v1beta1/namespaces/default/jobs

#check status
count=1
returnValue=-1
while [ $count -lt 60 ]; do
  curl -XGET http://YOUR_KUBERNETES_MASTER_ENDPOINT/apis/extensions/v1beta1/namespaces/default/jobs/sleeper | grep "\"succeeded\": 1" && returnValue=0 && break
  sleep 3
count=$(($count+1))
done

return $returnValue
```

>

Wir werden auch eine `while` Schleife für eine 3-minütige Timeout-Begrenzung hinzufügen. Die regelmäßige Überprüfung des Status des Jobs ist ein einfacher Weg zu wissen, ob es fertig ist. Wenn Sie nicht die Nachricht **succeeded:1** rechtzeitig bekommen, beurteilen Sie den Job als Misserfolg.

### Tip

Legen Sie Docker Host URI und Server Credential für einen containerisierten Jenkins Server fest

Wenn Sie Docker-Maschine zum Erstellen Ihrer Docker-Umgebung verwenden (z. B. ein OS X-Benutzer), geben Sie diesen Befehl in Ihrem Terminal ein:

```sh
$ docker-machine env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/YOUR_ACCOUNT/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
```

Führen Sie diesen Befehl aus, um Ihre Shell zu konfigurieren:

`# eval $(docker-machine env)`

Standardmäßig erhalten Sie die vorherigen Informationen. Bitte fügen Sie den Wert von `$DOCKER_HOST` in das Element Docker Host URI ein. Dann überprüfen Sie Ihr Verzeichnis `$DOCKER_CERT_PATH`:

```sh
$ ls /Users/carol/.docker/machine/machines/default
boot2docker.iso cert.pem        default         id_rsa          key.pem         server.pem
ca.pem          config.json     disk.vmdk       id_rsa.pub      server-key.pem
```

Bestimmte Dateien, die hier aufgeführt sind, können für Sie die Erlaubnis erhalten. Bitte klicken Sie auf die Schaltfläche **Add** neben **Registry credentials** und fügen Sie den Inhalt eines Teils der vorherigen Dateien ein, wie im folgenden Screenshot gezeigt:

![jenkins-add-credentials-ca](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_13.jpg)

Nachdem Sie Projektkonfigurationen beendet haben, können Sie auf Speichern klicken und dann auf Jetzt klicken, um das Ergebnis zu überprüfen. Sie können finden, dass Ihr Bild auch an Docker Hub geuploaded(push) wird:

![git-nosus-sleeper](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_14.jpg)

### Bereitstellung eines Programms

Deploying eines dockerisierten Programms über den Jenkins-Server hat ähnliche Konfigurationen in den Einstellungen des Projekts. Wir bereiten ein einfaches nginx Programm vor, um es zu versuchen! Öffnen Sie ein neues Jenkins-Projekt für neue Einstellungen wie folgt:

1. Bei **Source Code Management** wählen Sie Git; Setzen Sie den [Wert](https://github.com/kubernetes-cookbook/nginx-demo.git) in **Repository URL**.

2. Bei **Build** brauchen wir auch zwei **Build**-Schritte. Sie sind wie folgt:
>
> 1. Füge ein **Docker Build and Publish** zuerst hinzu; Wir werden `nosus:nginx-demo` setzen als repository name. Geben Sie an **Docker Host URI** und **Server credentials** entsprechende Werte an.
>
> 2. Wir benötigen einen **Execute shell** zum Aufruf der Kubernetes API. Es gibt zwei API-Anrufe in den Bereich: Der erste ist für die Schaffung eines Pod und die andere ist für die Schaffung eines Dienstes, um die Pod zu freizugeben:
>

```sh
#create a pod
curl -XPOST -d'{"apiVersion": "v1","kind": "Pod","metadata": {"labels":{"app": "nginx"},"name": "nginx-demo"},"spec": {"containers": [{"image": "nosus/nginx-demo","imagePullPolicy": "Always","name": "nginx-demo","ports": [{"containerPort": 80,"name": "http"}]}],"restartPolicy": "Always"}}' http:// YOUR_KUBERNETES_MASTER_ENDPOINT/api/v1/namespaces/default/pods
#create a service
curl -XPOST -d'{"apiVersion": "v1","kind": "Service","metadata": {"name": "nginx-demo"},"spec": {"ports": [{"port": 8081,"protocol": "TCP","targetPort": 80}],"selector": {"app": "nginx"},"type": "NodePort"}}' http://YOUR_KUBERNETES_MASTER_ENDPOINT /api/v1/namespaces/default/services
```

>

Fühlen Sie sich frei, den Endpunkt des Kubernetes Service zu überprüfen, den Sie gerade mit Jenkins geschaffen haben! Es ist noch besser, wenn du einen Git Server Webhook mit Jenkins hinzufügst. Sie können direkt das letzte Ergebnis erhalten, nachdem jeder Code uploadet(push) wurde!

### Wie es funktioniert…

Der Jenkins-Server kommuniziert mit dem Kubernetes-System über seine RESTful API. Sie können auch einen Blick auf mehr Funktionalitäten über die URL: `http://YOUR_KUBERNETES_MASTER_ENDPOINT:KUBE_API_PORT/swagger_ui`. Hallo! Die API-Liste wird nur in Ihrem Server gespeichert!

Auf der anderen Seite ist es möglich, dass Sie das Plugin namens [HTTP Request Plugin](https://wiki.jenkins-ci.org/display/JENKINS/HTTP+Request+Plugin) installieren, um die Kubernetes API-Aufrufe zu erfüllen. Wir werden das nicht erklären, da die `POST`-Funktion der aktuellen Version die JSON-Format-payload nicht nutzen konnte. Sie können immer noch versuchen, die anderen Arten von API-Aufrufe mit diesem Plugin zu nutzen.

Derzeit gibt es keine Plugins, die in der Lage sind, die Kubernetes-Aufgaben vollständig einzusetzen. Deshalb ist der Bauvorgang so ein fall Kopfschmerzen für die langen Curl-Befehle. Es ist auch eine Inspiration, dass Sie für andere Systeme oder Dienstleistungen mit Ihrem Kubernetes System über die RESTful API kombinieren können.

### Es gibt mehr…

Sie können feststellen, dass im Abschnitt Bereitstellen eines Programms, wenn wir das gleiche Projekt wieder aufbauen, der Kubernetes-API-Aufruf eine Fehlerreaktion zurückgibt, die antwortet bedeutet, dass der Pod und der Dienst bereits vorhanden sind. In dieser Situation hat Kubernetes keine rolling Update-API für die Live-Aktualisierung unseres Programms.

Dennoch gibt es auf dem Aspekt der Infrastruktur zwei Ideen für die Integration von Kubernetes:

* Ein Jenkins Plugin namens [Kubernetes Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin) hilft, Jenkins slaves dynamisch zu erstellen.

* Du kannst versuchen, deinen Kubernetes Master als Jenkins Slave zu machen! Infolgedessen ist es wunderbar, Pods ohne komplizierte API-Aufrufe zu erstellen. Es gibt kein Problem, ein rolling Update zu verwenden!

In die Version 1.2 von Kubernetes, gibt es eine neue Ressource-Typ deployment, die Pods und Replikatsets steuert, die die neue Lösung für die Verwaltung Ihrer Pods sein sollte. Die Bereitstellung hat folgende Funktionen:

* Gewünschter Zustand und verfügbarer Zustand, um anzuzeigen, ob die Pods gebrauchsfertig sind
* Rolling Update für die Pods für jede Änderung
* Es ist fähig, auf die vorherige Revision des Einsatzes zurückzukehren

Ressource-Bereitstellung ist in der API-Version Erweiterungen `/v1beta1`. Kubernetes unterstützt seinen API-Aufruf für Update und Rollback. Bitte nehmen Sie die folgenden API-Aufrufe als Referenz:

```sh
// Create a deployment
curl -XPOST  -d "{\"metadata\":{\"name\":\"nginx-123\"},\"spec\":{\"replicas\":2,\"template\":{\"metadata\":{\"labels\":{\"app\":\nginx\"}},\"spec\":{\"containers\":[{\"name\":\"nginx-deployment\",\"image\":\"nosus/nginx-demo:v$BUILD_NUMBER\",\"ports\":[{\"containerPort\": 80}]}]}}}}" YOUR_KUBERNETES_MASTER_ENDPOINT /v1beta1/namespaces/default/deployments
```

Für Update-Implementierungen wird ein Patch-Call der API verwendet. Hier werden wir die Image version ändern. Einige Details zum [Patch-Betrieb](https://github.com/kubernetes/kubernetes/blob/master/docs/devel/api-conventions.md)

```sh
// Update a deployment
curl -H "Content-Type: application/strategic-merge-patch+json" -XPATCH -d '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-deployment","image":"nosus/nginx-demo:v1"}]}}}}' YOUR_KUBERNETES_MASTER_ENDPOINT /apis/extensions/v1beta1/namespaces/default/deployments/nginx-deployment
// Rollback the deployment
curl -H "Content-Type: application/json" -XPOST -d '{"name":"nginx-deployment","rollbackTo":{"revision":0}}' YOUR_KUBERNETES_MASTER_ENDPOINT /apis/extensions/v1beta1/namespaces/default/deployments/nginx-deployment/rollback
```

Im letzten API-Aufruf rollen wir die Bereitstellung auf die ursprüngliche Version zurück, die als Version `0` angegeben ist. Versuchen Sie einfach, die neue Ressourcentyp deployment selbst zu benutzen!