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

Auf der anderen Seite verlangt der Replikationscontroller von Heapster und derjenige, der influxDB und Grafana kombiniert, zusätzliche Bearbeitungen, um unser Kubernetes-System zu erfüllen:
