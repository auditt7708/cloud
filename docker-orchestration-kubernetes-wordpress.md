In diesem Rezept werden wir das WordPress-Beispiel in Kubernetes GitHub (https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/mysql-wordpress-pd) verwenden. Das gegebene Beispiel erfordert einige Änderungen, da wir es auf der Vagrant-Umgebung statt der Standard-Google Compute-Engine ausführen werden. Auch anstatt die Helfer-Funktionen zu verwenden (z.B. `<kubernetes> /cluster/kubectl.sh`), melden wir uns an, um die `kubectl` Binärdatei zu haben und zu verwenden.

### Fertig werden

* Vergewissern Sie sich, dass der Kubernetes-Cluster wie im vorherigen Rezept beschrieben eingerichtet wurde.

* Im `kubernetes` Verzeichnis, das während des Setups heruntergeladen wurde, finden Sie ein Beispielverzeichnis, das viele Beispiele enthält. Gehen wir zum `mysql-wordpress-pd` Verzeichnis:
```
$ cd kubernetes/examples/mysql-wordpress-pd
$  ls *.yaml
mysql-service.yaml mysql.yaml wordpress-service.yaml  wordpress.yaml

```

* Diese `.yaml` Dateien beschreiben Pods und Services für `mysql` und `wordpress`.

* In den Pods-Dateien (`mysql.yaml` und `wordpress.yaml`) findest du den Abschnitt über Volumes und die entsprechende `volumeMount`-Datei. Das ursprüngliche Beispiel setzt voraus, dass Sie Zugriff auf Google Compute Engine haben und dass Sie das entsprechende Speicher-Setup haben. Aus Gründen der Einfachheit werden wir das nicht einrichten und stattdessen mit der `EmptyDir`-Volumen-Option eine kurzlebige Speicherung verwenden. Als Referenz wird unser `mysql.yaml` wie folgt aussehen:
```
apiVersion: v1beta3
kind: Pod
metadata:
  name: mysql
  labels:
    name: mysql
spec:
  containers:
   - resources:
      limits:
        cpu: 1
     image: mysql
     name: mysql
     env:
       - name: MYSQL_ROOT_PASSWORD
         # change this
         value: yourpassword
    ports:
     - containerPort: 3306
       name: mysql
    volumeMounts:
      # name must match the volume name below
     - name: mysql-ephemeral-storage
      # mount path within the container
      mountPath: /var/lib/mysql
   volume:
     - name: mysql-ephemeral-storage
       emtyDir: {}
```

* Machen Sie die ähnliche Änderung zu `wordpress.yaml`.

### Wie es geht…

Mit SSH melden Sie sich am Masterknoten an und betrachten die laufenden Pods:
```
$ vagrant ssh master
$ kubectl get pods 

```

Der `kube-dns-7eqp5` Pod besteht aus drei Containern: `etcd`, `kube2sky` und `skydns`, die verwendet werden, um einen internen DNS-Server für den Dienstnamen in IP-Auflösung zu konfigurieren. Wir werden es später in diesem Rezept ansehen.

Die Vagrantfile, die in diesem Beispiel verwendet wird, wird so erstellt, dass das kubernetes-Verzeichnis, das wir früher erstellt haben, unter `/vagrant` auf VM geteilt wird, was bedeutet, dass die Änderungen, die wir an das Host-System vorgenommen haben, auch hier sichtbar werden.

2. Von dem Master-Knoten, erstellen Sie die `mysql` Pod und überprüfen Sie die laufenden Pods:
```
$ kubectl create -f /vagrant/examples/mysql-wordpress-pd/mysql.yaml
$ kubectl get pods
```

Wie wir sehen können, wurde ein neuer Pod mit dem `mysql` Namen erstellt und es läuft auf Host `10.245.1.3`, das ist unser Knoten (Minion).

3. Jetzt machen wir den Service für mysql und schauen Sie sich alle services an:
```
$ kubectl create -f /vagrant/examples/mysql-wordpress-pd/mysql-service.yaml
$ kubectl get services
```

Wie wir sehen können, wurde ein Service namens `mysql` erstellt. Jeder Dienst hat eine virtuelle IP. Anders als die `kubernetes`-Dienste sehen wir einen Dienst namens `kube-dns`, der als Dienstname für den `kube-dns` Pod verwendet wird, den wir früher gesehen haben.

