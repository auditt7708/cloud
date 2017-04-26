Dateien in einem Container sind kurzlebig. Wenn der Container beendet ist, sind die Dateien verschwunden. Docker hat Datenmengen und Datenmengencontainer eingeführt, um uns bei der Verwaltung der Daten zu helfen, indem wir aus dem Hostdatenträgerverzeichnis oder aus anderen Containern installieren. Allerdings, wenn es um einen Container-Cluster geht, ist es schwer zu verwalten Volumen über Hosts und ihre Lebensdauer mit Docker.

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

In diesem Abschnitt gehen wir durch die Details von emptyDir, hostPath, nfs und glusterfs. Geheimnis, das verwendet wird, um Anmeldeinformationen zu speichern, wird im nächsten Abschnitt eingeführt. Die meisten von ihnen haben ähnliche Kubernetes-Syntax mit einem anderen Backend.

###  Fertig werden

Die Speicheranbieter sind erforderlich, wenn Sie beginnen, das Volumen in Kubernetes zu verwenden, außer für emptyDir, das gelöscht wird, wenn der Pod entfernt wird. Für andere Speicheranbieter müssen Ordner, Server oder Cluster gebaut werden, bevor sie in der Pod-Definition verwendet werden.

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



