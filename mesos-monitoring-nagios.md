---
title: mesos-monitoring-nagios
description: 
published: true
date: 2021-06-09T15:38:50.982Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:38:45.254Z
---

# Mesos Monitoring mit Nagios

Die Überwachung ist ein wichtiger Teil der Instandhaltung der Infrastruktur. Mesos integriert sich gut mit den bestehenden Monitoring-Lösungen und verfügt über Plugins für die meisten Monitoring-Lösungen wie Nagios. Dieses Modul gibt Ihnen eine exemplarische Vorgehensweise bei der Installation von Nagios auf Ihrem Cluster und ermöglicht die Überwachung, um Ihnen E-Mail-Benachrichtigungen zu senden, wann immer etwas in Ihrem Cluster schief geht.
Installieren von Nagios 4

Das erste, was wir vor der Installation von Nagios tun müssen, besteht darin, dem System einen Nagios-Benutzer hinzuzufügen, aus dem der Nagios-Prozess laufen kann und Warnungen aussenden kann. Wir können einen neuen Benutzer und eine neue Benutzergruppe für Nagios erstellen, indem wir die folgenden Befehle ausführen:

```sh
$ sudo useradd nagios
$ sudo groupadd nagcmd
$ sudo usermod -a -G nagcmd nagios
``` 
Hier haben wir einen Benutzer, Nagios und eine Benutzergruppe, `nagcmd` erstellt, die dem Benutzer Nagios im dritten oben aufgeführten Befehl zugeordnet ist.

Installieren Sie nun die Abhängigkeitspakete mit folgendem Befehl:
`$ sudo apt-get install build-essential libgd2-xpm-dev openssl libssl-dev xinetd apache2-utils unzip`

Sobald die Abhängigkeiten installiert sind und der Benutzer hinzugefügt wird, können wir mit dem Herunterladen und Installieren von `nagios` beginnen, indem wir die folgenden Befehle ausführen:

```sh
#Download the nagios archive.
$ wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz
# Extract the archive.
$ tar xvf nagios-*.tar.gz
# Change the working directory to nagios
$ cd nagios*

# Configure and build nagios
$ ./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-mail=/usr/sbin/sendmail
$ make all

# Install nagios, init scripts and sample configuration file
$ sudo make install
$ sudo make install-commandmode
$ sudo make install-init
$ sudo make install-config
$ sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

```

Sobald `nagios` installiert ist, können wir das `nagios` Plugin installieren, indem wir es herunterladen und erstellen, indem wir die folgenden Befehle ausgeben:

```sh
wget http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
tar xvf nagios-plugins-*.tar.gz
cd nagios-plugins-*
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
sudo make install
```

Sobald die Plugins installiert sind, können wir **NRPE (Nagios Remote Plugin Executor)** installieren, um Statusaktualisierungen von entfernten Rechnern zu übernehmen. Es kann durch Ausführen der folgenden Befehle installiert werden:

```sh
wget http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz

tar xf nrpe*.tar.gz
cd nrpe*

./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu

make all
sudo make install
sudo make install-xinetd
sudo make install-daemon-config
```

Aus Sicherheitsgründen bearbeiten Sie die Datei unter `/etc/xinetd.d/nrpe` mit folgendem Inhalt:

`only_from = 127.0.0.1 10.132.224.168`

Ersetzen Sie die IP-Adresse durch die IP-Adresse des `nagios` Servers, damit nur unser `nagios` Server Remote-Anrufe tätigen kann. Sobald dies geschehen ist, speichern Sie die Datei und beenden und starten Sie den `xintend` Dienst neu, indem Sie den folgenden Befehl ausführen:

`sudo service xinetd restart`

Jetzt, da `nagios` installiert ist, können wir die Kontakt-E-Mail-Adressen konfigurieren, an die die Benachrichtigungen gesendet werden, indem Sie die folgende Datei bearbeiten:

`sudo vi /usr/local/nagios/etc/objects/contacts.cfg`

Suchen und ersetzen Sie die folgende Zeile mit Ihrer eigenen E-Mail-Adresse:

`email nagios@localhost ; << ** Change this to your email address **`

Fügen Sie einen Benutzer zu `nagios` hinzu, damit wir uns aus dem Browser anmelden können und sehen Sie die Aktivitäten, indem Sie den folgenden Befehl ausführen. Hier haben wir `nagiosadmin` als Benutzernamen und Passwort verwendet:

`sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin`

Starten Sie nun den `nagios` Dienst neu, indem Sie den folgenden Befehl ausgeben:

`sudo service nagios restart` 

Wir können uns jetzt im `nagios` Admin-Panel anmelden, indem wir aus dem Browser auf die folgende URL zugreifen:

`http://MachineIP/nagios`

