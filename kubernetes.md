# kubernetes Übersicht

## [kubernetes-einrichten](../kubernetes-einrichten)

## [kubernetes-umgebung-vorbereiten](../kubernetes-umgebung-vorbereiten)

## [kubernetes-overlay-network](../kubernetes-overlay-network)

## [kubernetes-master-einrichten](../kubernetes-master-einrichten)

## [kubernetes-nodes-einrichten](../kubernetes-nodes-einrichten)

## [kubernetes-konzepte](../kubernetes-konzepte)

## [kubernetes-konzepte-volumes](../kubernetes-konzepte-volumes)

## [kubernetes-konzepte-services](../kubernetes-konzepte-services)

## [kubernetes-konzepte-secrets](../kubernetes-konzepte-secrets)

## [kubernetes-konzepte-replication-controller](../kubernetes-konzepte-replication-controller)

## [kubernetes-konzepte-pods](../kubernetes-konzepte-pods)

## [kubernetes-konzepte-namespaces](../kubernetes-konzepte-namespaces)

## [kubernetes-konzepte-names](../kubernetes-konzepte-names)

## [kubernetes-konzepte-labels-selektoren](../kubernetes-konzepte-labels-selektoren)

## [kubernetes-konzepte-kontrolle](../kubernetes-konzepte-kontrolle)

## [kubernetes-architektur-erforschen](../kubernetes-architektur-erforschen)

## [kubernetes-aws-autodeploy-chef](../kubernetes-aws-autodeploy-chef)

## [kubernetes-aws-cloudformation-provisioning](../kubernetes-aws-cloudformation-provisioning)

## [kubernetes-aws-einrichten](../kubernetes-aws-einrichten)

## [kubernetes-aws-infrastruktur](../kubernetes-aws-infrastruktur)

## [kubernetes-aws-opsworks](../kubernetes-aws-opsworks)

## [kubernetes-cd-pipline-erstellen](../kubernetes-cd-pipline-erstellen)

## [kubernetes-cd-pipline-jenkins-integration](../kubernetes-cd-pipline-jenkins-integration)

## [kubernetes-cd-pipline-monolitisch-microservices](../kubernetes-cd-pipline-monolitisch-microservices)

## [kubernetes-cd-pipline-private-docker-registry](../kubernetes-cd-pipline-private-docker-registry)

## [kubernetes-cd-pipline](../kubernetes-cd-pipline)

## [kubernetes-erster-container](../kubernetes-erster-container)

## [kubernetes-container](../kubernetes-container)

## [kubernetes-container-arbeiten-konfigurationsdatein](../kubernetes-container-arbeiten-konfigurationsdatein)

## [kubernetes-container-flexibilisierung](../kubernetes-container-flexibilisierung)

## [kubernetes-container-live-updates](../kubernetes-container-live-updates)

## [kubernetes-container-ports-weiterleiten](../kubernetes-container-ports-weiterleiten)

## [kubernetes-container-skalierung](../kubernetes-container-skalierung)

## [kubernetes-datastore](../kubernetes-datastore)

## [kubernetes-helm](../kubernetes-helm)

## [kubernetes-ha-einrichten](../kubernetes-ha-einrichten)

## [kubernetes-ha-etcd](../kubernetes-ha-etcd)

## [kubernetes-ha-multi-masters](../kubernetes-ha-multi-masters)

## [kubernetes-logging-monitorring-anwendungsprotokollen](../kubernetes-logging-monitorring-anwendungsprotokollen)

## [kubernetes-logging-monitorring-etcd-log](../kubernetes-logging-monitorring-etcd-log)

## [kubernetes-logging-monitorring-kubernetes-protokolle](../kubernetes-logging-monitorring-kubernetes-protokolle)

## [kubernetes-logging-monitorring-master-nodes](../kubernetes-logging-monitorring-master-nodes)

## [kubernetes-logging-monitorring](../kubernetes-logging-monitorring)

## [kubernetes-adv-administration](../kubernetes-adv-administration)

## [kubernetes-adv-advanced-working-restful-api](../kubernetes-adv-advanced-working-restful-api)

## [kubernetes-adv-advanced-webui](../kubernetes-adv-advanced-webui)

