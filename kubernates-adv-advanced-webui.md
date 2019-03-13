Kubernetes hat das WebUI-Add-on, das den Status von Kubernetes wie Pod, Replikationscontroller und Service visualisiert.

### Fertig werden

Die Kubernetes WebUI wird unter `http://<kubernetes master>/u`i verfügbar. Allerdings wird es nicht standardmäßig gestartet, stattdessen gibt es YAML-Dateien in der Release-Binärdatei.


![kubernetes-master-ui](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_01.jpg)
Zugrif auf  Kubernetes master/ui Seite.


Download der binären WebUI Release:

```
//Download a release binary
$ curl -L -O https://github.com/kubernetes/kubernetes/releases/download/v1.1.4/kubernetes.tar.gz

//extract the binary
$ tar zxf kubernetes.tar.gz
//WebUI YAML file is under the cluster/addons/kube-ui directory 
$ cd kubernetes/cluster/addons/kube-ui/
$ ls
kube-ui-rc.yaml    kube-ui-svc.yaml
```

### Wie es geht…

Lassen Sie uns den kube-ui Replikationscontroller und den Dienst starten:
```
# kubectl create -f kube-ui-rc.yaml 
replicationcontroller "kube-ui-v2" created

# kubectl create -f kube-ui-svc.yaml 
service "kube-ui" created
```

Beachten Sie, dass `kube-ui-svc` eine Art von ClusterIP-Dienst ist. Allerdings ist es mit Kubernetes master (/ui) verbunden. Sie können von außen das Kubernetes-Netzwerk unter `http://<kubernetes master>/ui` erreichen.

![kubernetes-ui]https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_02.jpg)

Launching the kube-ui/ui shows the dashboard screen

### Wie es funktioniert…

Der kube-ui-Replikationscontroller greift auf den API-Server zu, um die Kubernetes-Cluster-Informationen wie der Befehl `kubectl `zu erhalten, obwohl er schreibgeschützt ist. Allerdings ist es einfacher, den Status von Kubernetes im UI zu Navigiren und es ist einfacher zu erkunden als der Befehl `kubectl`.

Der folgende Screenshot ist eine Explore-Seite, die Pod-, Replikations-Controller- und Service-Instanzen zeigt:

![kubernetes-ui-explore](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_03.jpg)

Wenn du auf einen der Instanzen klickst, zeigt er detaillierte Informationen an, wie im folgenden Screenshot gezeigt. Es zeigt einen Dienst, den Port, Node-Port und Selektoren werden anzeigt. Es ist leicht, einen zugehörigen Replikationscontroller und Pods zu finden:
!(ui-kubernetes-pod-details)[https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_04.jpg]

Darüber hinaus kann die UI uns auch Ereignisse wie folgt anzeigen:

![ui-kubernetes-ereignisse](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_05.jpg)

