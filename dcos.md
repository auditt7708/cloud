<<<<<<< HEAD
# DC/OS](../dcos) [Mesos](../mesos)
=======
# [DC/OS](../dcos) [Mesos](../mesos)
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275

## Hardware Voraussetzungen

Hier die Voraussetzungen in einer Produktiven Umgebung.

## Master nodes

Die Tabelle unten zeit die Hardware Voraussetzungen für den master node:

| |Minimum | Empfohlen |
| :---: | :---: | :---: |
|Nodes         | 1* |  3 oder 5 |
|Prozessor | 4 cores | 4 cores|
|Arbeitsspeicher | 32 GB RAM | 32 GB RAM|
|Persistenter Speicher | 120 GB | 120 GB|

## Agent nodes

Die Tabelle unten zeit die Hardware Voraussetzungen für den agent.

<<<<<<< HEAD
|   | Minimal | Empfohlen |
=======
| Rescource | Minimal | Empfohlen |
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
| :---: | :---: | :---: |
|Nodes       | 1       |6 oder mehr|
|Prozessor    | 2 cores |2 cores  |
|Arbeitsspeicher | 16 GB RAM  |16 GB RAM|
|Persistenter Speicher| 60 GB |60 GB|

### Einrichtung

Verzeichnis erstellen unter _/opt/_

`mkdir -p genconf`

## Erstellen eines Skripts zur IP Erstellung

```sh
#!/usr/bin/env bash
set -o nounset -o errexit
export PATH=/usr/sbin:/usr/bin:$PATH
echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
```

## Deployment von DC/OS

### Ansible

* [DCOS Ansible](https://github.com/dcos/dcos-ansible)

## Quellen

* [Universe für fertige services](https://universe.dcos.io/#/packages)
* [Notizen zu DC/OS](https://mesosphere.github.io/field-notes/)
