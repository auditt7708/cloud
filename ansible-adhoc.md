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

# 

**Quelle:**
* [user_guide/intro_adhoc](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)