## [kubernetes-adv-advanced-kubeconfig](../kubernetes-adv-advanced-kubeconfig)

## [kubernetes-adv-advanced-konfig-ressources-nodes](../kubernetes-adv-advanced-konfig-ressources-nodes)

## [kubernetes-adv-advanced-auth-autorisierung](../kubernetes-adv-advanced-auth-autorisierung)

## Dokumentations Quellen

* [installing-kubernetes-cluster-minions-centos7-manage-pods-services](https://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services)

## Installation

Voraussetzungen:

| Service | Version |
| :---: | :---: |
|docker|18.06|
|kubeadm|latest|

Repository für CentOS, RHEL oder Fedora anlegen

```s
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
```

> Bei CentOS, RHEL oder Fedora muss noch SELinux wie folgt angepasst werden
>```s
>
># Set SELinux in permissive mode (effectively disabling it)
> setenforce 0
> sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
>
> yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
>
> systemctl enable --now kubelet
> ```

## Erste Initiale Einrichtung

## Speziefische Version von Docker Installieren

### Ubuntu

**Verfügbare Versionsn anzeigen lassen**
`apt-cache madison docker-ce`

### Ubuntu User einrichten

`sudo usermod -aG docker $USER`

**Version Installieren**
`apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io`

## CentOS Installation

## [kubelet](../kubelet)

* [kubelet.service](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=2ahUKEwj64dSQ3dzgAhWCZFAKHaFwB5MQFjAAegQIABAB&url=https%3A%2F%2Fgithub.com%2Fkubernetes%2Fcontrib%2Fblob%2Fmaster%2Finit%2Fsystemd%2Fkubelet.service&usg=AOvVaw2GG-cG-fHta3SfPAWLvANN)

## [Kubeadm](../kubeadm)

## [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

## Administration

kube-system

`kubectl --namespace= get pods`

Alle namespaces ausgeben

`kubectl get pods --all-namespaces`

Nur Active namespaces ausgeben

`kubectl get namespaces`

Context ändern -> Umgebung

`kubectl config use-context dev`

Contest als ADMIN wiederherstellen

`kubectl config use-context kubernetes-admin@kubernetes`

Log von pod ansehen

`kubectl logs dns-frontend`

Alle verfügbaren api Resourcen mit zugewiesenen Namespace anzeigen

`kubectl api-resources --namespaced=true`

## Networking

> kubernetes v1.6 offers 3 ways to expose a service:

    L4 LoadBalancer: Available only on cloud providers such as GCE and AWS
    Service via NodePort: The NodePort directive allocates a port on every worker node, which proxy the traffic to the respective Pod.
    L7 Ingress: The Ingress is a dedicated loadbalancer (eg. nginx, HAProxy, traefik, vulcand) that redirects incoming HTTP/HTTPS traffic to the respective endpoints

* [flannel](https://github.com/coreos/flannel/blob/master/Documentation/kubernetes.md)
* [contiv](https://contiv.io/)
* [envoy Proxy](https://www.envoyproxy.io/docs/envoy/latest/)
* [kube-keepalived-vip](https://github.com/kubernetes-retired/contrib/tree/master/keepalived-vip)

## kubeadm-upgrade

* [kubeadm-upgrade](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-upgrade/)

## Authentifizieren mit Bootstrap Tokens

* [bootstrap-tokens](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/#configmap-signing)

## [Kubernetes API](../kubernetes-api)

Liste von Zugrifen via [Kubernetes API](../kubernetes-api)


## Dokumentations-Quellen

* [installing-kubernetes-cluster-minions-centos7-manage-pods-services](https://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services)

* [Kubernetes-Salt-Deployment-Homepage](https://kubernetes.io/docs/admin/salt/)

* [Helm Kubernetes Packetmanager](https://github.com/kubernetes/helm/#install)

* [Kubernetes-cluster-step-by-step](https://icicimov.github.io/blog/kubernetes/Kubernetes-cluster-step-by-step/#ipsec-encryption-between-the-nodes-via-wireguard-optional)

* [Wordpress Application Clustering using Kubernetes with HAProxy and Keepalived](https://severalnines.com/blog/wordpress-application-clustering-using-kubernetes-haproxy-and-keepalived)