# Docker Arbeiten mit Images: Firefox beispiel

Wir können etwas interessanteres durch eine Dockerfile machen, wie zum Beispiel das Erstellen eines Containers, der nur Firefox ausführt. Diese Art von Anwendungsfall kann dazu beitragen, mehrere Browser von verschiedenen Versionen auf dem gleichen Computer, die sehr hilfreich bei der Durchführung von Multibrowser-Tests werden können.
Fertig werden

Klonen Sie die Fedora-Dockerfiles Git Repo mit dem folgenden Befehl:
`$ git clone  https://github.com/nkhare/Fedora-Dockerfiles.git`

Dann geh zum Firefox-Unterverzeichnis.

```sh
$ cd Fedora-Dockerfiles/firefox
$ cat Dockerfile
FROM fedora
MAINTAINER scollier <emailscottcollier@gmail.com>

# Install the appropriate software
RUN yum -y update && yum clean all
RUN yum -y install x11vnc \
firefox xorg-x11-server-Xvfb \
xorg-x11-twm tigervnc-server \
xterm xorg-x11-font \
xulrunner-26.0-2.fc20.x86_64 \
dejavu-sans-fonts \
dejavu-serif-fonts \
xdotool && yum clean all

# Add the xstartup file into the image
ADD ./xstartup /

RUN mkdir /.vnc
RUN x11vnc -storepasswd 123456 /.vnc/passwd
RUN  \cp -f ./xstartup /.vnc/.
RUN chmod -v +x /.vnc/xstartup
RUN sed -i '/\/etc\/X11\/xinit\/xinitrc-common/a [ -x /usr/bin/firefox ] && /usr/bin/firefox &' /etc/X11/xinit/xinitrc

EXPOSE 5901

CMD    ["vncserver", "-fg" ]
# ENTRYPOINT ["vncserver", "-fg" ]
```

Unterstützte Dateien:

* README.md: Dies ist eine README-Datei

* LICENSE: Dies ist die GPL-Lizenz

* Xstartup: Dies ist das Skript, um die X11-Umgebung einzurichten

## Wie es geht…

Führen Sie den folgenden Befehl aus, um das Imagezu erstellen:

```sh
$ docker build  -t fedora/firefox .
Sending build context to Docker daemon 24.58 kB
Sending build context to Docker daemon
Step 0 : FROM fedora
 ---> 834629358fe2
Step 1 : MAINTAINER scollier <emailscottcollier@gmail.com>
 ---> Running in ae0fd3c2cb2e
 ---> 7ffc6c9af827
Removing intermediate container ae0fd3c2cb2e
Step 2 : RUN yum -y update && yum clean all
 ---> Running in 1c67b8772718
..... Installing/Update packages ...
 ---> 075d6ceef3d0
Removing intermediate container 1c67b8772718
Step 3 : RUN yum -y install x11vnc firefox xorg-x11-server-Xvfb xorg-x11-twm tigervnc-server xterm xorg-x11-font xulrunner-26.0-2.fc20.x86_64 dejavu-sans-fonts dejavu-serif-fonts xdotool && yum clean all
..... Installing required packages packages ...
Cleaning up everything
 ---> 986be48760a6
Removing intermediate container c338a1ad6caf
Step 4 : ADD ./xstartup /
 ---> 24fa081dcea5
Removing intermediate container fe98d86ba67f
Step 5 : RUN mkdir /.vnc
 ---> Running in fdb8fe7e697a
 ---> 18f266ace765
Removing intermediate container fdb8fe7e697a
Step 6 : RUN x11vnc -storepasswd 123456 /.vnc/passwd
 ---> Running in c5b7cdba157f
stored passwd in file: /.vnc/passwd
 ---> e4fcf9b17aa9
Removing intermediate container c5b7cdba157f
Step 7 : RUN \cp -f ./xstartup /.vnc/.
 ---> Running in 21d0dc4edb4e
 ---> 4c53914323cb
Removing intermediate container 21d0dc4edb4e
Step 8 : RUN chmod -v +x /.vnc/xstartup
 ---> Running in 38f18f07c996
mode of '/.vnc/xstartup' changed from 0644 (rw-r--r--) to 0755 (rwxr-xr-x)
 ---> caa278024354
Removing intermediate container 38f18f07c996
Step 9 : RUN sed -i '/\/etc\/X11\/xinit\/xinitrc-common/a [ -x /usr/bin/firefox ] && /usr/bin/firefox &' /etc/X11/xinit/xinitrc
 ---> Running in 233e99cab02c
 ---> 421e944ac8b7
Removing intermediate container 233e99cab02c
Step 10 : EXPOSE 5901
 ---> Running in 530cd361cb3c
 ---> 5de01995c156
Removing intermediate container 530cd361cb3c
Step 11 : CMD vncserver -fg
 ---> Running in db89498ae8ce
 ---> 899be39b7feb
Removing intermediate container db89498ae8ce
```

### Wie es funktioniert…

Wir beginnen mit dem Basis-Fedora-Image, installieren das X Windows System, Firefox, einen VNC-Server und andere Pakete. Wir haben dann den VNC-Server eingerichtet, um  X Windows System zu starten, das dann Firefox starten wird.

### Es gibt mehr

Um den Container zu starten, führen Sie den folgenden Befehl aus:
`$ docker run -it -p 5901:5901 fedora/firefox`

Und geben Sie 123456 als das Passwort.

* Beim Ausführen des Containers haben wir den Port `5901` des Hosts auf `5901` Port des Containers abgebildet. Um eine Verbindung zum VNC-Server im Container herzustellen, führen Sie einfach den folgenden Befehl von einem anderen Terminal aus:
`$ vncviewer localhost:1`

Alternativ von einem anderen Rechner im Netzwerk ersetzen Sie localhost durch die IP-Adresse des Docker-Hosts oder FQDN.