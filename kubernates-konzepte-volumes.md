Dateien in einem Container sind kurzlebig. Wenn der Container beendet ist, sind die Daten verschwunden. Docker hat Datenmengen und Datenmengencontainer eingeführt, um uns bei der Verwaltung der Daten zu helfen, indem wir aus dem Hostdatenträgerverzeichnis oder aus anderen Containern installieren. Allerdings, wenn es um einen Container-Cluster geht, ist es schwer Volumen zu verwalten über Hosts und durch ihre Lebensdauer mit Docker.

Kubernetes führt Volumen ein, das mit einem Pod über Container-Neustarts lebt. Es unterstützt die folgenden verschiedenen Arten von Netzwerk-Festplatten:

* emptyDir
* hostPath
* nfs
* iscsi
* flocker
* glusterfs
* rbd
* gitRepo
* awsElasticBlockStore
* gcePersistentDisk
* secret
* downwardAPI

In diesem Abschnitt gehen wir durch die Details von emptyDir, hostPath, nfs und glusterfs. Secret, das verwendet wird, um Anmeldeinformationen zu speichern, wird im nächsten Abschnitt eingeführt. Die meisten von ihnen haben eine ähnliche Kubernetes-Syntax mit einem anderen Backend.

### Fertig werden

Die Speicheranbieter\(Storage Provider\) sind erforderlich, wenn Sie beginnen, das Volumen in Kubernetes zu verwenden, außer für emptyDir, das gelöscht wird, wenn der Pod entfernt wird. Für andere Speicheranbieter müssen Ordner, Server oder Cluster gebaut werden, bevor sie in der Pod-Definition verwendet werden können.

Unterschiedliche Datenträgertypen haben unterschiedliche Speicheranbieter:

| Volume Typ | Storage Provider |
| :---: | :---: |
| `emptyDir` | Local host |
| `hostPath` | Local host |
| `nfs` | NFS server |
| `iscsi` | iSCSI target provider |
| `flocker` | Flocker cluster |
| `glusterfs` | GlusterFS cluster |
| `rbd` | Ceph cluster |
| `gitRepo` | Git repository |
| `awsElasticBlockStore` | AWS EBS |
| `gcePersistentDisk` | GCE persistent disk |
| `secret` | Kubernetes configuration file |
| `downwardAPI` | Kubernetes pod information |

### Wie es geht…

Volumes werden in der volumes section der Pod-Definition mit einem eindeutigen Namen definiert.
Jede Art von Volume hat eine andere Konfiguration, die eingestellt werden muss.
Sobald Sie die Volumes definiert haben, können Sie sie im Bereich `volumeMounts` in der Container `spec`. S ind `VolumeMounts.name` und `volumeMounts.mountPath`  erforderlich, die den Namen der von Ihnen definierten Volumes und den Mount-Pfade im Container angeben.

Wir verwenden die Kubernetes-Konfigurationsdatei mit dem YAML-Format, um in den folgenden Beispielen einen Pod mit Volumes zu erstellen.

#### emptyDir

`emptyDir` ist der einfachste Datenträgertyp, der ein leeres Volumen für Container im selben Pod zum Freigeben erzeugt.
Wenn der Pod entfernt wird, werden die Dateien in `emptyDir` gelöscht.
`emptyDir` wird erstellt, wenn ein Pod erstellt wird.

In der folgenden Konfigurationsdatei erstellen wir einen Pod mit Ubuntu mit Befehlen um für 3600 Sekunden zu schlafen.

Wie Sie sehen können, wird im Datenträgerbereich ein Datenträger mit Namen `daten` definiert, und die Volumes werden unter `/data-mount` Pfad im Ubuntu-Container montiert:
```
// configuration file of emptyDir volume
# cat emptyDir.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
labels:
  name: ubuntu
spec:
  containers:
    -
      image: ubuntu
      command:
        - sleep
        - "3600"
      imagePullPolicy: IfNotPresent
      name: ubuntu
      volumeMounts:
        -
          mountPath: /data-mount
          name: data
  volumes:
    -
      name: data
      emptyDir: {}

// create pod by configuration file emptyDir.yaml
# kubectl create -f emptyDir.yaml

```

###### Tip

Überprüfen Sie, auf welchen Knoten ein Pod läuft

