# Ansible Galaxy requirements

In der Datei `requirements.yml` kann man seine abhängigkeiten definieren `ansible-galaxy` kümmert sich dann darum alle rolen die benötigt werden auch  zu laden.

Die datei `requirements.yml` liegt im quell Verzeichnis 

Die abhängigkeiten können wie folded aufgelöst werden.

```
ansible-galaxy install -r requirements.yml
```

Hier ist eine Beispiel wie eine solche datei aufgebaut ist 
```
---
- src: https://github.com/myprojekt/ansible-apache2.git
- src: https://github.com/myprojekt/ansible-mariadb-mysql.git
- src: https://github.com/myprojekt/ansible-mariadb-galera-cluster.git
- src: https://github.com/myprojekt/ansible-powerdns.git
```

In diesem Beispiel muss `- src: ` eine erreichbare http|https Quelle sein. 
Alternativ sind aber alternative quellen möglich.


