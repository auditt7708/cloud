# Docker Vorbereiten

## Storage einrichten

vim /etc/sysconfig/docker-storage-setup

## Repos einrichten

Wenn der fehler oc cluster up does not recognize --insecure-registry argument kommt.
kann man wie unter [issues-8997](https://github.com/openshift/origin/issues/8997)bereiben in der datei /etc/sysconfig/docker folgendes unter ioptionen eintragen.

`--insecure-registry "172.30.0.0/16"`

### Quellen

* [Openshift Templates](https://docs.openshift.org/latest/dev_guide/templates.html#writing-templates)
* [Openshift Homepage](https://www.openshift.org/)