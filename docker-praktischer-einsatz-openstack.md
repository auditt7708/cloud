OpenShift v3 bietet den Build-Prozess, um ein Image aus dem Quellcode zu erstellen. Im Folgenden sind die Build-Strategien, die man einsetzen kann, um Image zu bauen:

* Docker-Build: In diesem werden die Benutzer dem Docker-Kontext (Dockerfiles und Support-Dateien) zur Verfügung stellen, mit denen Bilder erstellt werden können. OpenShift löst nur den Befehl zum `docker build` aus, um das Bild zu erstellen.

* Source-to-Image (STI) Build: In diesem Fall definiert der Entwickler das Quellcode-Repository und das Builder-Bild, das die Umgebung definiert, die zum Erstellen der App verwendet wird. STI verwendet dann den gegebenen Quellcode und das Builderbild, um ein neues Bild für die App zu erstellen. Weitere Details über STI finden Sie unter https://github.com/openshift/source-to-image.

* Benutzerdefiniertes Build: Dies ähnelt der Docker-Build-Strategie, aber Benutzer können das Builder-Image anpassen, das für die Ausführung von Ausführung verwendet wird.


In diesem Beispiel werden wir uns den STI-Build-Prozess anschauen. Wir werden die Beispiel-App aus dem OpenShift v3 Origin Repo (https://github.com/openshift/origin/tree/v0.4.3/examples/sample-app) anschauen. Die entsprechende STI-Build-Datei befindet sich unter https://github.com/openshift/origin/blob/v0.4.3/examples/sample-app/application-template-stibuild.json.

Im Bereich `BuildConfig` sehen wir, dass die Quelle auf einen GitHub Repo (`git://github.com/openshift/ruby-hello-world.git`) zeigt und das Bild unter dem `strategy` abschnitt auf den `openshift/ruby-20-centos7` Image. So werden wir das `openshift/ruby-20-centos7`Image verwenden und ein neues Image mit der Quelle aus dem GitHub-Repo erstellen. Das neue Image, nach dem Build wird auf die lokale oder Drittanbieter-Docker-Registrierung verschoben, je nach den Einstellungen. Der `BuildConfig`-Abschnitt definiert auch Trigger, wann ein neuer Build ausgelöst werden soll, zum Beispiel, wenn sich das Build-Image geändert hat.

In der gleichen STI-Build-Datei (`application-template-stibuild.json`) finden Sie mehrere DeploymentConfig-Abschnitte, eine von jedem Pod. Ein `DeploymentConfig`-Abschnitt enthält Informationen wie exportierte Ports, replicas, die Umgebungsvariablen für den Pod und andere Informationen. In einfachen Worten können Sie sich `DeploymentConfig` als erweiterten Replikationscontroller von Kubernetes denken. Es hat auch Trigger, einen neuen Einsatz auszulösen. Jedes Mal, wenn eine neue Bereitstellung erstellt wird, wird das `latestVersion`-Feld von `DeploymentConfig` inkrementiert. Eine `deploymentCause` wird auch zu `deploymentConfig` hinzugefügt, in dem die Änderung beschrieben wird, die zur letzten Bereitstellung geführt hat.

`ImageRepository`, das vor kurzem zu `ImageStream` umbenannt wurde, ist ein Stream von verwandten Images. `BuildConfig` und `DeploymentConfig` sehen ImageStream, um nach Image veränderungen zu suchen und entsprechend zu reagieren, basierend auf ihren jeweiligen Triggern.

Die anderen Abschnitte, die Sie in der STI-Build-Datei finden, sind Dienste für Pods (Datenbank und Frontend), eine Route für den Frontend-Service, über die auf die App zugegriffen werden kann, und eine Vorlage. Eine Vorlage beschreibt einen Satz von Ressourcen, die zusammen verwendet werden sollen, die angepasst und verarbeitet werden können, um eine Konfiguration zu erzeugen. Jede Vorlage kann eine Liste von Parametern definieren, die für den Container durch Container modifiziert werden können.

Ähnlich wie STI-Build, gibt es Beispiele für Docker und benutzerdefinierte Build in der gleichen sample-app Beispiel-Ordner. Ich gehe davon aus, dass du das frühere Rezept hast, also werden wir von dort weiter fortfahren.

### Fertig werden

Sie sollten das frühere Rezept abgeschlossen haben, Einrichten von PaaS mit OpenShift Origin.

Ihr aktuelles Arbeitsverzeichnis sollte `/data/src/github.com/openshift/origin /examples/hallo-openshift` innerhalb der VM, gestartet von Vagrant sein.

### Wie es geht…

1. Bereitstellen einer privaten Docker-Registrierung zum Verwalten von Images, die vom STI-Buildprozess erstellt wurden:
`$ sudo openshift ex registry --create --credentials=./openshift.local.certificates/openshift-registry/.kubeconfig `

2. Bestätigen Sie die Registrierung wenn begonnen hat (dies kann ein paar Minuten dauern):
`$ osc describe service docker-registry`

3. Create a new project in OpenShift. This creates a namespace test to contain the builds and an app that we will generate later:
`$ openshift ex new-project test --display-name="OpenShift 3 Sample" --description="This is an example project to demonstrate OpenShift v3" --admin=test-admin `

4. Melden Sie sich mit dem `test-admin` Benutzer an und wechseln Sie zu dem Testprojekt, das von nun an bei jedem Befehl verwendet wird:
```
$ osc login -u test-admin -p pass 
$ osc project test 
```

5. Übertragen Sie die Anwendungsvorlage für die Bearbeitung (Erzeugen von gemeinsam genutzten Parametern in der Vorlage) und fordern Sie dann die Erstellung der bearbeiteten Vorlage an:
`$ osc process -f application-template-stibuild.json | osc create -f - `

6. Dies wird den Build nicht auslösen. Um den Aufbau Ihrer Anwendung zu starten, führen Sie den folgenden Befehl aus:
`$ osc start-build ruby-sample-build `

7. 