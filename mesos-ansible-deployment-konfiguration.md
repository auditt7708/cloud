# Mesos und Ansible einrichten

Ansible ist eines der beliebten Infrastruktur-Automatisierungs-Tools, die heute von Systemadministratoren häufig genutzt und vor kurzem von Red Hat erworben wurden. Nodes werden über **Secure Shell (SSH)** verwaltet und benötigen nur Python-Unterstützung. Ansible hat offen eine Menge von Spielbüchern, darunter eine unmögliche Mesos, die wir in diesem Abschnitt zu diskutieren.

Das `ansible-mesos` Playbook kann verwendet werden, um einen Mesos-Cluster mit maßgeschneiderten Master- und Slave-Setup-Optionen zu installieren und zu konfigurieren. Derzeit unterstützt es Ubuntu und CentOS / Red Hat Betriebssystem-powered Maschinen. Das `ansible-mesos` Playbook unterstützt auch die Einstellung von Slave-Executoren und kann daher mit nativer Docker-Unterstützung ausgeführt werden.

## Installable Ansible

Ansible Installation ist nur auf einer Maschine erforderlich. Es braucht keine Datenbank, noch muss es einen Daemon laufen, der die ganze Zeit läuft. Es verwendet SSH, um den Cluster zu verwalten und benötigt Python (Versionen 2.6 oder 2.7), um auf dem Rechner installiert zu werden. Sie können sogar Ansible auf Ihrem Laptop oder Personal Computer installieren und haben die Verwaltung der Maschinen, die fern laufen. Die Maschine, in der Ansible installiert ist, heißt Steuergerät. Zum Zeitpunkt des Schreibens dieses Buches gibt es keine Unterstützung für Windows-Maschinen. Die Maschinen, die von der Steuerungsmaschine gesteuert werden, werden als verwaltete Knoten bezeichnet und benötigen eine SSH-Zugriffsfähigkeit von der Steuerungsmaschine sowie Python (Version 2.4 oder höher), die auf ihnen installiert ist.

## Installieren der Steuerungsmaschine

Wir können Ansible ohne Root-Zugriff ausführen, da es nicht erforderlich ist, zusätzliche Software- oder Datenbankserver zu installieren. Führen Sie den folgenden Code aus:

```sh
# Install python pip
sudo easy_install pip

# Install the following python modules for ansible
sudo pip install paramiko PyYAML Jinja2 httplib2 six

# Clone the repository
git clone git://github.com/ansible/ansible.git --recursive

# Change the directory
cd ansible

# Installation
source ./hacking/env-setup
```

Wenn alles gut geht, dann sehen wir die folgende Ausgabe im Terminal, was darauf hinweist, dass die Installation erfolgreich war. Danach können wir den Befehl Ansible aus dem Terminal benutzen.

![Ansible-Installed](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_05_01.jpg)

Standardmäßig verwendet Ansible die Inventardatei in `/etc/ansible/hosts`, die ein INI-ähnliches Format ist und wie folgt aussehen könnte:

```sh
mail.xyz.com

[webservers]
foo.xyz.com
bar.xyz.com

[dbservers]
one.xyz.com
two.xyz.com
three.xyz.com
```

Hier werden die Gruppennamen in Klammern angegeben, mit denen die zu steuernden Systeme klassifiziert werden können.

Wir können auch die Befehlszeilenoption -i verwenden, um sie auf eine andere Datei zu zeigen, als diejenige, die in / etc / ansible / hosts gefunden wird.

## Erstellen eines Unmöglichen-Mesos-Setups

Ansible führt ein Playbook aus Rollen aus einer Reihe von Hosts, wie zuvor in der Hosts-Datei beschrieben, die in Gruppen organisiert sind. Für weitere Details, besuchen Sie http://frankhinek.com/create-ansible-playbook-on-github-to-build-mesos-clusters/.

Zuerst wollen wir eine Hosts-Datei erstellen, indem wir auf unsere Mesos-Master- und Slave-Knoten hinweisen:

```sh
$ cat hosts
[mesos_masters]
ec2-….compute-1.amazonaws.com zoo_id=1 ec2-….compute-1.amazonaws.com zoo_id=2
ec2-….compute-1.amazonaws.com zoo_id=3

[mesos_workers]
ec2-….compute-1.amazonaws.com
ec2-….compute-1.amazonaws.com
```

