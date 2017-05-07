Ein Replikationscontroller ist ein Begriff für API-Objekte in Kubernetes, der sich auf Pod-Repliken bezieht. Die Idee ist, in der Lage sein, eine Reihe von Pods Verhaltensweisen zu kontrollieren. Der Replikationscontroller sorgt dafür, dass die Pods in einer benutzerdefinierten Nummer ständig laufen. Wenn einige Pods im Replikationscontroller abstürzen und beenden, wird das System Pods mit den ursprünglichen Konfigurationen auf gesunden Knoten automatisch neu erstellen und eine gewisse Anzahl von Prozessen kontinuierlich laufen lassen. Nach dieser Funktion, egal ob Sie Repliken von Pods benötigen oder nicht, können Sie immer die Pods mit dem Replikations-Controller für Autorecovery abschirmen. In diesem Rezept werden Sie lernen, wie Sie Ihre Pods verwalten, indem Sie den Replikations-Controller:

![schema-replication-controller](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_01.jpg)

Der replication controller behandelt in der Regel eine Reihe von Anwendungen. Wie Sie im vorigen Bild sehen, starten wir einen replication controller mit drei Pod Repliken. Einige Mechanismusdetails sind wie folgt aufgeführt:

* Der Dämon im Master wird als Controller Manager bezeichnet und hilft, die Ressource in seinem gewünschten Zustand zu halten. Beispielsweise ist der gewünschte Zustand des replication controller im vorherigen Bild drei Pod-Repliken.

* Der Daemon-Scheduler im Master übernimmt die Zuordnung von Aufgaben zu gesunden Knoten.

* Der Selektor des replication controller wird verwendet, um zu entscheiden, welche Pods er deckt. Wenn die Schlüsselwertpaare im Etikett des Pods alle Elemente im Selektor des replication controller enthalten, gehört dieser Pod zu diesem replication controller. Wie Sie sehen werden, zeigt das vorherige Bild drei Pods unter der Ladung des replication controller. Da der Selektor abgedeckt und als Projekt und Rolle bezeichnet wird, könnte die Pod mit der anderen kleineren Versionsnummer (Pod 2) noch eines der Mitglieder sein.

### Fertig werden

Wir haben das Management des replication controller im Kubernetes-Master demonstriert, als wir das Kubernetes-Clientpaket installiert haben. Bitte melden Sie sich zuerst beim Master an und stellen Sie sicher, dass Ihre Umgebung replication controller erstellen kann.

### Tip

Die Auswertung der replication controller-Erstellung vom Master

Sie können überprüfen, ob Ihr Kubernetes Master ein praktischer ist, indem Sie die folgenden Punkte überprüfen:

Prüfen Sie, ob die Daemons laufen oder nicht. Es sollten drei Arbeits-Daemon-Prozesse auf dem Master-Knoten vorhanden sein: Apiserver, Scheduler und Controller-Manager.

Überprüfen Sie den Befehl kubectl existiert und ist bearbeitbar. Probieren Sie den Befehl kubectl erhalten Componentstatus oder kubectl bekommen cs, so können Sie nicht nur die Komponenten der Status, sondern auch die Machbarkeit von kubectl zu überprüfen.

Überprüfen Sie, ob die Knoten bereit sind zu arbeiten. Sie können sie durch den Befehl kubectl erhalten Knoten für ihren Status zu überprüfen.

Falls einige der vorstehenden Punkte ungültig sind, lesen Sie bitte auf> Kapitel 1, Erstellen Sie Ihre eigenen Kubernetes für die korrekten Richtlinien der Installation.

### Wie es geht…

Ein replication controller kann direkt über CLI oder über eine Vorlagendatei erstellt werden. Wir werden die bisherige Lösung in diesem Abschnitt ausdrücken. Für Vorlage eins, siehe das Rezept Arbeiten mit Konfigurationsdateien in Kapitel 3, Spielen mit Containern.
Erstellen eines replication controller

