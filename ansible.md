# Installation von Ansible

Da es nicht immer auf Anhieb möglich ist mit der node auf Anhieb zuzugreifen und alle notwendigen automatisiert einzurichten kann man mit : 

`ansible myhost --sudo -m raw -a "yum install -y python2 python-simplejson"`

alle Voraussetzungen für Ansible einrichten **myhost** ist hier der zielhost und **python-simplejson** ein Playbook das alle Abhängigkeiten einrichtet. 

## Installation Ubuntu

Für Ubuntu kann man [PPA](https://launchpad.net/~ansible/+archive/ansible) verwenden um auf ein aktuelles release zu kommen
Repo für Ubuntu xenial:
```
deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main 
deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main 
```

**Repo einrichten und update durchführen:**

```
sudo add-apt-repository ppa:ansible/ansible
sudo apt-get update
```

**Add Repository für Ubuntu**
```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```

Da hier auch die quellen vorhanden sind kann man auch sich das Packet wie folgt bauen 
```
make deb
```

## Installation RHEL/Centos

## Installation mit [Pip](https://pypi.python.org/pypi/pip)

Die [pip](https://pypi.python.org/pypi/pip) Installation ist recht einfach aber  `easy_install`  muss vorhanden sein so haben die meisten Distributionen in der bootstrap Variante nicht dabei und auch noch nicht in der Netinstall, gerade seit dem die Pakete größer werden werden hier kaum mehr Extras eingerichtet.

Einfach mal mit dem [Packetmanager](../packetmanager) nach `easy_install` suchen .

Wenn dann installiert ist kann man wie folgt [Ansible](../ansible) installieren. 

```
sudo easy_install pip
sudo pip install ansible
```

# ansible fireball Installation

Auf dem node kann mit ansible fireball  die Verarbeitungsgeschwindigkeit massiv erhöt werden.

**Quellen:**
* [ansible fireball](https://linux.die.net/man/3/ansible.fireball)
* []()
* []()
* []()

# Ansible erweiterte Einrichtung 

## Playbooks

**Quellen**
* [playbooks von ansile doc ](http://docs.ansible.com/ansible/playbooks.html)
* [gc3-uzh-ch](https://github.com/gc3-uzh-ch/ansible-playbooks)
* []()
* []()
* []()

## Zero Downtime Deployment

* [ansible-zero-downtime-deployment](https://jaxenter.de/ansible-zero-downtime-deployment-50085)
* [Dynamic Inventory](http://docs.ansible.com/ansible/intro_dynamic_inventory.html#using-inventory-directories-and-multiple-inventory-sources)
* [playbooks_best_practices](https://docs.ansible.com/ansible/playbooks_best_practices.html)
* []()
* []()
* []()

**Sources:**
* https://raymii.org/s/tutorials/Ansible_access_other_groups_group_vars.html
* https://raymii.org/s/tutorials/Ansible_-_Only-do-something-if-another-action-changed.html
* https://raymii.org/s/articles/Building_HA_Clusters_With_Ansible_and_Openstack.html
* []()
* []()
* []()

**Wichtige Documentation für ansible **
* [module-index](http://docs.ansible.com/ansible/modules_by_category.html#module-index)
* []()

**Ansible Beispiele**
* []()
* []()
* []()
