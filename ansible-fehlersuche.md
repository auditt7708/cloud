# Fehlersuche mit Ansible 

Um einzelne hosts bei denen ein fehler aufgetreten ein weieres mal testen zu können ohne alle anderen auch zu testen und damit dem vorgang stark zu beschleunigen legt Ansible default eine  datei: `` an die man dann bei dem nästen versuch benutzen sollte hier ein Beispiel:

`ansible-playbook site.yml --limit @retry_hosts.txt`



###### Quelle: 
* [intro_patterns](http://docs.ansible.com/ansible/intro_patterns.html)