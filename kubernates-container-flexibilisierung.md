Pod, in Kubernetes, bedeutet eine Reihe von Containern, die auch die kleinste Recheneinheit ist. Sie haben vielleicht über die grundlegende Verwendung von Pod in den vorherigen Rezepten gewusst. Pods werden normalerweise von replication controllers verwaltet und von Diensten ausgesetzt; Sie arbeiten als Anwendungen mit diesem Szenario.

In diesem Rezept werden wir zwei neue Features besprechen: `job` und `daemon set` gesetzt. Diese beiden Funktionen können die Verwendung von Pods effektiver machen.

### Fertig werden

Was ist ein Job-like Pod und eine Daemon-like Pod? Pods in einem Kubernetes Job werden direkt beendet, nachdem sie ihre Arbeit abgeschlossen haben. Auf der anderen Seite wird ein Dämon-ähnlicher Pod in jedem Knoten erstellt, während die Benutzer es wünschen, dass es sich um ein langlebiges Programm handelt, das als System-Daemon diente.

Sowohl der Job als auch der Daemon-Set gehören zur Erweiterung der Kubernetes API. Außerdem ist der Daemon-Set-Typ in den Standard-API-Einstellungen deaktiviert. Dann müssen Sie die Nutzung später zum Testen aktivieren. Ohne die Einstellung des Daemon-Sets zu starten, bekommst du einen Fehler über den unbekannten Typ:
```
# kubectl create -f daemonset-test.yaml
error validating "daemonset-test.yaml": error validating data: couldn't find type: v1beta1.DaemonSet; if you choose to ignore these errors, turn validation off with --validate=false
Or error of this one
Error from server: error when creating "daemonset-free.yaml": the server could not find the requested resource
```
Um den im Kubernetes-System eingestellten Daemon zu aktivieren, solltest du ein Tag im Daemon des Kubernetes apiserver aktualisieren: `--runtime-config=extensions/v1beta1/daemonsets=true`. Ändern Sie Ihre Service-Scripts oder Konfigurationsoptionen:

```
// For service init.d scripts, attached the tag after command hyperkube apiserver or kube-apiserver
# cat /etc/init.d/kubernetes-master
(heading lines ignored)
:
# Start daemon.
echo $"Starting apiserver: "
daemon $apiserver_prog \
--service-cluster-ip-range=${CLUSTER_IP_RANGE} \
--insecure-port=8080 \
--secure-port=6443 \
--basic-auth-file="/root/ba_file" \
--address=0.0.0.0 \
--etcd_servers=${ETCD_SERVERS} \
--cluster_name=${CLUSTER_NAME} \
--runtime-config=extensions/v1beta1/daemonsets=true \
> ${logfile}-apiserver.log 2>&1 &
:
(ignored)
// For systemd service management, edit configuration files by add the tag as optional one
# cat /etc/kubernetes/apiserver
(heading lines ignored)
:
# Add your own!
KUBE_API_ARGS="--cluster_name=Happy-k8s-cluster --runtime-config=extensions/v1beta1/daemonsets=true"
```

Nachdem Sie das Tag eingerichtet haben, entfernen Sie das Verzeichnis `/tmp/kubectl.schema`, das API-Schemas speichert. Dann ist es gut, den Kubernetes apiserver neu zu starten:
```
// Remove the schema file
# rm -f /tmp/kubectl.schema
// The method to restart apiserver for init.d script
# service kubernetes-master restart
// Or, restart the daemon for systemd service management
# systemd restart kube-apiserver 
// After restart daemon apiserver, you can find daemonsets is enable in your API server
# curl http://localhost:8080/apis/extensions/v1beta1
{
  "kind": "APIResourceList",
  "groupVersion": "extensions/v1beta1",
  "resources": [
    {
      "name": "daemonsets",
      "namespaced": true
    },
    {
      "name": "daemonsets/status",
      "namespaced": true
    },
:
```
Als nächstes werden wir für die folgenden Abschnitte zeigen, wie man einen Job und einen Daemon mit Konfigurationsdateien erstellt. Schauen Sie sich das Rezept an. Arbeiten Sie mit Konfigurationsdateien in diesem Kapitel, um mehr über andere Konzepte zu erfahren.

