### Einrichten des DNS-Servers

Wie bereits erwähnt, verwenden wir die offizielle Vorlage, um den DNS-Server in unserem Kubernetes-System aufzubauen. Es gibt nur zwei Schritte. Ändern Sie zuerst die Vorlagen und erstellen Sie die Ressourcen. Dann müssen wir den `kubelet` Daemon mit DNS-Informationen neu starten.

#### Starten Sie den Server mit Vorlagen

Die Add-On-Dateien von Kubernetes befinden sich bei `<KUBERNETES_HOME>/cluster/addons/`. Nach dem letzten Schritt können wir auf die Add-On-Dateien für DNS unter `/opt/kubernetes/cluster/addons/dns` zugreifen. Zwei Template-Dateien werden modifiziert und ausgeführt. Natürlich können Sie, von den folgenden Schritten abzuweichen:

* Kopiere die Datei aus dem Format `.yaml.in` in die YAML-Datei und wir editieren die Kopien später:
`# cp skydns-rc.yaml.in skydns-rc.yaml`

| Input Variable| Ersatzwert | Beispiel|
| :---: | :---: | :---: |
|`{{ pillar['dns_domain'] }}`|Die Domäne dieses Clusters|` k8s.local `|
|`{{ pillar['dns_replicas'] }}`|Die Anzahl der Replikate für diesen Replikationscontroller|`1`|
|`{{ pillar['dns_server'] }}`|Die private IP des DNS-Servers. Muss auch im CIDR des Clusters sein|`192.168.0.2`|

` # cp skydns-svc.yaml.in skydns-svc.yaml`

* In diesen beiden Vorlagen ersetzen Sie die `pillar` variable, die durch doppelte große Klammern abgedeckt ist, mit den Elementen in dieser Tabelle. Wie Sie wissen, wird der Standard-Service kubernetes die erste IP in CIDR besetzen. Deshalb verwenden wir die IP `192.168.0.2` für unseren DNS-Server:
```
# kubectl get svc
NAME         CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
kubernetes   192.168.0.1   <none>        443/TCP   4d
```

* In der Vorlage für den Replikationscontroller gibt die Datei mit dem Namen `skydns-rc.yaml` die Master-URL im Container kube2sky an:
```
# cat skydns-rc.yaml
(Ignore above lines)
:
- name: kube2sky
  image: gcr.io/google_containers/kube2sky:1.14
  resources:
    limits:
      cpu: 100m
      memory: 200Mi
    requests:
      cpu: 100m
      memory: 50Mi
  livenessProbe:
    httpGet:
      path: /healthz
      port: 8080
      scheme: HTTP
    initialDelaySeconds: 60
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  readinessProbe:
    httpGet:
      path: /readiness
      port: 8081
      scheme: HTTP
    initialDelaySeconds: 30
    timeoutSeconds: 5
  args:
  # command = "/kube2sky"
  - --domain=k8s.local
  - --kube-master-url=<MASTER_ENDPOINT_URL>:<EXPOSED_PORT>
:
(Ignore below lines)

```

Nachdem Sie die vorherigen Schritte zur Modifikation beendet haben, können Sie sie einfach mit dem Unterbefehl `create` denn vorgang abschlißen:
```
# kubectl create -f skydns-svc.yaml
service "kube-dns" created
# kubectl create -f skydns-rc.yaml
replicationcontroller "kube-dns-v11" created

```

#### Aktivieren Sie Kubernetes DNS im Kubelet

Als nächstes haben wir Zugriff auf jeden Knoten und fügen DNS-Informationen zum Daemon-`kubelet` hinzu. Die Tags, die wir für den Cluster-DNS verwendet haben, sind `--cluster-dns`, für die Zuweisung der IP von DNS-Server und `--cluster-domain`, die die Domäne von Kubernetes-Diensten definieren:
```
// For init service daemon
# cat /etc/init.d/kubernetes-node
(Ignore above lines)
:	
# Start daemon.
echo $"Starting kubelet: "
        daemon $kubelet_prog \
                --api_servers=<MASTER_ENDPOINT_URL>:<EXPOSED_PORT> \
                --v=2 \
                --cluster-dns=192.168.0.2 \
                --cluster-domain=k8s.local \
                --address=0.0.0.0 \
                --enable_server \
                --hostname_override=${hostname} \
                > ${logfile}-kubelet.log 2>&1 &
:
(Ignore below lines)
// Or, for systemd service
# cat /etc/kubernetes/kubelet
(Ignore above lines)
:
# Add your own!
KUBELET_ARGS="--cluster-dns=192.168.0.2 --cluster-domain=k8s.local"
```
Nun ist es eine gute Idee, entweder den Service kubernetes-Knoten oder einfach nur Kubelet neu zu starten! Und du kannst den Cluster mit einem DNS-Server genießen.

### Wie es geht…