Durch die Verwendung des Befehls `kubectl beschreiben pod <Pod name> | grep Node` kann man überprüfen, auf welchen Knoten der Pod läuft.


Nachdem der Pod ausgeführt wurde, könntest du dann Docker auf dem Zielknoten überprüfen und die detaillierten Mountpunkte in deinem Container ansehen:
```
    "Mounts": [
        {
            "Source": "/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~empty-dir/data",
            "Destination": "/data-mount",
            "Mode": "",
            "RW": true
        },
      ...
     ]
```

Hier sehen Sie Kubernetes einfach einen leeren Ordner mit dem Pfad `/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~empty-dir/<volumeMount name>` für den Pod zu verwenden. Wenn Sie einen Pod mit mehr als einem Container erstellen, werden alle von ihnen das gleiche Ziel /Daten-Mount mit der gleichen Quelle zu mounten.

`EmptyDir` könnte als `tmpfs` gemountet werden, wenn wir die Datei `emptyDir.medium` auf `Memory` in der vorherigen Konfigurationsdatei `emptyDir.yaml` benuzen würde es folgender maßen aussehen:
```
  volumes:
    -
      name: data
      emptyDir:
        medium: Memory
```

Wir könnten auch die `Volumes` Informationen mit `kubectl describe pods ubuntu` sehen, und ob es erfolgreich gesetzt ist:
```
# kubectl describe pods ubuntu
Name:        ubuntu
Namespace:      default
Image(s):      ubuntu
Node:        ip-10-96-219-192/
Status:        Running
...
Volumes:
  data:
    Type:  EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:  Memory

```

### HostPath

`HostPath` fungiert als Datenvolumen im Docker. Der lokale Ordner auf einem in `hostPath` aufgelisteten Nodes wird in den Pod eingebunden. Da der Pod auf beliebigen Nodes laufen kann, können Lese- / Schreibfunktionen, die im Volume auftreten, explizit in dem Node existieren, der auf dem Pod läuft. In Kubernetes sollte der Pod aber nicht wissen welcher Node ist. Bitte beachten Sie, dass die Konfiguration und Dateien bei der Verwendung von `HostPath` auf verschiedenen Nodes unterschiedlich sein können. Daher kann das gleiche Pod, das durch dieselbe Befehls- oder Konfigurationsdatei erstellt wurde, auf verschiedenen Nodes unterschiedlich sein.

Durch die Verwendung von `hostPath` können Sie die Dateien zwischen Containern und lokalen Hostdatenträgern von Nodes lesen und schreiben. Was wir für die Volumendefinition benötigen, ist für `hostPath.path`, um den Ziel-angehängten Ordner auf dem Node anzugeben:
```
// configuration file of hostPath volume
# cat hostPath.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
spec:
  containers:
    -
      image: ubuntu
      command:
        - sleep
        - "3600"
      imagePullPolicy: IfNotPresent
      name: ubuntu
      volumeMounts:
        -
          mountPath: /data-mount
          name: data
  volumes:
    -
      name: data
      hostPath:
        path: /target/path/on/host
```
Mit `docker inspect`, um die Volume Details zu überprüfen, sehen Sie die Volumes auf dem Host ist also in `/data-mount` gemountet:
```
    "Mounts": [
        {
            "Source": "/target/path/on/host",
            "Destination": "/data-mount",
            "Mode": "",
            "RW": true
        },
      ...
    ]
```

###### Tip
Anlegen einer Datei, um zu bestätigen, dass das Volume erfolgreich installiert wurde

Mit `kubectl exec <pod name> <command>` kannst du den Befehl innerhalb eines Pods ausführen. In diesem Fall, wenn wir `kubectl exec ubuntu touch /data-mount/sample` ausführen, sollten wir in der Lage sein, eine leere Datei namens `sample` unter `/target/path/on/host` zu sehen.

### nfs

Sie können das **Netzwerk-Dateisystem (NFS)** auf Ihrem Pod als `nfs` Volume installieren. Mehrere Pods können die Dateien im selben `nfs` Volume einbinden und teilen. Die im `nfs` Volume gespeicherten Daten werden über die Lebensdauer des Pods persistent. Sie müssen Ihren eigenen [NFS-Server]() erstellen, bevor Sie nfs volume verwenden und sicherstellen, dass das Paket nfs-utils auf den Kubernetes-Knoten installiert ist.

