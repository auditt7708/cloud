# Openshift Installation

## Public registry

/etc/containers/registries.conf
```
[registries.search]
registries = ['registry.redhat.io', 'quay.io', 'docker.io']

[registries.insecure]
registries = []

[registries.block]
registries = []
```

## Übersichtsliste

* [Openshift Installation](../openshift-installation)
* [Openshift Konfiguration](../openshift-konfiguration)
* [Openshift Cluster Administration](../openshift-cluster-administration)
* [Openshift cli](../openshift-cli)
* [Openshift Images erstellen](../openshift-erstellen-images)
* [Openshift Images Benutzen](../openshift-benutzen-images)
* [Openshift Entwicklung](../openshift-entwicklung)
* [Openshift REST api](../openshift-rest-api)


**Quellen**
* [openshift-kubernetes-automated-performance-tests-part-3/](https://developers.redhat.com/blog/2019/01/16/openshift-kubernetes-automated-performance-tests-part-3/)
* [Red Hat Openshift](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8-beta/html/building_running_and_managing_containers/enabling-container-settings_building-running-and-managing-containers)



