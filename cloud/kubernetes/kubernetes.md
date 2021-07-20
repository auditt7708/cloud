---
title: kubernetes
description: 
published: true
date: 2021-06-09T15:35:47.859Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:35:39.609Z
---

# kubernetes Inhaltsverzeihnis

## Kubernetes Einrichtung

### [kubernetes-einrichten](../kubernetes-einrichten)

### [kubernetes-umgebung-vorbereiten](../kubernetes-umgebung-vorbereiten)

### [kubernetes-master-einrichten](../kubernetes-master-einrichten)

### [kubernetes-nodes-einrichten](../kubernetes-nodes-einrichten)

## Kubernetes Grundlagen

### [kubernetes-konzepte](../kubernetes-konzepte)

### [kubernetes-konzepte-volumes](../kubernetes-konzepte-volumes)

### [kubernetes-konzepte-services](../kubernetes-konzepte-services)

### [kubernetes-konzepte-secrets](../kubernetes-konzepte-secrets)

### [kubernetes-konzepte-replication-controller](../kubernetes-konzepte-replication-controller)

### [kubernetes-konzepte-pods](../kubernetes-konzepte-pods)

### [kubernetes-konzepte-namespaces](../kubernetes-konzepte-namespaces)

### [kubernetes-konzepte-names](../kubernetes-konzepte-names)

### [kubernetes-konzepte-labels-selektoren](../kubernetes-konzepte-labels-selektoren)

### [kubernetes-konzepte-kontrolle](../kubernetes-konzepte-kontrolle)

### [kubernetes-architektur-erforschen](../kubernetes-architektur-erforschen)

### [kubernetes-aws-autodeploy-chef](../kubernetes-aws-autodeploy-chef)

### [kubernetes-aws-cloudformation-provisioning](../kubernetes-aws-cloudformation-provisioning)

### [kubernetes-aws-einrichten](../kubernetes-aws-einrichten)

### [kubernetes-aws-infrastruktur](../kubernetes-aws-infrastruktur)

### [kubernetes-aws-opsworks](../kubernetes-aws-opsworks)

## Kubernete Netzwerk

### [kubernetes-overlay-network](../kubernetes-overlay-network)

### DC/CI mit Kubernetes

### [kubernetes-cd-pipline-erstellen](../kubernetes-cd-pipline-erstellen)

### [kubernetes-cd-pipline-jenkins-integration](../kubernetes-cd-pipline-jenkins-integration)

### [kubernetes-cd-pipline-monolitisch-microservices](../kubernetes-cd-pipline-monolitisch-microservices)

### [kubernetes-cd-pipline-private-docker-registry](../kubernetes-cd-pipline-private-docker-registry)

### [kubernetes-cd-pipline](../kubernetes-cd-pipline)

### Kubernetes Container

### [kubernetes-erster-container](../kubernetes-erster-container)

### [kubernetes-container](../kubernetes-container)

### [kubernetes-container-arbeiten-konfigurationsdatein](../kubernetes-container-arbeiten-konfigurationsdatein)

### [kubernetes-container-flexibilisierung](../kubernetes-container-flexibilisierung)

### [kubernetes-container-live-updates](../kubernetes-container-live-updates)

### [kubernetes-container-ports-weiterleiten](../kubernetes-container-ports-weiterleiten)

### [kubernetes-container-skalierung](../kubernetes-container-skalierung)

### [kubernetes-datastore](../kubernetes-datastore)

### [kubernetes-helm](../kubernetes-helm)

### Kubernetes Hochverfügbarkeit

### [kubernetes-ha-einrichten](../kubernetes-ha-einrichten)

### [kubernetes-ha-etcd](../kubernetes-ha-etcd)

### [kubernetes-ha-multi-masters](../kubernetes-ha-multi-masters)

### Kubernetes Logging unf Monitoring

### [kubernetes-logging-Monitoring-anwendungsprotokollen](../kubernetes-logging-monitorring-anwendungsprotokollen)

### [kubernetes-logging-Monitoring-etcd-log](../kubernetes-logging-monitorring-etcd-log)

### [kubernetes-logging-Monitoring-kubernetes-protokolle](../kubernetes-logging-monitorring-kubernetes-protokolle)

### [kubernetes-logging-Monitoring-master-nodes](../kubernetes-logging-monitorring-master-nodes)

### [kubernetes-logging-Monitoring](../kubernetes-logging-monitorring)

### Kubernetes fortgeschrittene Administration

### [kubernetes-adv-administration](../kubernetes-adv-administration)

### [kubernetes-adv-advanced-working-restful-api](../kubernetes-adv-advanced-working-restful-api)

### [kubernetes-adv-advanced-webui](../kubernetes-adv-advanced-webui)

### [kubernetes-adv-advanced-kubeconfig](../kubernetes-adv-advanced-kubeconfig)

### [kubernetes-adv-advanced-konfig-ressources-nodes](../kubernetes-adv-advanced-konfig-ressources-nodes)

### [kubernetes-adv-advanced-auth-autorisierung](../kubernetes-adv-advanced-auth-autorisierung)

#### Quellen

* [installing-kubernetes-cluster-minions-centos7-manage-pods-services](https://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services)

### Networking

> kubernetes v1.6 offers 3 ways to expose a service:

    L4 LoadBalancer: Available only on cloud providers such as GCE and AWS
    Service via NodePort: The NodePort directive allocates a port on every worker node, which proxy the traffic to the respective Pod.
    L7 Ingress: The Ingress is a dedicated loadbalancer (eg. nginx, HAProxy, traefik, vulcand) that redirects incoming HTTP/HTTPS traffic to the respective endpoints

* [flannel](https://github.com/coreos/flannel/blob/master/Documentation/kubernetes.md)
* [contiv](https://contiv.io/)
* [envoy Proxy](https://www.envoyproxy.io/docs/envoy/latest/)
* [kube-keepalived-vip](https://github.com/kubernetes-retired/contrib/tree/master/keepalived-vip)

### Authentifizieren mit Bootstrap Tokens

* [bootstrap-tokens](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/#configmap-signing)

### [Kubernetes API](../kubernetes-api)

Liste von zugriffen via [Kubernetes API](../kubernetes-api)

### Dokumentations-Quellen

* [installing-kubernetes-cluster-minions-centos7-manage-pods-services](https://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services)

* [Kubernetes-Salt-Deployment-Homepage](https://kubernetes.io/docs/admin/salt/)

* [Helm Kubernetes Packetmanager](https://github.com/kubernetes/helm/#install)

* [Kubernetes-cluster-step-by-step](https://icicimov.github.io/blog/kubernetes/Kubernetes-cluster-step-by-step/#ipsec-encryption-between-the-nodes-via-wireguard-optional)

* [Wordpress Application Clustering using Kubernetes with HAProxy and Keepalived](https://severalnines.com/blog/wordpress-application-clustering-using-kubernetes-haproxy-and-keepalived)