4. Ähnlich wie mysql, lasst uns eine pod für WordPress erstellen:
`$ kubectl create -f /vagrant/examples/mysql-wordpress-pd/wordpress.yaml`

> 
> * Das `WordPress` Images wird aus dem offiziellen Docker-Registry heruntergeladen und der Container läuft.
>
> * Wenn ein Pod startet, werden standardmäßig Informationen über alle vorhandenen Dienste als Umgebungsvariablen exportiert. Zum Beispiel, wenn wir uns bei der `WordPress`-Pod anmelden und nach `MYSQL`-spezifischen Umgebungsvariablen suchen, werden wir so etwas wie folgendes sehen:
>
```
sudo docker exec .it 523cbe7525f2 bash
env | grep MYSQL
```
>
> * Wenn der WordPress-Container startet, führt er das Skript `/entrypoint.sh` aus, das nach den zuvor erwähnten Umgebungsvariablen sucht, um den Dienst zu starten. Https://github.com/docker-library/wordpress/blob/master/docker-entrypoint.sh.
>
> * Mit dem `kube-dns`-Service sind PHP-Skripte von `wordpress` in der Lage, die reserve lookup nach vorne möglich .
>

5. Nach dem Start der Pod, ist der letzte Schritt folgender, um den `wordpress` Service einzurichten. Im Standardbeispiel sehen Sie einen Eintrag wie der folgende in der Servicedatei (`/vagrant/examples/mysql-wordpress-pd/mysql-service.yaml`):

`createExternalLoadBalancer: true`

Diese zeile wurde geschrieben, um zu beachten, dass dieses Beispiel auf der Google Compute Engine ausgeführt wird. Also ist es hier nicht gültig Anstatt dessen müssen wir einen Eintrag wie folgt machen:

```
publicIPs: 
    - 10.245.1.3
```

Wir haben den Load-Balancer-Eintrag mit der öffentlichen IP des Knotens ersetzt, der in unserem Fall die IP-Adresse der Node (Minion) ist. Also, die `wordpress`-Datei würde wie folgt aussehen:
```
apiVersion: v1beta3
kind: Service
metadata:
 labels:
  name: wpfrontend
 name: wpfrontend
spec:
 publicIPs: 
  - 10.245.1.3
 ports:
  # the Port that this service should serve on
   - port: 80
 # label keys amd values taht must match in order to receive for this service
 selector:
  name: wordpress

```

6. Um den `wordpress`-Dienst zu starten, führen Sie den folgenden Befehl vom Master-Knoten aus:
`$ kubectl create -f /vagrant/examples/mysql-wordpress-pd/wordpress-service.yaml`

`kubectl get services`

Wir können hier sehen, dass unser Service auch über die Node (Minion) IP verfügbar ist.

7. Um zu überprüfen, ob alles gut funktioniert, können wir das Links-Paket auf Master installieren, mit dem wir eine URL über die Befehlszeile durchsuchen können und eine Verbindung zur öffentlichen IP herstellen, die wir erwähnt haben:
```
$ sudo yum install links -y
$ links 10.245.1.3
```
Hierzu solltest du die `WordPress`-Installations-Seite ansehen.

### Wie es funktioniert…

In diesem Rezept haben wir zuerst ein `mysql` Pod und Service erstellt. Später haben wir es mit einem `WordPress` Pod verbunden, und um darauf zuzugreifen, haben wir einen `WordPress` Service geschaffen. Jede YAML-Datei hat einen `kind` Schlüssel, der den Typ des Objekts definiert, das es ist. Zum Beispiel, in Pod-Dateien, ist `kind` ist auf Pod gesetzt und in Service-Dateien, ist es auf Service gesetzt.

### Es gibt mehr…

* In diesem Beispiel haben wir nur einen Node (Minion). Wenn Sie sich einloggen, sehen Sie alle laufenden Container:
```
$ vagrant ssh minion-1
$ sudo docker ps

```

* In diesem Beispiel haben wir keine Replikationscontroller konfiguriert. Wir können dieses Beispiel erweitern, indem wir sie erstellen.

### Siehe auch

* Einrichten der vagabunden Umgebung unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/vagrant.md

* Das Kubernetes Benutzerhandbuch unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/user-guide.md

* Die Dokumentation zu kube-dns unter https://github.com/GoogleCloudPlatform/kubernetes/tree/master/cluster/addons/dns