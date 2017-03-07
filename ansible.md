Installation Ubuntu
===

Für Ubuntu kann man [PPA](https://launchpad.net/~ansible/+archive/ansible) verwenden um auf ein aktuelles release zu kommen
Repo einrichten und update durchführen:

```
sudo add-apt-repository ppa:ansible/ansible
sudo apt-get update
```

Installation 
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


Installation RHEL/Centos
===

Installation mit [Pip](https://pypi.python.org/pypi/pip)
===
Die [pip](https://pypi.python.org/pypi/pip) installation ist 

Zero Downtime Deployment
=========================
* [ansible-zero-downtime-deployment](https://jaxenter.de/ansible-zero-downtime-deployment-50085)
* [Dynamic Inventory](http://docs.ansible.com/ansible/intro_dynamic_inventory.html#using-inventory-directories-and-multiple-inventory-sources)
* [playbooks_best_practices](https://docs.ansible.com/ansible/playbooks_best_practices.html)

Sources: 
* https://raymii.org/s/tutorials/Ansible_access_other_groups_group_vars.html
* https://raymii.org/s/tutorials/Ansible_-_Only-do-something-if-another-action-changed.html
* https://raymii.org/s/articles/Building_HA_Clusters_With_Ansible_and_Openstack.html
