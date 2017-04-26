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

Das iscsi-Volume wird verwendet, um die vorhandene iSCSI an Ihren Pod zu montieren. Im Gegensatz zu nfs-Volumen darf das iscsi-Volumen nur in einem einzigen Container im Read-Write-Modus montiert werden. Die Daten werden über den Lebenszyklus der Pod gehalten:
|Feld Name|Feld Defination|
|`targetPortal`|IP-Adresse des iSCSI target portals|
|`iqn`|IQN des target portal|
|`Lun`|Target LUN fürs mounten|
|`fsType`|File system typ des LUN Dateisystems|
|`readOnly`| read-only mounten oder nicht, default ist false|