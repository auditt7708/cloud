# Openshift Installation

## Vorbereitungen

```s
yum -y install centos-release-openshift-origin311.noarch
yum -y install origin-clients
```

## Linux Installation

### Linux Umbebung

`export KUBECONFIG=/home/$USER/.minishift/minishift-kube-config`

## Installation unter CentOS7

Für docker muss in der **** Unsichere Repositories aktiviert sein.

`--insecure-registry 172.30.0.0/16`

### Quelle

*[platform-as-code-with-openshift-terraform](https://medium.com/@fabiojose/platform-as-code-with-openshift-terraform-1da6af7348ce)

## Fehler nach Linux Installation

> Error reading $HOME/.docker/config.json: open /home/docker/.docker/config.json: no such file or directory, imagestream import credentials will not be setup

### Fehler

```s
> Could not set oc CLI context for 'minishift' profile: Error during setting 'minishift' as active profile: The specified path to the kube config 'C:\Users\Softg\.minishift\machines\minishift_kubeconfig' does not exist

Lösung

```s
Error reading $HOME/.docker/config.json: open /home/docker/.docker/config.json: no such file or directory, imagestream import credentials will not be setup
```

## Windows Installation

minsihift start

### Windows Fehler nach der Installation

> Error reading $HOME/.docker/config.json: open /home/docker/.docker/config.json: no such file or directory, imagestream import credentials will not be setup

#### Lösung

```sh
> Could not set oc CLI context for 'minishift' profile: Error during setting 'minishift' as active profile: The specified path to the kube config 'C:\Users\Softg\.minishift\machines\minishift_kubeconfig' does not exist
```

#### Lösung 'C:\Users\Softg\.minishift\machines\minishift_kubeconfig' does not exist

```sh
Error reading $HOME/.docker/config.json: open /home/docker/.docker/config.json: no such file or directory, imagestream import credentials will not be setup

```

## Windows Umgebung

### Variable KUBECONFIG

`export KUBECONFIG=/Users/john/tmp/minishift-kube-config`

### Varable PATH

`set PATH=%PATH%;"D:\Program Files (x86)\openshift-origin-v1.0.3"`

`$Env:PATH = "C:\Users\Softg\.minishift\cache\oc\v3.11.43\windows;$Env:PATH"`

## Firewall Einstellungen

Hier die einstellungen zur  Firewall die notwendig sind, damit [Openshift](../openshift) erreichbar ist.

### iptabels

### firewalld

```s
firewall-cmd --permanent --new-zone dockerc
firewall-cmd --permanent --zone dockerc --add-source 172.17.0.0/16
firewall-cmd --permanent --zone dockerc --add-port 8443/tcp
firewall-cmd --permanent --zone dockerc --add-port 53/udp
firewall-cmd --permanent --zone dockerc --add-port 8053/udp
firewall-cmd --reload

```

## [Cluster Konfiguration](https://docs.okd.io/latest/install_config/master_node_configuration.html)

`oc cluster up`

* [Cluster Administration](https://docs.okd.io/latest/getting_started/administrators.html#getting-started-administrators)

## [Nodes Managen okd Dokumentation](https://docs.okd.io/latest/admin_guide/manage_nodes.html)

## Public registry

/etc/containers/registries.conf

```s

[registries.search]
registries = ['registry.redhat.io', 'quay.io', 'docker.io']

[registries.insecure]
registries = []

[registries.block]
registries = []
```

## [Netzwerk](https://docs.okd.io/latest/admin_guide/managing_networking.html)

## [OpenShift Ansible Broker](https://docs.okd.io/latest/install_config/oab_broker_configuration.html)

## [Host zum Cluter Hinzufügen](https://docs.okd.io/latest/install_config/adding_hosts_to_existing_cluster.html)

## [Master Host ersetzen](https://docs.okd.io/latest/admin_guide/assembly_replace-master-host.html)

## [Nodes Managen](https://docs.okd.io/latest/admin_guide/manage_nodes.html)

## Eigene Zertifikate

## Openshift Monitoring

## [sssd_for_ldap_failover](https://docs.okd.io/latest/install_config/sssd_for_ldap_failover.html)

## Übersichtsliste

* [Openshift Installation](../openshift-installation)
* [Openshift Konfiguration](../openshift-konfiguration)
* [Openshift Cluster Administration](../openshift-cluster-administration)
* [Openshift cli](../openshift-cli)
* [Openshift Images erstellen](../openshift-erstellen-images)
* [Openshift Images Benutzen](../openshift-benutzen-images)
* [Openshift Entwicklung](../openshift-entwicklung)
* [Openshift REST api](../openshift-rest-api)

### Quellen

* [openshift-kubernetes-automated-performance-tests-part-3/](https://developers.redhat.com/blog/2019/01/16/openshift-kubernetes-automated-performance-tests-part-3/)
* [Red Hat Openshift](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8-beta/html/building_running_and_managing_containers/enabling-container-settings_building-running-and-managing-containers)