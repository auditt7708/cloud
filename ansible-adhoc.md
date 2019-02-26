# Parallelisieren und Shell Kommandos

**SSH Agent einrichten**

```
ssh-agent bash && \
ssh-add ~/.ssh/id_rsa
```

**Previligirte ausführen mit password abfrage**

`ansible atlanta -a "/usr/bin/foo" -u username --become --become-user otheruser [--ask-become-pass]`

# Datei Tranfer

**Direkter Datei Transfer**

`ansible atlanta -m copy -a "src=/etc/hosts dest=/tmp/hosts"`

# Pakete managen

**Paket Installieren**

`ansible webservers -m yum -a "name=acme state=present"`

# Benutzer und Gruppen

**Benutzer anlegen**

`ansible all -m user -a "name=foo password=<crypted password here>"`

**Benutzer Löschen**
`ansible all -m user -a "name=foo state=absent"`

# Einrichtung von SCM

`ansible webservers -m git -a "repo=https://foo.example.org/repo.git dest=/srv/myapp version=HEAD"`

# Services Verwalten
**Service soll gestartet sein**

`ansible webservers -m service -a "name=httpd state=started"`

**Service Neu Starten**
`ansible webservers -m service -a "name=httpd state=restarted"`

**Service deaktiviren**
`ansible webservers -m service -a "name=httpd state=stopped"`

# Zeit limitierte jobs ausführen

**Lan laufenen job in den Hintergrund und später wieder aufnehmen**

`ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"`


**Mit async_Modul wider aufnehmen**

`ansible web1.example.com -m async_status -a "jid=488359678239.2844"`





**Quelle:**
* [user_guide/intro_adhoc](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)