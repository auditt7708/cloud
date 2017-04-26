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

Volumes werden im Volumenbereich der Pod-Definition mit einem eindeutigen Namen definiert.

Jede Art von Lautstärke hat eine andere Konfiguration, die eingestellt werden soll.

Sobald Sie die Volumes definiert haben, können Sie sie im Bereich `VolumeMounts` in Containerspezifikation einbinden. `spec`

`VolumeMounts.name` und volumeMounts.mountPath sind erforderlich, die den Namen der von Ihnen definierten Volumes und den Mount-Pfad im Container angeben.

Wir verwenden die Kubernetes-Konfigurationsdatei mit dem YAML-Format, um in den folgenden Beispielen einen Pod mit Volumes zu erstellen.

#### emptyDir

EmptyDir ist der einfachste Datenträgertyp, der ein leeres Volumen für Container im selben Pod zum Freigeben erzeugt.

Wenn der Pod entfernt wird, werden die Dateien in emptyDir gelöscht.

EmptyDir wird erstellt, wenn ein Pod erstellt wird.

In der folgenden Konfigurationsdatei erstellen wir einen Pod mit Ubuntu mit Befehlen für 3600 Sekunden zu schlafen.

Wie Sie sehen können, wird im Datenträgerbereich ein Datenträger mit Namensdaten definiert, und die Volumes werden unter / data-mount Pfad im Ubuntu-Container montiert:

