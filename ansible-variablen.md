
**Facts nach /tmp/facts Speichern**

`ansible localhost -m setup --tree /tmp/facts`

**Nur von facter erhobene Daten**

`ansible all -m setup -a 'filter=ansible_eth[0-2]'`

**Facten zu ssh abrufen**

`ansible localhost -m setup -a 'filter=facter_ssh'`

**Prüfen ob Nativ oder VM**

`ansible localhost -m setup -a 'filter=facter_virtual' `

**Alle Netzwerk Informationen Abberufen**

`ansible localhost -m setup -a 'gather_subset=network,virtual'

**Benutzer Verzeichnis ausgeben**

`ansible localhost -m setup -a 'filter=ansible_user_dir'`

**Alle Details zu Netzwerk Schnittstellen ausgeben alte variante**

`ansible localhost -m setup -a 'filter=ansible_eth*'`

**Alle Details zu Netzwerk Schnittstellen ausgeben neue variante**

`ansible localhost -m setup -a 'filter=ansible_enp*'`

**Details zu default IPv6 Interfae abfrufen**

`ansible localhost -m setup -a 'filter=ansible_default_ipv6'`

**Details zu default IPv4 Interfae abfrufen**

`ansible localhost -m setup -a 'filter=ansible_default_ipv4'`

**Alle IPv4 Adressen ausgeben**

`ansible localhost -m setup -a 'filter=ansible_all_ipv4_addresses'`

**DNS Einstellungen abrufen**

`ansible localhost -m setup -a 'filter=ansible_dns'`

**Distribution anzeigen lassen**

`ansible localhost -m setup -a 'filter=ansible_distribution`

**Major version der Distribution ausgeben**

`ansible localhost -m setup -a 'filter=ansible_distribution_major_version`

**Release name ausgeben**

`ansible localhost -m setup -a 'filter=ansible_distribution_release`

**Abfrage ob sich etwas verändert hat**

`ansible localhost -m setup -a 'filter=changed`

**Abfrage mit filter**

`ansible localhost -m setup -a 'filter='`

**Quellen:**

* [Ansible Modul Setup mit allen facts](http://docs.ansible.com/ansible/setup_module.html)