### Wie es geht…

Es gibt keine Befehlszeilenschnittstelle für uns, um einen Job oder einen Daemon-Satz zu erstellen. Daher werden wir diese beiden Ressourcentypen erstellen, indem wir alle Konfigurationen in einer Vorlagendatei schreiben.
Pod als Job

Eine Job-ähnliche Pod eignet sich zum Testen Ihrer Container, die für Unit-Test oder Integrationstest verwendet werden können. Oder es kann für statisches Programm verwendet werden. Wie im folgenden Beispiel werden wir eine Job-Vorlage schreiben, um die im Image `ubuntu` installierten Pakete zu überprüfen:

```
# cat job-dpkg.yaml
apiVersion: extensions/v1beta1
kind: Job
metadata:
  name: package-check
spec:
  selector:
    matchLabels:
      image: ubuntu
      test: dpkg
  template:
    metadata:
      labels:
        image: ubuntu
        test: dpkg
        owner: Amy
    spec:
      containers:
      - name: package-check
        image: ubuntu
        command: ["dpkg-query", "-l"]
      restartPolicy: Never
```

Eine Jobressource benötigt einen Selektor, um festzulegen, welche Pods als dieser Job abgedeckt werden sollen. Wenn in der Vorlage kein Selektor angegeben ist, wird es genau so sein wie die Etiketten des Auftrags. Die Neustart-Richtlinie für Pods, die in einem Job erstellt wurden, sollte auf `Never` oder `OnFailure` gesetzt werden, da ein Job zur Kündigung geht, sobald er erfolgreich abgeschlossen wurde.

Jetzt sind Sie bereit, einen Job mit Ihrer Vorlage zu erstellen:
```
# kubectl create -f job-dpkg.yaml
job "package-check" created
```
Nach dem Drücken der angeforderten Datei ist es möglich, den Status sowohl des Pods als auch des Jobs zu überprüfen:
```
# kubectl get job
JOB             CONTAINER(S)    IMAGE(S)   SELECTOR                           SUCCESSFUL
package-check   package-check   ubuntu     image in (ubuntu),test in (dpkg)   1
// Check the job as well
# kubectl get pod
NAME                         READY     STATUS    RESTARTS   AGE
package-check-jrry1          0/1       Pending   0          6s

```
Sie werden feststellen, dass ein Pod bootet für die Behandlung dieser Aufgabe. Diese Hülse wird sehr bald am Ende des Prozesses gestoppt werden. Die Unterbefehls `logs` helfen, das Ergebnis zu erhalten:

```
# kubectl logs package-check-gtyrc
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                            Version                          Architecture Description
+++-===============================-================================-============-===============================================================================
ii  adduser                         3.113+nmu3ubuntu3                all          add and remove users and groups
ii  apt                             1.0.1ubuntu2.10                  amd64        commandline package manager
ii  apt-utils                       1.0.1ubuntu2.10                  amd64        package management related utility programs
ii  base-files                      7.2ubuntu5.3                     amd64        Debian base system miscellaneous files
:
(ignored)

```
Bitte gehen Sie vor und überprüfen Sie die Job `package-check` mit dem Unterbefehl `describe`; Die Bestätigung für Pod-Abschluss und andere Meldungen werden als Systeminformation angezeigt:
`# kubectl describe job package-check`

Später, um den Job zu entfernen, den du gerade erstellt hast, hörst du mit dem Namen auf:

```
# kubectl stop job package-check
job "package-check" deleted
```

### Erstellen eines Jobs mit mehreren Pods ausgeführt

Benutzer kann auch die Anzahl der Aufgaben entscheiden, die in einem einzigen Job beendet werden sollen. Es ist hilfreich, einige zufällige und Stichprobenprobleme zu lösen. Versuchen wir es im selben Vorlage im vorherigen Beispiel. Wir müssen das Spec.completions-Element hinzufügen, um die Pod-Nummer anzugeben:
```
# cat job-dpkg.yaml
apiVersion: extensions/v1beta1
kind: Job
metadata:
  name: package-check
spec:
  completions: 3
  template:
    metadata:
      name: package-check-amy
      labels:
        image: ubuntu
        test: dpkg
        owner: Amy
    spec:
      containers:
      - name: package-check
        image: ubuntu
        command: ["dpkg-query", "-l"]
      restartPolicy: Never

```
Dann überprüfen Sie, wie der Job aussieht wie mit dem Unterbefehl `describe`:

```
# kubectl describe job package-check
Name:    package-check
Namespace:  default
Image(s):  ubuntu
Selector:  image in (ubuntu),owner in (Amy),test in (dpkg)
Parallelism:  3
Completions:  3
Labels:    image=ubuntu,owner=Amy,test=dpkg
Pods Statuses:  3 Running / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen  LastSeen  Count  From  SubobjectPath  Reason      Message
  ─────────  ────────  ─────  ────  ─────────────  ──────      ───────
  6s    6s    1  {job }      SuccessfulCreate  Created pod: package-check-dk184
  6s    6s    1  {job }      SuccessfulCreate  Created pod: package-check-3uwym
  6s    6s    1  {job }      SuccessfulCreate  Created pod: package-check-eg4nl
```

Wie Sie sehen können, werden drei Pods geschaffen, um diesen Job zu lösen. Auch da der Selektorteil entfernt wird, wird der Selektor aus den Etiketten kopiert.

### Pod als Dämon einsetzen

Wenn ein Kubernetes-Daemon-Set erstellt wird, wird der definierte Pod in jedem einzelnen Knoten eingesetzt. Es ist garantiert, dass die laufenden Container in jedem Knoten gleiche Ressourcen einnehmen. In diesem Szenario arbeitet der Container normalerweise als Daemon-Prozess.

Zum Beispiel hat die folgende Vorlage einen `ubuntu` Image container, der die Speicherbenutzung halb so lange überprüft. Wir werden es als Dämon-Set aufbauen:
```
# cat daemonset-free.yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: ram-check
spec:
  selector:
    app: checkRam
    version: v1
  template:
    metadata:
      labels:
        app: checkRam
        owner: Amy
        version: v1
    spec:
      containers:
      - name: ubuntu-free
        image: ubuntu
        command: ["/bin/bash","-c","while true; do free; sleep 30; done"]
      restartPolicy: Always
```
Als Job könnte der Selektor ignoriert werden, aber es nimmt die Werte der Etiketten. Wir werden immer die Neustart-Police des Daemon-Sets als `Always` konfigurieren, was dafür sorgt, dass jeder Knoten einen Pod läuft.

Die Abkürzung des Dämonsatzes ist `ds`; Verwenden Sie diese kürzere in der Kommandozeilen-Schnittstelle für die Bequemlichkeit:
```
# kubectl create -f daemonset-free.yaml
daemonset "ram-check" created
# kubectl get ds
NAME        CONTAINER(S)   IMAGE(S)   SELECTOR                  NODE-SELECTOR
ram-check   ubuntu-free    ubuntu     app=checkRam,version=v1   <none>
// Go further look at the daemon set by "describe"
# kubectl describe ds ram-check
Name:    ram-check
Image(s):  ubuntu
Selector:  app=checkRam,version=v1
Node-Selector:  <none>
Labels:    app=checkRam,owner=Amy,version=v1
Desired Number of Nodes Scheduled: 3
Current Number of Nodes Scheduled: 3
Number of Nodes Misscheduled: 0
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Events:
  FirstSeen  LastSeen  Count  From    SubobjectPath  Reason      Message
  ─────────  ────────  ─────  ────    ─────────────  ──────      ───────
  3m    3m    1  {daemon-set }      SuccessfulCreate  Created pod: ram-check-bti08
  3m    3m    1  {daemon-set }      SuccessfulCreate  Created pod: ram-check-u9e5f
  3m    3m    1  {daemon-set }      SuccessfulCreate  Created pod: ram-check-mxry2
```
Hier haben wir drei Pods, die in getrennten Knoten laufen. Sie können noch im Kanal der Pod erkannt werden:
```
# kubectl get pod --selector=app=checkRam
NAME              READY     STATUS    RESTARTS   AGE
ram-check-bti08   1/1       Running   0          4m
ram-check-mxry2   1/1       Running   0          4m
ram-check-u9e5f   1/1       Running   0          4m
// Get the evidence!
# kubectl describe pods --selector=app=checkRam -o wide
NAME              READY     STATUS    RESTARTS   AGE   NODE
ram-check-bti08   1/1       Running   0          4m    kube-node1
ram-check-mxry2   1/1       Running   0          4m    kube-node3
ram-check-u9e5f   1/1       Running   0          4m    kube-node2
```
Es ist gut für Sie, das Ergebnis mit den Unterbefehls `logs` zu bewerten:
```
# kubectl logs ram-check-bti08
             total       used       free     shared    buffers     cached
Mem:       2051644    1256876     794768        148     136880     450620
-/+ buffers/cache:     669376    1382268
Swap:            0          0          0
             total       used       free     shared    buffers     cached
Mem:       2051644    1255888     795756        156     136912     450832
-/+ buffers/cache:     668144    1383500
Swap:            0          0          0
:
(ignored)
```
Als nächstes löschen Sie diesen Dämon, der durch die Referenz der Vorlagendatei oder durch den Namen der Ressource gesetzt wird:
```
# kubectl stop -f daemonset-free.yaml
// or 
# kubectl stop ds ram-check
```
Der Dämon wird nur auf bestimmten Knoten gesetzt