`MachineIP` ist die IP-Adresse der Maschine, auf der wir `nagios` installiert haben, und es wird Sie mit einem Authentifizierungsformular auffordern, in dem Sie den Benutzernamen und das Passwort als `nagiosadmin` angeben können.

![nagios-login](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_05_06.jpg)

Nach der Authentifizierung gelangen Sie zur Nagios Homepage. Um zu sehen, welche Hosts von Nagios überwacht werden, klicken Sie auf den Link Hosts auf der linken Seite, wie im folgenden Screenshot gezeigt (Quelle: https://www.digitalocean.com/community/tutorials/how-to- Install-nagios-4-und-Monitor-dein-Server-on-ubuntu-14-04):

![Nagios4-overview](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_05_07.jpg)

Nun werden wir diskutieren, wie wir NRPE nutzen können, um die Knoten in unserem Mesos-Cluster zu überwachen.

Im folgenden Abschnitt wird eine Maschine zu Nagios hinzugefügt, um zu überwachen, und wir können die gleichen Schritte wiederholen, um so viele Maschinen wie erforderlich hinzuzufügen. Vorläufig wählen wir den zu überwachenden Mesos-Masterknoten aus und es wird eine E-Mail ausgelöst, wenn der Datenträgerverbrauch für ein bestimmtes Laufwerk den angegebenen Betrag übersteigt.

Nun, auf der Master-Maschine, installieren Sie die Nagios Plugins und `nrpe-server` mit dem folgenden Befehl:

`sudo apt-get install nagios-plugins nagios-nrpe-server`

Wie bereits erwähnt, aus Sicherheitsgründen die Datei `/etc/nagios/nrpe.cfg` bearbeiten und die IP-Adresse des `nagios` Servers für die Kommunikation unter der Eigenschaft `allowed_hosts` setzen.

Bearbeiten Sie nun die `nrpe` Konfigurationsdatei mit den Eigenschaften, um die Datenträgerverwendung über den folgenden Befehl zu überwachen:
`sudo vi /etc/nagios/nrpe.cfg`

Fügen Sie dann den folgenden Inhalt hinzu:

```sh
server_address=client_private_IP
allowed_hosts=nagios_server_private_IP
command[check_hda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/vda
```

Hier ist `server_address` die IP-Adresse der Maschine, `allowed_hosts` ist die `nagios` Serveradresse und der Befehl ist der eigentliche Befehl, um die Datenträgerverwendung zu ziehen. Wir verwendeten das `check_disk` Plugin, das mit `nagios` kommt und übergibt die Argumente an den Befehl als `-w 20%` `-c 10%`. Wenn der Server 20% Festplattenverbrauch übersteigt, wird Nagios einen E-Mail-Alarm auslösen.

Sobald wir die Datei bearbeiten, starten Sie den `nrpe` Server mit folgendem Befehl neu:

`sudo service nagios-nrpe-server restart`

Nun, da wir den Mesos-Master konfiguriert haben, um die Datenträgerverwendung zu überprüfen, müssen wir diesen Mesos-Master auch dem Nagios-Server hinzufügen, damit er die Datenträgerverwendung überprüfen und die Administratoren bei der Überschreitung des Kontingents benachrichtigen kann.

Fügen Sie eine neue Konfigurationsdatei auf dem Nagios-Server hinzu, um zu überwachen, und wir können die Datei in `/usr/local/nagios/etc/servers/` wie folgt hinzufügen:

`sudo vi /usr/local/nagios/etc/servers/mesos-master.cfg`

Fügen Sie dann den folgenden Inhalt hinzu:

```s
    define host {
            use                             linux-server
            host_name                       mesos-master
            alias                           Mesos master server
            address                         10.132.234.52
            max_check_attempts              5
            check_period                    24x7
            notification_interval           30
            notification_period             24x7
    }
```

Diese Konfiguration wird die Überwachung der Mesos-Master-Maschine behalten, um zu prüfen, ob sie noch läuft. Der Administrator (oder andere, wie in der E-Mail-Liste angegeben) erhält eine E-Mail-Benachrichtigung, wenn die Mesos-Mastermaschine heruntergefahren wird.

Wir können auch die Überprüfung der Netzwerknutzung durch Hinzufügen des folgenden Dienstes aktivieren:

```s
    define service {
            use                             generic-service
            host_name                       mesos-master
            service_description             PING
            check_command                   check_ping!100.0,20%!500.0,60%

    }
```

Sobald wir die Konfigurationen für den neuen Host eingestellt haben, müssen wir `nagios` neu starten, indem wir den folgenden Befehl ausführen:

`$ sudo service nagios reload`

Wir können auch neue Konfigurationsdateien für Slave-Knoten erstellen, indem wir die oben aufgeführten Schritte befolgen.