Hier haben wir zwei Gruppen namens `mesos_masters` und `mesos_workers` erstellt und die Master- bzw. Slave-IP-Adressen aufgelistet.
Für die Gruppe `mesos_masters` müssen wir auch die ZooKeeper ID angeben, da der Cluster in hoher Verfügbarkeit ausgeführt wird.

In den folgenden Schritten werden wir einen Blick darauf werfen, wie wir Mesos auf den in der Host-Datei aufgelisteten Maschinen mit Ansible einsetzen können:

1.Erstellen Sie eine `site.yml` Datei mit folgendem Inhalt:

```sh
--
# This playbook deploys the entire Mesos cluster infrastructure.
# RUN: ansible-playbook --ask-sudo-pass -i hosts site.yml

- name: deploy and configure the mesos masters
  hosts: mesos_masters
  sudo: True

  roles:
    - {role: mesos, mesos_install_mode: "master", tags: ["mesos-master"]}

- name: deploy and configure the mesos slaves
  hosts: mesos_workers
  sudo: True

  roles:
    - {role: mesos, mesos_install_mode: "slave", tags: ["mesos-slave"]}
```

2.Nun können wir eine Gruppenvariablendatei erstellen, die für alle Hosts des Clusters gilt, wie folgt:

```sh
mkdir group_vars
vim all
```

3.Als nächstes werden wir den folgenden Inhalt in alle Dateien setzen:

```sh
---
# Variables here are applicable to all host groups

mesos_version: 0.20.0-1.0.ubuntu1404
mesos_local_address: "{{ansible_eth0.ipv4.address}}"
mesos_cluster_name: "XYZ"
mesos_quorum_count: "2"
zookeeper_client_port: "2181"
zookeeper_leader_port: "2888"
zookeeper_election_port: "3888"
zookeeper_url: "zk://{{ groups.mesos_masters | join(':' + zookeeper_client_port + ',') }}:{{ zookeeper_client_port }}/mesos"
```

4.Jetzt können wir die Rollen für den Mesos-Cluster erstellen. Erstellen Sie zunächst ein Rollenverzeichnis über den folgenden Befehl:

`$ mkdir roles; cd roles`

5.Wir können nun den Befehl `ansible-galaxy` verwenden, um die Verzeichnisstruktur für diese Rolle zu initialisieren, wie folgt:

`$ ansible-galaxy init mesos`

6.Dadurch wird die Verzeichnisstruktur wie folgt erstellt:

![verzeichnisse-ansible](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_05_02.jpg)

7.Ändern Sie nun die `mesos/handler/main.yml` Datei mit folgendem Inhalt:

```sh
---
# handlers file for mesos
- name: Start mesos-master
  shell: start mesos-master
  sudo: yes

- name: Stop mesos-master
  shell: stop mesos-master
  sudo: yes

- name: Start mesos-slave
  shell: start mesos-slave
  sudo: yes

- name: Stop mesos-slave
  shell: stop mesos-slave
  sudo: yes

- name: Restart zookeeper
  shell: restart zookeeper
  sudo: yes

- name: Stop zookeeper
  shell: stop zookeeper
  sudo: yes
```

8.Als nächstes ändern Sie die Aufgaben aus der Datei `mesos/tasks/main.yml` wie folgt:

```sh
---
# tasks file for mesos

# Common tasks for all Mesos nodes
- name: Add key for Mesosphere repository
  apt_key: url=http://keyserver.ubuntu.com/pks/lookup?op=get&fingerprint=on&search=0xE56151BF state=present
  sudo: yes

- name: Determine Linux distribution distributor
  shell: lsb_release -is | tr '[:upper:]' '[:lower:]'
  register: release_distributor

- name: Determine Linux distribution codename
  command: lsb_release -cs
  register: release_codename

- name: Add Mesosphere repository to sources list
  copy:
    content: "deb http://repos.mesosphere.io/{{release_distributor.stdout}} {{release_codename.stdout}} main"
    dest: /etc/apt/sources.list.d/mesosphere.list
    mode: 0644
  sudo: yes

    # Tasks for Master, Slave, and ZooKeeper nodes

- name: Install mesos package
  apt: pkg={{item}} state=present update_cache=yes
  with_items:
    - mesos={{ mesos_pkg_version }}
  sudo: yes
  when: mesos_install_mode == "master" or mesos_install_mode == "slave"

- name: Set ZooKeeper URL # used for leader election amongst masters
  copy:
    content: "{{zookeeper_url}}"
    dest: /etc/mesos/zk
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master" or mesos_install_mode == "slave"

# Tasks for Master nodes
- name: Disable the Mesos Slave service
  copy:
    content: "manual"
    dest: /etc/init/mesos-slave.override
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master"

- name: Set Mesos Master hostname
  copy:
    content: "{{mesos_local_address}}"
    dest: /etc/mesos-master/hostname
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master"

- name: Set Mesos Master ip
  copy:
    content: "{{mesos_local_address}}"
    dest: /etc/mesos-master/ip
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master"

- name: Set Mesos Master Cluster name
  copy:
    content: "{{mesos_cluster_name}}"
    dest: /etc/mesos-master/cluster
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master"

- name: Set Mesos Master quorum count
  copy:
    content: "{{mesos_quorum_count}}"
    dest: /etc/mesos-master/quorum
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "master"

# Tasks for Slave nodes
- name: Disable the Mesos Master service
  copy:
    content: "manual"
    dest: /etc/init/mesos-master.override
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "slave"

- name: Disable the ZooKeeper service
  copy:
    content: "manual"
    dest: /etc/init/zookeeper.override
    mode: 0644
  sudo: yes
  notify:
    - Stop zookeeper
  when: mesos_install_mode == "slave"

- name: Set Mesos Slave hostname
  copy:
    content: "{{mesos_local_address}}"
    dest: /etc/mesos-slave/hostname
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "slave"

- name: Set Mesos Slave ip
  copy:
    content: "{{mesos_local_address}}"
    dest: /etc/mesos-slave/ip
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "slave"

- name: Set Mesos Slave ip
  copy:
    content: "{{mesos_local_address}}"
    dest: /etc/mesos-slave/ip
    mode: 0644
  sudo: yes
  when: mesos_install_mode == "slave"

- name: Set Mesos Slave isolation
  copy:
    content: "cgroups/cpu,cgroups/mem"
    dest: /etc/mesos-slave/isolation
    mode: 0644
  sudo: yes
  notify:
    - Start mesos-slave
  when: mesos_install_mode == "slave"

# Tasks for ZooKeeper nodes only
- name: Create zookeeper config file
  template: src=zoo.cfg.j2 dest=/etc/zookeeper/conf/zoo.cfg
  sudo: yes
  when: mesos_install_mode == "master"

- name: Create zookeeper myid file
  template: src=zoo_id.j2 dest=/etc/zookeeper/conf/myid
  sudo: yes
  notify:
    - Restart zookeeper
    - Start mesos-master
  when: mesos_install_mode == "master"
```

Dies ist eine Standardvorlage, um die Mesos-Master-Slave-Maschinen im Cluster zu konfigurieren.
Diese Datei gibt auch die verschiedenen Konfigurationen an, die für die Installation von Komponenten wie ZooKeeper notwendig sind.
Die Schritte sind wie folgt aufgeführt:

9.Erstellen Sie die ZooKeeper-Konfigurationsvorlage wie folgt:
`$ vim mesos/templates/zoo.cfg.j2``

10.Fügen Sie dann den folgenden Inhalt hinzu:

```sh
  tickTime=2000
  dataDir=/var/lib/zookeeper/
  clientPort={{ zookeeper_client_port }}
  initLimit=5
  syncLimit=2
  {% for host in groups['mesos_masters'] %}
  server.{{ hostvars[host].zoo_id }}={{ host }}:{{ zookeeper_leader_port }}:{{ zookeeper_election_port }}
  {% endfor %}
```

11.Als nächstes geben Sie den folgenden Befehl ein:

`$ vim mesos/templates/zoo_id.j2`

12.Schließlich fügen Sie den folgenden Inhalt hinzu:

`{{ zoo_id }}`

Wir können nun dieses Playbook ausführen, um Mesos auf den in der Host-Datei aufgelisteten Maschinen bereitzustellen.
Wir müssen nur die IP-Adressen aus der Host-Datei ändern, um auf anderen Rechnern zu implementieren.