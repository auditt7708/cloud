# Ansible Galaxy requirements

In der Datei `` kann man seine abhängigkeiten definieren `ansible-galaxy` kümmert sich dann darum alle rolen die benötigt werden auch runter zu laden . 

Die datei `` liegt im quell Verzeichnis 

Die abhängigkeiten können wie folded aufgelöst werden .
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

`src: ` muss eine erreichbare http|https Quelle sein.