Um Replikationscontroller zu erstellen, verwenden wir den Unterbefehl nach kubectl. Das grundlegende Befehlsmuster sieht wie folgt aus:
```
//  kubectl run <REPLICATION CONTROLLER NAME> --images=<IMAGE NAME> [OPTIONAL_FLAGS]
# kubectl run my-first-rc --image=nginx
CONTROLLER    CONTAINER(S)   IMAGE(S)   SELECTOR      REPLICAS
my-first-rc   my-first-rc    nginx      run=my-first-rc   1
```

Dieser einfache Befehl erstellt einen replication controller nach Bild nginx aus dem Docker Hub (https://hub.docker.com). Der Name, `my-first-rc`, muss in allen replication controller eindeutig sein. Ohne vorgegebene Anzahl von Repliken wird das System nur einen Pod als Standardwert erstellen. Es gibt mehr optionale Flags, die Sie zusammen integrieren können, um einen qualifizierten replication controller zu erstellen:

|--Flag=[Default Wert]|Beschreibung|Beispiel|
| :---: | :---: | :---: |
| `--replicas=1` |Die Anzahl der Pod Repliken| `--replicas=3` |
| `--port=-1` |Der weiter geleitete Port des Containers| `--port=80` |
| `--hostport=-1 `|Die Host-Port-Mapping für den Container-Port. Vergewissern Sie sich, dass bei der Verwendung der Flagge nicht mehrere Pod-Repliken auf einem Node ausgeführt werden, um Port-Konflikte zu vermeiden.| -`-hostport=8080` |
| `--labels=""` |Key-Wert-Paare als Labels für Pods. Trennen Sie jedes Paar mit einem Komma.| --`labels="ProductName=HappyCloud,ProductionState=staging,ProjectOwner=Amy"` |
| `--command[=false]` |Nachdem der Container hochgefahren ist, führen Sie einen anderen Befehl durch dieses Flagg aus. Zwei gestrichelte Linien hängen das Flag als Segmentierung an.| `--command -- /myapp/run.py -o logfile` |
| `--env=[]` |Legen Sie Umgebungsvariablen in Containern fest. Dieses Flag könnte mehrmals in einem einzigen Befehl verwendet werden.| `--env="USERNAME=amy" --env="PASSWD=pa$$w0rd"` |
| `--overrides=""` |Verwenden Sie dieses Flag, um einige generierte Objekte des Systems im JSON-Format zu überschreiben. Der JSON-Wert verwendet ein einziges Zitat, um dem doppelten Zitat zu entgehen. Das Feld apiVersion ist notwendig. Detaillierte Artikel und Anforderungen finden Sie im Kapitel Arbeiten mit Konfigurationsdateien in [Spielen mit Containern](../kubernates-container)| `--overrides='{"apiVersion": "v1"}'` |
| `--limits=""` |Die obere Grenze der Ressourcennutzung im Container. Sie können festlegen, wie viel CPU und Speicher verwendet werden könnten. Die CPU-Einheit ist die Anzahl der Kerne im Format `NUMBERm`. `M` zeigt `milli` (10-3) an. Die Speichereinheit ist Byte. Bitte überprüfen Sie auch `--requests`| `--limits="cpu=1000m,memory=512Mi"` |
| `--requests=""` |Die Mindestanforderung an die Ressourcen für Container. Die Regel des Wertes ist die gleiche wie `--limits`| `--requests="cpu=250m,memory=256Mi" `|
| `--dry-run[=false]` |Anzeige der Objektkonfiguration, ohne sie zum Erstellen zu senden.| `--dry-run` |
| `--attach[=false]` |Für den Replikationscontroller wird Ihr Terminal an eine der Replikaten angehängt und das Laufzeitprotokoll aus dem Programm angezeigt. Die Voreinstellung ist, den ersten Container in der Pod zu befragen, genauso wie Dockers anhängen. Einige Protokolle aus dem System zeigen den Status des Containers an.| `--attach` |
|`-i , --stdin[=false]`|Aktivieren Sie den interaktiven Modus des Containers. Die Replik muss 1 sein.|`-i`|
| `--tty=[false]` |Zu jedem Container eine neue `tty` (neue Controlling-Terminal) zuordnen. Sie müssen den interaktiven Modus aktivieren, indem Sie das Flag -i oder --stdin anhängen.|`--tty`|

Der Unterbefehl `run` wird standardmäßig einen replication controller erstellen, da der Flag `--restart`, der als `Always` vorgegeben ist, bedeutet, dass die generierten Objekte immer ausgelöst und ausgeführt werden, um die gewünschten anzahl des replication controller zu erfüllen.

Beispielsweise können Sie einen replication controller starten und dann neue Funktionen hinzufügen oder Konfigurationen ändern:
```
// Run a replication controller with some flags for Nginx nodes. Try to verify the settings with "--dry-run" first!
# kubectl run nginx-rc-test --image=nginx --labels="Owner=Amy,ProductionState=test" --replicas=2 --port=80 --dry-run 
CONTROLLER      CONTAINER(S)    IMAGE(S)   SELECTOR                         REPLICAS
nginx-rc-test   nginx-rc-test   nginx      Owner=Amy,ProductionState=test   2

// Send out the request 
# kubectl run nginx-rc --image=nginx --labels="Owner=Amy,ProductionState=test" --replicas=2 --port=80

// Try to override container name while generating, which name is the same as the name of replication controller in default
# kubectl run nginx-rc-override --image=nginx --overrides='{"apiVersion":"v1","spec":{"template":{"spec": {"containers":[{"name": "k8s-nginx","image":"nginx"}]}}}}'
CONTROLLER       CONTAINER(S)   IMAGE(S)   SELECTOR             REPLICAS
nginx-rc-override   k8s-nginx      nginx      run=nginx-rc-override   1
//Interact with container after create a pod in replication controller
# kubectl run nginx-bash --image=nginx --tty -i --command -- /bin/bash
Waiting for pod to be scheduled
Waiting for pod default/nginx-bash-916y6 to be running, status is Running, pod ready: false
Waiting for pod default/nginx-bash-916y6 to be running, status is Running, pod ready: false
ls
bin   dev  home  lib64	mnt  proc  run  srv  tmp  var
boot  etc  lib  media  opt  root  sbin  sys  usr
root@nginx-bash-916y6:/#
```

### Informationen über einen replication controller erhalten

Nachdem wir einen replication controller erstellt haben, kann der Unterbefehl `get` und `describe` uns helfen, den Informations- und Podstatus zu erfassen. In der CLI von Kubernetes verwenden wir gewöhnlich die Abkürzung rc für Ressourcentyp anstelle des vollständigen Namen replication controller:

Zuerst können wir jeden replication controller im System überprüfen:
```
// Use subcommand "get" to list replication controllers
# kubectl get rc
CONTROLLER   CONTAINER(S)   IMAGE(S)   SELECTOR         REPLICAS   AGE
check-rc-1   check-rc-1     nginx      run=check-rc-1   5          7m
check-rc-2   check-rc-2     nginx      app=nginx        2          6m
```

Wie es angezeigt wird, sind die speziellen Spalte Elemente `SELECTOR` und `REPLICAS`. Der Selektor muss die  `--labels` der Pods sein, die darauf hinweisen, dass die Pods von diesem Replikationscontroller gesteuert werden. Wir können den Selektor durch das Flag --labels bei der Erstellung des Replikationscontrollers mit `kubectl run` angeben. Der von der CLI erstellte Default-Selektor des Replikationscontrollers ist in Form von `run=<REPLICATION CONTROLLER NAME>`:
```
// We can also get status of pod through selector/labels
# kubectl get pod -l app=nginx
NAME               READY     STATUS    RESTARTS   AGE
check-rc-2-95851   1/1       Running   0          6m
check-rc-2-mjezz   1/1       Running   0          6m
```
Darüber hinaus hilft der Unterbefehl `descripe` der Benutzer, detaillierte Elemente und Protokolle der Ressourcen zu erhalten:
```
# kubectl describe rc check-rc-2
Name:    check-rc-2
Namespace:  default
Image(s):  nginx
Selector:  app=nginx
Labels:    app=nginx
Replicas:  2 current / 2 desired
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen  LastSeen  Count  From        SubobjectPath  Reason      Message
  ─────────  ────────  ─────  ────        ─────────────  ──────    ───────
  6m      6m    1  {replication-controller }      SuccessfulCreate  Created pod: check-rc-2-95851
  6m    6m    1  {replication-controller }      SuccessfulCreate  Created pod: check-rc-2-mjezz
```

### Ändern der Konfiguration eines replication controller

Die Unterbefehle, die als `edit`, `patch` und `replace` bekannt sind, können helfen, Live-Replikations-Controller zu aktualisieren. Alle diese drei ändern die Einstellungen über eine Konfigurationsdatei. Hier nehmen wir zum Beispiel nur den Unterbefehlel Bearbeitung.

Mit der Unterbefehlsbearbeitung `edit` können Benutzer die Ressourcenkonfiguration über den Editor ändern. Versuchen Sie, Ihren replication controller über den Befehl `kubectl` zu bearbeiten. `kubectl edit rc/<REPLICATION CONTROLLER NAME>` (um zu einem anderen Ressourcentyp zu wechseln, können Sie rc ändern, z. B. po, svc, ns), Sie greifen auf diesen über den Standardeditor eif eine YAML-Konfigurationsdatei, mit Ausnahme von Ressourcentyp und Ressourcenname. Werfen Sie einen Blick auf das Arbeiten mit Konfigurationsdateien Rezept in [Spielen mit Containern](../kubernates-container) und versuchen, die anderen Werte zu ändern:
```
// Try to update your by subcommand edit
# kubectl get rc
CONTROLLER   CONTAINER(S)   IMAGE(S)   SELECTOR        REPLICAS   AGE
test-edit    test-edit      nginx      run=test-edit   1          5m
# kubectl edit rc/test-edit
replicationcontroller "test-edit" edited
# kubectl get rc
CONTROLLER   CONTAINER(S)   IMAGE(S)   SELECTOR                   REPLICAS   AGE
test-edit    nginx-rc       nginx      app=nginx,run=after-edit   3          7m
```
### Entfernen eines replication controller

Um replication controller aus dem System zu entfernen, können Sie den Unterbefehl `delete` benutzen. Der ähnliche Unterbefehl `stop` ist veraltet und wurde von `delete` abgelöst. Während wir `delete` verwenden, um die Ressource zu entfernen, verwenden sie `delete` die Zielobjekte forciert und dabei ignoriert er gleichzeitig alle Anfragen für die Zielobjekte :
```
// A replication controller that we want to remove has 5 replicas
# kubectl get rc
CONTROLLER    CONTAINER(S)   IMAGE(S)   SELECTOR          REPLICAS   AGE
test-delete   test-delete    nginx      run=test-delete   5          19s
# kubectl get pod
NAME                READY     STATUS    RESTARTS   AGE
test-delete-g4xyy   1/1       Running   0          34s
test-delete-px9z6   1/1       Running   0          34s
test-delete-vctnk   1/1       Running   0          34s
test-delete-vsikc   1/1       Running   0          34s
test-delete-ye07h   1/1       Running   0          34s
// timing the response of "delete" and check the state of pod directly
# time kubectl delete rc test-delete && kubectl get pod
replicationcontroller "test-delete" deleted
real  0m2.028s
user  0m0.014s
sys  0m0.007s
NAME                READY     STATUS        RESTARTS   AGE
test-delete-g4xyy   1/1       Terminating   0          1m
test-delete-px9z6   0/1       Terminating   0          1m
test-delete-vctnk   1/1       Terminating   0          1m
test-delete-vsikc   0/1       Terminating   0          1m
test-delete-ye07h   1/1       Terminating   0          1m
```
Man kann sagen, dass die Reaktionszeit ziemlich kurz ist und die Umsetzung auch sofort ist.

### Tip
Entfernen von Pods aus dem Replikationscontroller

Es ist unmöglich, den Replikationscontroller zu entfernen oder zu skalieren, indem man Pods darauf löscht, denn während ein Pod entfernt wird, ist der Replikationscontroller nicht in seinem gewünschten Status, und der Controller Manager wird ihn bitten, einen anderen zu erstellen. Dieses Konzept wird in folgenden Befehlen dargestellt:
```
// Check replication controller and pod first
# kubectl get rc,pod
CONTROLLER        CONTAINER(S)      IMAGE(S)   SELECTOR              REPLICAS   AGE
test-delete-pod   test-delete-pod   nginx      run=test-delete-pod   3          12s
NAME                    READY     STATUS    RESTARTS   AGE
test-delete-pod-8hooh   1/1       Running   0          14s
test-delete-pod-jwthw   1/1       Running   0          14s
test-delete-pod-oxngk   1/1       Running   0          14s
// Remove certain pod and check pod status to see what happen 
# kubectl delete pod test-delete-pod-8hooh && kubectl get pod
NAME                    READY     STATUS        RESTARTS   AGE
test-delete-pod-8hooh   0/1       Terminating   0          1m
test-delete-pod-8nryo   0/1       Running       0          3s
test-delete-pod-jwthw   1/1       Running       0          1m
test-delete-pod-oxngk   1/1       Running       0          1m

```
### Wie es funktioniert…

Der replication controller definiert einen Satz von Pods durch eine Pod-Vorlage und Labels. Wie Sie aus früheren Abschnitten wissen, verwaltet der replication controller nur die pods durch ihre Labels. Es ist möglich, dass die Pod-Vorlage und die Konfiguration des Pods anders sind. Und es bedeutet auch, dass eigenständige Pods in eine Controller-Gruppe durch Label-Modifikation hinzugefügt werden können. Nach den folgenden Befehlen und Ergebnissen, lasst uns dieses Konzept auf Selektoren und Labels testen:
```
// Two pod existed in system already, they have the same label app=nginx
# kubectl get pod -L app -L owner
NAME       READY     STATUS    RESTARTS   AGE       APP       OWNER
web-app1   1/1       Running   0          6m        nginx     Amy
web-app2   1/1       Running   0          6m        nginx     Bob
```
Dann erstellen wir einen 3-pod replication controller mit dem selector `app=nginx`:
```
# kubectl run rc-wo-create-all --replicas=3 --image=nginx --labels="app=nginx"
replicationcontroller "rc-wo-create-all" created
```

Wir können feststellen, dass der replication controller den gewünschten Zustand von drei Pods erfüllt, aber nur einen Pod booten muss. Die pod `web-app1` und `web-app2` werden nun durch das Ausführen von `rc-wo-create-all `gesteuert:
```
# kubectl get pod -L app -L owner
NAME                     READY     STATUS    RESTARTS   AGE       APP       OWNER
rc-wo-create-all-jojve   1/1       Running   0          5s        nginx     <none>
web-app1                 1/1       Running   0          7m        nginx     Amy
web-app2                 1/1       Running   0          7m        nginx     Bob

# kubectl describe rc rc-wo-create-all
Name:    rc-wo-create-all
Namespace:  default
Image(s):  nginx
Selector:  app=nginx
Labels:    app=nginx
Replicas:  3 current / 3 desired
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen  LastSeen  Count  From        SubobjectPath  Reason      Message
  ─────────  ────────  ─────  ────        ─────────────  ──────      ───────
  1m    1m    1  {replication-controller }      SuccessfulCreate  Created pod: rc-wo-create-all-jojve
```
