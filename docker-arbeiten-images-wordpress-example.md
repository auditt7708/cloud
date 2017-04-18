Bisher haben wir das Beispiel gesehen, nur einen Service in einem Container laufen zu lassen. Wenn wir eine Anwendung ausführen wollen, die es erfordert, dass wir einen oder mehrere Dienste gleichzeitig ausführen, dann müssen wir sie auch auf demselben Container ausführen oder auf verschiedenen Containern laufen lassen und diese miteinander verknüpfen. WordPress ist ein solches Beispiel, das eine Datenbank und einen Web Service benötigt.

Docker mag nur einen Prozeß pro Container im Vordergrund. 
Also, um Docker glücklich zu machen, haben wir einen Controlling-Prozess, der die Datenbank und Web Services verwaltet. 
Der Kontrollprozess ist in diesem Fall Supervisord (http://supervisord.org/). Das ist ein Trick, den wir benutzen, um Docker glücklich zu machen.

Wieder werden wir eine Dockerfile aus dem Fedora-Dockerfiles-Repository verwenden.

### Fertig werden

Klonen Sie die Fedora-Dockerfiles Git Repo mit dem folgenden Befehl:
`$ git clone  https://github.com/nkhare/Fedora-Dockerfiles.git`

Dann gehe zum Unterverzeichnis `wordpress_single_container`:
```
$ cd Fedora-Dockerfiles/systemd/wordpress_single_container
$ cat Dockerfile
FROM fedora 
MAINTAINER scollier <scollier@redhat.com> 
RUN yum -y update && yum clean all 
RUN yum -y install httpd php php-mysql php-gd pwgen supervisor bash-completion openssh-server psmisc tar && yum clean all 
ADD ./start.sh /start.sh 
ADD ./foreground.sh /etc/apache2/foreground.sh 
ADD ./supervisord.conf /etc/supervisord.conf 
RUN echo %sudo  ALL=NOPASSWD: ALL >> /etc/sudoers 
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz 
RUN tar xvzf /wordpress.tar.gz 
RUN mv /wordpress/* /var/www/html/. 
RUN chown -R apache:apache /var/www/ 
RUN chmod 755 /start.sh 
RUN chmod 755 /etc/apache2/foreground.sh 
RUN mkdir /var/run/sshd 
EXPOSE 80 
EXPOSE 22 
CMD ["/bin/bash", "/start.sh"]

```

Die im vorigen Code verwendeten Stützdateien werden wie folgt erklärt:

* `foreground.sh`: Dies ist ein Skript, um HTTPS im Vordergrund auszuführen.

* `LICENSE`, `LICENSE.txt` und `UNLICENSE.txt`: Diese Dateien enthalten die Lizenzinformationen.

* `README.md`: Dies ist eine README-Datei.

* `supervisord.conf`: Dies ist ein resultierender Container, der gleichzeitig `SSHD`, `MySQL` und `HTTPD` ausführen muss. In diesem speziellen Fall wird der supervisor verwendet, um sie zu verwalten. Es ist eine Konfigurationsdatei des Supervisors. Weitere Informationen dazu finden Sie unter http://supervisord.org/.

* `start.sh`: Dies ist ein Skript, um MySQL, HTTPD einzurichten und den Supervisor-Daemon zu starten.

### Wie es geht…
```
$ docker build -t fedora/wordpress  . 
Sending build context to Docker daemon 41.98 kB 
Sending build context to Docker daemon 
Step 0 : FROM fedora 
 ---> 834629358fe2 
Step 1 : MAINTAINER scollier <scollier@redhat.com> 
 ---> Using cache 
 ---> f21eaf47c9fc 
Step 2 : RUN yum -y update && yum clean all 
 ---> Using cache 
 ---> a8f497a6e57c 
Step 3 : RUN yum -y install httpd php php-mysql php-gd pwgen supervisor bash-completion openssh-server psmisc tar && yum clean all 
 ---> Running in 303234ebf1e1
.... updating/installing packages ....
Cleaning up everything 
 ---> cc19a5f5c4aa 
Removing intermediate container 303234ebf1e1 
Step 4 : ADD ./start.sh /start.sh 
 ---> 3f911077da44 
Removing intermediate container c2bd643236ef 
Step 5 : ADD ./foreground.sh /etc/apache2/foreground.sh 
 ---> 3799902a60c5 
Removing intermediate container c99b8e910009 
Step 6 : ADD ./supervisord.conf /etc/supervisord.conf 
 ---> f232433b8925 
Removing intermediate container 0584b945f6f7 
Step 7 : RUN echo %sudo  ALL=NOPASSWD: ALL >> /etc/sudoers 
 ---> Running in 581db01d7350 
 ---> ec686e945dfd 
Removing intermediate container 581db01d7350 
Step 8 : ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz 
Downloading [==================================================>] 6.186 MB/6.186 MB 
 ---> e4e902c389a4 
Removing intermediate container 6bfecfbe798d 
Step 9 : RUN tar xvzf /wordpress.tar.gz 
 ---> Running in cd772500a776 
.......... untarring wordpress .........
---> d2c5176228e5 
Removing intermediate container cd772500a776 
Step 10 : RUN mv /wordpress/* /var/www/html/. 
 ---> Running in 7b19abeb509c 
 ---> 09400817c55f 
Removing intermediate container 7b19abeb509c 
Step 11 : RUN chown -R apache:apache /var/www/ 
 ---> Running in f6b9b6d83b5c 
 ---> b35a901735d9 
Removing intermediate container f6b9b6d83b5c 
Step 12 : RUN chmod 755 /start.sh 
 ---> Running in 81718f8d52fa 
 ---> 87470a002e12 
Removing intermediate container 81718f8d52fa 
Step 13 : RUN chmod 755 /etc/apache2/foreground.sh 
 ---> Running in 040c09148e1c 
 ---> 1c76f1511685 
Removing intermediate container 040c09148e1c 
Step 14 : RUN mkdir /var/run/sshd 
 ---> Running in 77177a33aee0 
 ---> f339dd1f3e6b 
Removing intermediate container 77177a33aee0 
Step 15 : EXPOSE 80 
 ---> Running in f27c0b96d17f 
 ---> 6078f0d7b70b 
Removing intermediate container f27c0b96d17f 
Step 16 : EXPOSE 22 
 ---> Running in eb7c7d90b860 
 ---> 38f36e5c7cab 
Removing intermediate container eb7c7d90b860 
Step 17 : CMD /bin/bash /start.sh 
 ---> Running in 5635fe4783da 
 ---> c1a327532355 
Removing intermediate container 5635fe4783da 
Successfully built c1a327532355 

```

### Wie es funktioniert…

Wie bei den anderen Rezepten beginnen wir mit dem Basisimage, installieren die benötigten Pakete und kopieren die unterstützenden Dateien. Wir werden dann `sudo`, `download` und `untar` WordPress und HTTPD-Dokument Root einrichten. Danach setzen wir die Ports  und führen die start.sh Skripte aus, die MySQL-, WordPress-, HTTPS-Berechtigungen einrichten und die Kontrolle übernehmen. In der `supervisord.conf` sehen Sie Einträge, wie die folgenden Dienste, die Supervisor verwaltet:

```
[program:mysqld] 
command=/usr/bin/mysqld_safe 
[program:httpd] 
command=/etc/apache2/foreground.sh 
stopsignal=6 
[program:sshd] 
command=/usr/sbin/sshd -D 
stdout_logfile=/var/log/supervisor/%(program_name)s.log 
stderr_logfile=/var/log/supervisor/%(program_name)s.log 
autorestart=true
```

### Es gibt mehr…

Rufen Sie abschließend ihre Wordpress Installation auf der Assistent wird Sie durch die Installation leiten.

* Es ist jetzt möglich, systemd im Inneren des Containers laufen zu lassen, was ein bevorzugterer Weg ist. Systemd kann mehr als einen Service verwalten. Sie können sich das Beispiel von systemd unter https://github.com/fedora-cloud/Fedora-Dockerfiles/tree/master/systemd anschauen.