Es gibt auch eine Lösung für Sie, um Daemon-ähnliche Pods einfach auf bestimmten Knoten zu implementieren. Zuerst müssen Sie Knoten in Gruppen machen, indem sie sie markieren. Wir werden nur den Knoten `kube-node3` mit dem speziellen Key-Value-Label markieren, der denjenigen zum Ausführen des Daemon-Sets anzeigt:
```
# kubectl label nodes kube-node3 runDS=ok
node "kube-node3" labeled
# kubectl get nodes
NAME           LABELS                                         STATUS    AGE
kube-node1   kubernetes.io/hostname=kube-node1             Ready     27d
kube-node2   kubernetes.io/hostname=kube-node2             Ready     27d
kube-node3   kubernetes.io/hostname=kube-node3,runDS=ok   Ready     4d
```
Dann wählen wir diese einteilige Gruppe in der Vorlage aus. Der Eintrag `spec.template.spec.nodeSelector` kann beliebige key-value(Schlüsselwertpaare) für die Knotenauswahl hinzufügen:
```
# cat daemonset-free.yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: ram-check
spec:
  selector:
    app: checkRam
    version: v1
  template:
    metadata:
      labels:
        app: checkRam
        owner: Amy
        version: v1
    spec:
      nodeSelector:
        runDS: ok
      containers:
      - name: ubuntu-free
        image: ubuntu
        command: ["/bin/bash","-c","while true; do free; sleep 30; done"]
      restartPolicy: Always

```

Beim Zuweisen des Dämonsatzes zu einer bestimmten Knotengruppe können wir ihn in einem einzigen Knoten des Drei-Knoten-Systems ausführen:

```
# kubectl describe pods --selector=app=checkRam | grep "Node"
Node:        kube-node3/10.96.219.251
```

### Wie es funktioniert…

Obwohl Job und Daemon gesetzt sind die besonderen Dienstprogramme von Pods, hat das Kubernetes-System verschiedene Managements zwischen ihnen und Pods.

Für den Job kann sein Selektor nicht auf den vorhandenen Pod zeigen. Es ist aus Angst, einen Pod zu nehmen, der vom Replikationscontroller als Job gesteuert wird. Der Replikationscontroller hat eine gewünschte Anzahl von Pods, die gegen die ideale Situation des Jobs sind: Pods sollten gelöscht werden, sobald sie die Aufgaben beenden. Die Pod in der Replikation Controller wird nicht den Zustand des Endes.

Auf der anderen Seite, anders als die allgemeine Pod, kann ein Pod in einem Daemon-Set ohne den Kubernetes Scheduler erstellt werden. Dieses Konzept ist offensichtlich, weil der Dämon-Set nur die Etiketten von Knoten berücksichtigt, nicht ihre CPU- oder Speicherverwendung.