---
title: kubernetes-einrichten
description: 
published: true
date: 2021-06-09T15:32:19.113Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:32:13.865Z
---

# kubernetes einrichten

Willkommen auf der Reise von Kubernetes!
In diesem ersten Abschnitt erfahren Sie, wie Sie Ihren eigenen Kubernetes-Cluster aufbauen können.
Zusammen mit dem Verständnis jeder Komponente lernen Sie alles miteinander zu verbinden und erden Lernen wie Sie Ihren ersten Container auf Kubernetes zum laufen bringen.
Mit einem Kubernetes-Cluster wird es Ihnen helfen, die Umsetzung in den folgenden Kapiteln fortzusetzen.

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

## Kubernetes Ports

Ports für Worker node(s)

|Protocol | Direction | Port Range | Purpose | Used By|
| :---: | :---: | :---: | :---: | :---: |
|TCP |Inbound | 10250 | Kubelet API | Self, Control plane|
|TCP |Inbound | 30000-32767 | NodePort Services** | All |

Konfig für firewalld

```s
firewall-cmd --permanent --zone=public --add-port=10250/tcp
firewall-cmd --permanent --zone=public --add-port=30000-32767/tcp
firewall-cmd --reload
```

swap deactiviren

```
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a
```

## Speziefische Version von Docker Installieren

### Ubuntu

Verfügbare Versionsn anzeigen lassen

`apt-cache madison docker-ce`

#### Ubuntu User einrichten

`sudo usermod -aG docker $USER`

Version Installieren

`apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io`

### CentOS Installation

### [kubelet](../kubelet)

* [kubelet.service](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=2ahUKEwj64dSQ3dzgAhWCZFAKHaFwB5MQFjAAegQIABAB&url=https%3A%2F%2Fgithub.com%2Fkubernetes%2Fcontrib%2Fblob%2Fmaster%2Finit%2Fsystemd%2Fkubelet.service&usg=AOvVaw2GG-cG-fHta3SfPAWLvANN)

### [Kubeadm](../kubeadm)

### [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

## Kubernetes und tls

Namespace _cert-manager_ anlegen

`kubectl create namespace cert-manager`

Manifest anlegen

`kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml`

### Übersicht

* [Architektur erforschen](../kubernetes-architektur-erforschen)
* [Vorbereitung der Umgebung](../kubernetes-umgebung-vorbereiten)
* [Einrichten eines Datastors](../kubernetes-datastore)
* [Erstellen eines Overlay-Netzwerks](../kubernetes-overlay-network)
* [Master konfigurieren](../kubernetes-master-einrichten)
* [Konfigurieren von Nodes](../kubernetes-nodes-einrichten)
* [Laufen Sie Ihren ersten Container in Kubernetes](../kubernetes-erster-container)
* [Kubernetes Master](../kubernetes-master-einrichten)
* [kubeadm](../kubeadm)