###### Notiz
Überprüfen, ob der nfs-Server funktioniert, bevor Sie forfahren

Sie sollten sich herausstellen, dass die Datei `/etc/exports` ordnungsgemäße Freigabeparameter und Verzeichnis hat und den Befehl `mount -t nfs <nfs server>: <share name> <local mounted point>` verwendet, um zu überprüfen, ob es lokal gemountet werden könnte.

Die Konfigurationsdatei eines Datenträgertyps mit `nfs` ist ähnlich wie bei anderen, aber der `nfs.server` und `nfs.path` sind in der Datenträgerdefinition erforderlich, um die NFS-Serverinformationen anzugeben und die vom  Pfad zu mounten. `nfs.readOnly` ist ein optionales Feld für die Angabe, ob das Volume schreibgeschützt ist oder nicht (Standard ist false):
```
// configuration file of nfs volume
# cat nfs.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nfs
spec:
  containers:
    -
      name: nfs
      image: ubuntu
      volumeMounts:
          - name: nfs
            mountPath: "/data-mount"
  volumes:
  - name: nfs
    nfs:
      server: <your nfs server>
      path: "/"
```

Nachdem du `kubectl create -f nfs.yaml` ausgeführt hast, kannst du deinen Pod beschreibungen durchführen, indem du `kubectl describe <pod name>` um den mount status zu überprüfen verwendest. Wenn es erfolgreich gemountet ist, sollte es Bedingungen anzeigen. Es ist bereit, wenn es true ist und das Ziel nfs gemountet ist:
```
Conditions:
  Type    Status
  Ready   True
Volumes:
  nfs:
    Type:  NFS (an NFS mount that lasts the lifetime of a pod)
    Server:  <your nfs server>
    Path:  /
    ReadOnly:  false
```

Wenn wir den Container inspizieren, sehen Sie die Volume-Informationen im Bereich Mounts:

```
    "Mounts": [
 {
            "Source": "/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~nfs/nfs",
            "Destination": "/data-mount",
            "Mode": "",
            "RW": true
        },
      ...
     ]
```

Tatsächlich mountet Kubernetes einfach Ihren `<nfs server>:<share name>` in `/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~nfs/nfs` und tut ihn dann in einen Container als Ziel in das `/data-mount` Verzeichnis. Sie können auch `kubectl exec` verwenden, um die Datei zu erstellen, wie es im vorherige Tipp erwähnt wurde, um zu testen, ob es gemountet ist.

### Glusterfs