In diesem Abschnitt arbeiten wir an der Installation eines Überwachungssystems und der Einführung das dashboard. Dieses Monitoring-System basiert auf **Heapster **(https://github.com/kubernetes/heapster), einem Ressourcennutzungs- und Analyse-Tool. Heapster kommuniziert mit Kubelet, um die Ressourcennutzung von Maschine und Container zu erhalten. Zusammen mit Heapster haben wir **influxDB **(https://influxdata.com) für das storage und **Grafana **(http://grafana.org) als Frontend-Dashboard, das den Status von Ressourcen in mehreren benutzerfreundlichen Plots visualisiert.

### Installieren eines Überwachungsclusters

Wenn Sie den vorherigen Abschnitt über den erforderlichen DNS-Server durchgemacht haben, müssen Sie sich mit der Bereitstellung des Systems mit offiziellen Add-On-Vorlagen sehr vertraut machen.

1. Überprüfen Sie die Verzeichnis `cluster-monitorin`g unter `<KUBERNETES_HOME>/cluster/addons`. Es gibt verschiedene Umgebungen für die Bereitstellung des Monitoring-Clusters. Wir wählen influxdb in diesem Rezept für Demonstration:
```
# cd /opt/kubernetes/cluster/addons/cluster-monitoring/influxdb && ls
grafana-service.yaml      heapster-service.yaml             influxdb-service.yaml
heapster-controller.yaml  influxdb-grafana-controller.yaml
```
Unter diesem Verzeichnis sehen Sie drei Vorlagen für Dienste und zwei für  replication controllers.

2. Wir behalten die meisten Servicevorlagen so wie sie sind bei. Da diese Vorlagen die Netzwerkkonfigurationen definieren, ist es gut, die Standardeinstellungen zu verwenden, aber den Grafana-Dienst freizugeben:
```
# cat heapster-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: monitoring-grafana
  namespace: kube-system
  labels:
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "Grafana"
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 30000
      targetPort: 3000
  selector:
    k8s-app: influxGrafana
```

Wie Sie sehen können, stellen wir den Grafana-Service mit Port `30000 ` zur verfügung. Diese Revision ermöglicht es uns, auf das Dashboard der Überwachung aus dem Browser zuzugreifen.

3. Auf der anderen Seite verlangt der replication controller von Heapster und derjenige, der influxDB und Grafana kombiniert, zusätzliche Bearbeitungen, um unser Kubernetes-System zu erfüllen:
```
# cat influxdb-grafana-controller.yaml
(Ignored above lines)
:
- image: gcr.io/google_containers/heapster_grafana:v2.6.0-2
          name: grafana
          env:
          resources:
            # keep request = limit to keep this container in guaranteed class
            limits:
              cpu: 100m
              memory: 100Mi
            requests:
              cpu: 100m
              memory: 100Mi
          env:
            # This variable is required to setup templates in Grafana.
            - name: INFLUXDB_SERVICE_URL
              value: http://monitoring-influxdb.kube-system:8086
            - name: GF_AUTH_BASIC_ENABLED
              value: "false"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "true"
            - name: GF_AUTH_ANONYMOUS_ORG_ROLE
              value: Admin
            - name: GF_SERVER_ROOT_URL
              value: /
:
(Ignored below lines)
```
Für den Container von Grafana bitte einige Umgebungsvariablen ändern. Die erste ist die **URL** des influxDB Service. Da wir den DNS-Server einrichten, müssen wir nicht die jeweilige IP-Adresse angeben. Aber eine Extra-Postfix-Domain sollte hinzugefügt werden. Es liegt daran, dass der Dienst im Namespace `Kube-System` erstellt wird. Ohne Hinzufügen dieser Postfix-Domäne kann der DNS-Server das `Monitoring-influxdb` im Standard-Namespace nicht auflösen. Außerdem sollte die Grafana-Root-URL in einen einzigen Schrägstrich geändert werden. Statt der Standard-URL überträgt die root (`/`) Grafana die korrekte Webseite im aktuellen System.

4. In der Vorlage von Heapster führen wir zwei Heapster-Container in einer pod. Diese beiden Container verwenden das gleiche Image und haben ähnliche Einstellungen, aber tatsächlich nehmen wir sie zu verschiedenen Rollen. Wir sehen uns nur einen von ihnen als Beispiel für eine Änderung an:
```
# cat heapster-controller.yaml
(Ignore above lines)
:
      containers:
        - image: gcr.io/google_containers/heapster:v1.0.2
          name: heapster
          resources:
            limits:
              cpu: 100m
              memory: 200Mi
            requests:
              cpu: 100m
              memory: 200Mi
          command:
            - /heapster
            - --source=kubernetes:<MASTER_ENDPOINT_URL>:<EXPOSED_PORT>?inClusterConfig=false
            - --sink=influxdb:http://monitoring-influxdb.kube-system:8086
            - --metric_resolution=60s
:
(Ignore below lines)
```

Am Anfang entfernen Sie alle Doppel-Groß-Klammern Linien. Diese Zeilen verursachen einen Erstellungsfehler, da sie im YAML-Format nicht analysiert oder berücksichtigt werden können. Dennoch gibt es zwei Eingangsvariablen, die auf mögliche Werte ausgetauscht werden müssen. Ersetzen Sie `{{metrics_memory}}` und `{{eventer_memory}}` auf `200Mi`. Der Wert 200MiB ist eine garantierte Menge an Speicher, die der Container haben soll. Und bitte ändern Sie die Nutzung für Kubernetes Quelle. Wir geben die vollständige Zugriffs-URL und den Port an und deaktivieren `ClusterConfig`, um die Authentifizierung zu unterlassen. Denken Sie daran, sich an den `heapster`- und `eventer`-Containern anzupassen.

5. Jetzt können Sie diese Elemente mit einfachen Befehlen erstellen:
```
# kubectl create -f influxdb-service.yaml
service "monitoring-influxdb" created
# kubectl create -f grafana-service.yaml
You have exposed your service on an external port on all nodes in your
cluster.  If you want to expose this service to the external internet, you may
need to set up firewall rules for the service port(s) (tcp:30000) to serve traffic.

See http://releases.k8s.io/release-1.2/docs/user-guide/services-firewalls.md for more details.
service "monitoring-grafana" created
# kubectl create -f heapster-service.yaml
service "heapster" created
# kubectl create -f influxdb-grafana-controller.yaml
replicationcontroller "monitoring-influxdb-grafana-v3" created
// Because heapster requires the DB server and service to be ready, schedule it as the last one to be created.
# kubectl create -f heapster-controller.yaml
replicationcontroller "heapster-v1.0.2" created
```

6. Überprüfen Sie Ihre Kubernetes-Ressourcen im Namespace kube-system:
```
# kubectl get svc --namespace=kube-system
NAME                  CLUSTER-IP        EXTERNAL-IP   PORT(S)             AGE
heapster              192.168.135.85    <none>        80/TCP              12m
kube-dns              192.168.0.2       <none>        53/UDP,53/TCP       15h
monitoring-grafana    192.168.84.223    nodes         80/TCP              12m
monitoring-influxdb   192.168.116.162   <none>        8083/TCP,8086/TCP   13m
# kubectl get pod --namespace=kube-system
NAME                                   READY     STATUS    RESTARTS   AGE
heapster-v1.0.2-r6oc8                  2/2       Running   0          4m
kube-dns-v11-k81cm                     4/4       Running   0          15h
monitoring-influxdb-grafana-v3-d6pcb   2/2       Running   0          12m
```
Glückwünsche! Sobald du alle Pods in einem fertigen Zustand hast, lasst uns das Monitoring dashboard überprüfen.

### Vorstellung des Grafana dashboards

In diesem Moment ist das Grafana Armaturenbrett über Nodesendpunkte verfügbar. Bitte stellen Sie sicher, dass die Firewall oder Sicherheitsgruppe des Nodes auf AWS den Port `30000 `in Ihr lokales Subnetz geöffnet hat. Schauen Sie sich das dashboard mit einem Browser an. Geben Sie `<NODE_ENDPOINT>:30000` in Ihrer URL-Suchleiste ein:

![dashboard-01](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_03.jpg)

In den Standardeinstellungen haben wir zwei Dashboards **Cluster **und **Pods**. Das **Cluster** Board deckt die Ressourcennutzung der Knoten, wie CPU, Speicher, Netzwerk-Transaktion und Speicher ab. Das **Pods** dashboard hat ähnliche Plots für jede pod und Sie können jeden plot in einer pod beobachten.

![dashboad-02](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_04.jpg)

Wie die Bilder zeigen, können wir zum Beispiel die Speicherauslastung einzelner Container im pod `kube-dns-v11` beobachten, welches der Cluster des DNS-Servers ist. Die lila Linien in der Mitte geben nur die Begrenzung an, die wir auf die Container `skydns `und `kube2sky ` gesetzt haben.

### Erstellen einer neuen Metrik zur Überwachung von Pods

Es gibt mehrere Metriken für die Überwachung von Heapster angeboten (https://github.com/kubernetes/heapster/blob/master/docs/storage-schema.md). Wir werden Ihnen zeigen, wie Sie ein individuelles Panel selbst erstellen können. Bitte sehen Sie die folgenden Schritte als Referenz:

1. Gehen Sie zum Pods Dashboard und klicken Sie auf **ADD ROW ** am unteren Rand der Webseite. Eine grüne Taste erscheint auf der linken Seite. Wählen Sie, um ein Diagrammfeld hinzuzufügen.

![add-row](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_05.jpg)

2. Zuerst geben Sie Ihrem Panel einen Namen. Zum Beispiel CPU-Rate. Wir möchten eine, die die Rate der CPU-Dienstprogramm zeigt:

![cpu-rate](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_06.jpg)

3. Richten Sie die Parameter in der Abfrage ein, wie im folgenden Screenshot gezeigt:

![cpu-rate-2](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_07.jpg)

* FROM: Für diese Parameter-Eingabe `cpu/usage_rate`
* WHERE: Für diesen Parameter set `type = pod_container`
* UND: Setzen Sie diesen Parameter mit dem `Namenpace_name = $ namespace`, `pod_name = $ podname value`
* GROUP BY: Geben Sie den Tag (container_name) für diesen Parameter ein
* ALIAS BY: Für diesen Parameter input `$tag_container_name`

4. Gut gemacht! Sie können jetzt den Pod speichern, indem Sie auf das Symbol oben klicken:
![save-dashboard.pod](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_08.jpg)

Versuchen Sie einfach, mehr Funktionalität des Grafana dashboard und des Heapster Monitoring Tools zu entdecken. Weitere Informationen über Ihr System, Ihre Dienste und Ihre Container erhalten Sie über die Informationen des Monitoringsystems.