**GlusterFS** (https://www.gluster.org) ist ein skalierbares, netzwerkbasiertes Dateisystem. Mit dem Glusterfs-Datenträgertyp können Sie das `glusterfs` Volume in Ihren Pod einsetzen. Genau wie das NFS-Volume sind die Daten im GlusterFS-Volume über die Lebensdauer des Podes persident. Wenn der Pod beendet ist, sind die Daten im GlusterFS-Volume noch zugänglich. Sie müssen ein GlusterFS-System erstellen, bevor Sie ein GlusterFS-Volume verwenden.

###### Notiz
Überprüfen Sie ob das GlusterFS funktioniert, bevor Sie fortfahren.

Durch die Verwendung von `gluster volume info` auf GlusterFS-Servern können Sie derzeit verfügbare Volumes sehen. Durch die Verwendung von `mount -t glusterfs <glusterfs server>:/<volume name> <local mounted point> lokal` können Sie überprüfen, ob das GlusterFS-System erfolgreich gemountet werden kann.


Da die Volume replik in GlusterFS größer als 1 sein muss, nehmen wir an, wir haben zwei Repliken in den Servern `gfs1` und `gfs2` und der Datenträgername ist `gvol`.

Zuerst müssen wir einen Endpunkt erstellen, der als Brücke für `gfs1` und `gfs2` fungiert:
```
# cat gfs-endpoint.yaml
kind: Endpoints
apiVersion: v1
metadata:
  name: glusterfs-cluster
subsets:
  -
    addresses:
      -
        ip: <gfs1 server ip>
    ports:
      -
        port: 1
  -
    addresses:
      -
        ip: <gfs2 server ip>
    ports:
      -
        port: 1

// create endpoints
# kubectl create -f gfs-endpoint.yaml
```

Dann könnten wir `kubectl get endpoints` verwenden, um Endpunkte zu erhalten, um zu überprüfen, ob der Endpunkt richtig erstellt wurde führen wir folgendes aus:
```
# kubectl get endpoints
NAME                ENDPOINTS                         AGE
glusterfs-cluster   <gfs1>:1,<gfs2>:1                 12m

```

Danach sollten wir in der Lage sein, den Pod mit dem GlusterFS-Volume von `glusterfs.yaml` zu erstellen. Die Parameter `glusterfs` der Volumendefinition sind `glusterfs.endpoints`, die den soeben erstellten Endpunktnamen angeben, und der `glusterfs.path`, der der Datenträgername `gvol` ist. `glusterfs.readOnly` und wird verwendet, um festzulegen, ob das Volume im schreibgeschützten Modus eingebunden ist:
```
# cat glusterfs.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
spec:
  containers:
    -
      image: ubuntu
      command:
        - sleep
        - "3600"
      imagePullPolicy: IfNotPresent
      name: ubuntu
      volumeMounts:
        -
          mountPath: /data-mount
          name: data
  volumes:
    -
      name: data
      glusterfs:
        endpoints: glusterfs-cluster
        path: gvol

```

Überprüfen Sie die Volumes mit `kubectl describe`:
```
Volumes:
  data:
    Type:    Glusterfs (a Glusterfs mount on the host that shares a pod's lifetime)
    EndpointsName:  glusterfs-cluster
    Path:    gvol
    ReadOnly:    false
```

Mit `docker inspect` Sie sollten in der Lage sein, die angehängte Quelle zu sehen z.B `/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~glusterfs/data` zum Ziel `/data-mount`.

### iscsi

Das `iscsi` Volume wird verwendet, um die vorhandene iSCSI an Ihren Pod zu montieren. Im Gegensatz zu `nfs` Volumen darf das `iscsi` Volumen nur in einem einzigen Container im Read-Write-Modus gemountet werden. Die Daten werden über den Lebenszyklus der Pods erhalten:

|Feld Name|Feld Defination|
|`targetPortal`|IP-Adresse des iSCSI target portals|
|`iqn`|IQN des target portal|
|`Lun`|Target LUN fürs mounten|
|`fsType`|File system typ des LUN Dateisystems|
|`readOnly`| read-only mounten oder nicht, default ist false|

### flocker

Flocker ist ein Open-Source-Container-Datenvolumenmanager. Das `flocker` Volumen wird zum Zielknoten verschoben, wenn sich der Container bewegt. Vor der Verwendung von Flocker mit Kubernetes ist der Flocker-Cluster (Flocker-Kontrolldienst, Flocker-Dataset-Agent, Flocker-Container-Agent) erforderlich. Die offizielle Website von Flocker (https://docs.clusterhq.com/de/1.8.0/install/index.html) enthält detaillierte Installationsanweisungen.

Nachdem Sie Ihren Flocker-Cluster bereit gemacht haben, erstellen Sie einen Dataset und geben Sie den Dataset-Namen in der Flocker-Volume-Definition in der Konfigurationsdatei von Kubernetes an:
|Feld Name| Feld Beschreibung|
| :---: | :---: |
|`datasetName`|Target dataset name in Flocker|

### rbd

Ceph RADOS Block Device (http://docs.ceph.com/docs/master/rbd/rbd/) könnte in deinem Pod gemountet werden, indem du rbd volume benutzt. Sie müssen Ceph installieren, bevor Sie das rbd-Volume verwenden. Die Definition von rbd-Datenträgerunterstützung ist geheim, um Authentifizierungs secrets zu behalten:

|Feld Name|Feld Beschreibung|Default Wert|
| :---: | :---: | :---: |
|`monitors`|Cepth monitors|keiner|
|`pool`|Der name des RADOS Pools|keiner|
|`image`| Das image das von rpd erstellt wurde|`rbd`|
|`user`|RADOS user Name|`admin`|
|`keyring`|Der Pfad zum keyring, wird überschrieben wenn ein secret name verfügbar ist|`/etc/ceph/keyring`|
|`secretName`|Secret Name|keiner|
|`fsType`|File system Typ| keiner|
|`readOnly`|Setzen in read only modus|False|

### GitRepo

Das `gitRepo` Volume wird als leeres dictionary gemountet und Git clone ein Repository mit einer bestimmten Revision in einem Pod um Sie zu verwenden:

|Feld Name|Feld Beschreibung|
| :---: | :---: |
|`repository`|Dein repository mit SSH oder HTTPS|
|`Revision`|Die revision des repositories|
|`readOnly`|Angabe ob read-only oder nicht|


### AwsElasticBlockStore

`awsElasticBlockStore` Volume unterstützt ein AWS-EBS-Volume in einem Pod. Um es zu nutzen, musst du deinen Pod auf AWS EC2 mit der gleichen Verfügbarkeit Zone mit EBS laufen lassen. Denn jetzt unterstützt EBS nur die Anbindung an ein EC2 in der Praxis, so dass es bedeutet, dass man kein einzelnes EBS-Volume an mehrere EC2-Instanzen anhängen kann:

|Feld Name|Feld Beschreibung|
| :---: | :---: |
|`volumeID`|EBS volume info - `aws://<availability-zone>/<volume-id>`|
|`fsType`|File system Typ|
|`readOnly`|Angabe ob read-only oder nicht|

### GcePersistentDisk

Ähnlich wie bei `awsElasticBlockStore` muss die Pod mit dem `gcePersistentDisk`-Volume auf GCE mit demselben Projekt und Zone laufen. Die `gcePersistentDisk` unterstützt nur einen einzigen Schreibenden zugriff, wenn `readOnly=false`:

|Feld Name|Feld Beschreibung|
| :---: | :---: |
|`pdName`|GCE persistent disk Name|
|`fsType`|File system Typ|
|`readOnly`|Angabe ob read-only oder nicht|

### downwardAPI

Das `downwardAPI` Volume ist ein Kubernetes-Volume-Plugin mit der Möglichkeit, einige Pod-Informationen in einer Klartextdatei in einen Container zu speichern. Die aktuellen unterstützenden Metadaten des `downwardAPI` Volumes sind:

* metadata.annotations
* metadata.namespace
* metadata.name
* metadata.labels

Die Definition des `downwardAPI` ist eine Liste von Items. Ein Element enthält einen `path` und `fieldRef`. Kubernetes werden dann die im `FeldRef` aufgelisteten Metadaten auf eine Datei namens `path` unter `mountPath` übergeben und den `<volume name>` in das angegebene Ziel einfügen:
```
        {
            "Source": "/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~downward-api/<volume name>",
            "Destination": "/tmp",
            "Mode": "",
            "RW": true
        }
```

Um für die IP den Pod, mit der Umgebungsvariable, in der Pod-Spezifikation zu verbreiten  wäre es viel einfacher folgendes durchzuführen:
```
spec:
  containers:
    - name: envsample-pod-info
      env:
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
```

Für weitere Beispiele schau dir den Beispielordner in Kubernetes GitHub an (https://github.com/kubernetes/kubernetes/tree/master/docs/user-guide/downward-api), der mehr Beispiele für Umgebungsvariablen und `downwardAPI` Datenträger enthält .

### Es gibt mehr…

In früheren Fällen musste der Benutzer die Details des storage consumer kennen. Kubernetes stellt `PersistentVolume(PV)` zur Verfügung, um die Details des storage consumer und des storage consumer zu abstrahieren. Kubernetes unterstützt derzeit die PV-Typen wie folgt:

* GCEPersistentDisk

* AWSElasticBlockStore

* NFS

* iSCSI

* RBD (Ceph Block Device)

* GlusterFS

* HostPath ( geht nicht in multi-node clustern)

### PersistentVolume

Die Darstellung des persistenten Volumens ist in der folgenden Grafik dargestellt. Zuerst regelt der Administrator die Spezifikation eines `PersistentVolums`. Zweitens bieten sie Verbraucheranforderungen für die Lagerung durch `PersistentVolumeClaim` an. Schließlich nimmt die Pod das Volumen durch die Referenz des `PersistentVolumeClaim`:

![persistent-volume-claims](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_05.jpg)

Der Administrator muss das persistente Volumen zuerst reservieren und zuordnen.

Hier ist ein Beispiel mit NFS:

```
// example of PV with NFS
# cat pv.yaml
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pvnfs01
  spec:
    capacity:
      storage: 3Gi
    accessModes:
      - ReadWriteOnce
    nfs:
      path: /
      server: <your nfs server>
    persistentVolumeReclaimPolicy: Recycle

// create the pv
# kubectl create -f pv.yaml
persistentvolume "pvnfs01" created
```

Wir können sehen, dass es hier drei Parameter gibt: `capacity`, `accessModes` und `persistentVolumeReclaimPolicy`. `capacity` ist die Größe dieser PV. `AccessModes` basiert auf der Fähigkeit des Speicheranbieters und kann bei der Bereitstellung auf einen bestimmten Modus eingestellt werden. Zum Beispiel unterstützt NFS mehrere Leser und Schreiber gleichzeitig, so dass wir die `accessModes` als `ReadWriteOnce`, `ReadOnlyMany` oder `ReadWriteMany` angeben können. Die `accessModes` eines Volumes können jeweils auf einen Modus eingestellt werden. `PersistentVolumeReclaimPolicy` wird verwendet, um das Verhalten zu definieren, wenn PV freigegeben wird. Derzeit ist die unterstützte Richtlinie Retain und `Recycle` für nfs und `hostPath`. Sie müssen die Lautstärke selbst im Retain-Modus reinigen. Auf der anderen Seite wird Kubernetes die Lautstärke im `Recycle` Modus schrubben.

PV ist eine Ressource wie Knoten. Wir könnten `kubectl get pv`, um aktuelle bereitgestellte PVs zu sehen:
```
// list current PVs
# kubectl get pv
NAME      LABELS    CAPACITY   ACCESSMODES   STATUS    CLAIM               REASON    AGE
pvnfs01   <none>    3Gi        RWO           Bound     default/pvclaim01             37m
```


Als nächstes müssen wir `PersistentVolume` mit `PersistentVolumeClaim` binden, um es als Volumen in den Pod zu bringen:

```
// example of PersistentVolumeClaim
# cat claim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvclaim01
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

// create the claim
# kubectl create -f claim.yaml
persistentvolumeclaim "pvclaim01" created

// list the PersistentVolumeClaim (pvc)
# kubectl get pvc
NAME        LABELS    STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
pvclaim01   <none>    Bound     pvnfs01   3Gi        RWO           59m
```
Die Einschränkungen von `accessModes` und `storage` können in der `PersistentVolumeClaim` gesetzt werden. Wenn der Anspruch erfolgreich `Bound` ist, wird sein Status `Unbound` wenden; Umgekehrt, wenn der Status Ungebunden ist, bedeutet dies, dass derzeit keine PV mit den Anfragen übereinstimmt.

Dann können wir die PV als Volumen mit `PersistentVolumeClaim` anbringen:
```
// example of mounting into Pod
# cat nginx.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    project: pilot
    environment: staging
    tier: frontend
spec:
  containers:
    -
      image: nginx
      imagePullPolicy: IfNotPresent
      name: nginx
      volumeMounts:
      - name: pv
        mountPath: "/usr/share/nginx/html"
      ports:
      - containerPort: 80
  volumes:
    - name: pv
      persistentVolumeClaim:
        claimName: "pvclaim01"

// create the pod
# kubectl create -f nginx.yaml
pod "nginx" created
```
Die Syntax ähnelt dem anderen Datenträgertyp. Füge einfach den `ClaimName` des `persistentVolumeClaim` in die Volume-Definition hinzu. Wir sind alle da! Überprüfen Sie die Details, um zu sehen, ob wir es erfolgreich montiert haben:

```
// check the details of a pod
# kubectl describe pod nginx
...
Volumes:
  pv:
    Type:  PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  pvclaim01
    ReadOnly:  false
...

```
Wir können sehen, dass wir ein Volume in der Pod nginx mit Typ `pv` `pvclaim01` montiert haben. Verwenden Sie `docker inspect`, um zu sehen, wie es montiert ist:
```
     "Mounts": [
        {
            "Source": "/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~nfs/pvnfs01",
            "Destination": "/usr/share/nginx/html",
            "Mode": "",
            "RW": true
        },
      ...
    ]
```

Kubernetes mounts `/var/lib/kubelet/pods/<id>/volumes/kubernetes.io~nfs/< persistentvolume name>` in das Ziel in der Pod.

### Siehe auch

Volumes werden in Container-Spezifikationen in Pods oder Replikations-Controller gesetzt. Schauen Sie sich die folgenden Rezepte an, um Ihr Gedächtnis zu trainieren:

* Arbeiten mit pods
* Arbeiten mit einem replication controller