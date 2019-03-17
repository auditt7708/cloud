# Puppet bash bootstraping

Bissher haben wir in diesem Buche  Rakefiles verwendet um puppet einzurichten.

Das Problem mit der Verwendung von Rake, um eine Node zu konfigurieren ist, dass Sie die Befehle von Ihrem Laptop ausführen; Sie nehmen an, Sie haben bereits ssh Zugriff auf die Maschine.
Die meisten Bootstrap-Prozesse arbeiten, indem sie einen leicht zu merkenden Befehl von einem Node aus provisioniren, sobald er bereitgestellt wurde.
In diesem Abschnitt zeigen wir, wie man bash verwendet, um Puppet mit einem Webserver und einem Bootstrap-Skript zu starten.

## Fertig werden

Installieren Sie httpd auf einem zentral zugänglichen Server und erstellen Sie einen passwortgeschützten Bereich, um das Bootstrap-Skript zu speichern. In meinem Beispiel verwende ich den Git-Server, den ich vorher eingerichtet habe, git.example.com. Beginnen Sie mit dem Erstellen eines Verzeichnisses im Stammverzeichnis Ihres Webservers:

```s
cd /var/www/html
mkdir bootstrap
```

## Führen Sie nun folgende Schritte aus

1.Fügen Sie der Apache-Konfiguration folgende location definition hinzu:

```s
<Location /bootstrap>
AuthType basic
AuthName "Bootstrap"
AuthBasicProvider file
AuthUserFile /var/www/puppet.passwd
Require valid-user
</Location>
```

2.Laden Sie Ihren Webserver neu, um sicherzustellen, dass die Standortkonfiguration funktioniert. Überprüfen Sie mit `curl`, dass Sie nicht aus dem Bootstrap-Verzeichnis ohne Authentifizierung etwas herunterladen können:

```html
[root@bootstrap-test tmp]# curl http://git.example.com/bootstrap/
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>401 Authorization Required</title>
</head><body>
<h1>Authorization Required</h1>
```

3.Erstellen Sie die Passwortdatei, auf die Sie in der Apache-Konfiguration verwiesen haben (`/var/www/puppet.passwd`):

```s
root@git# cd /var/www
root@git# htpasswd –cb puppet.passwd bootstrap cookbook
Adding password for user bootstrap

```

4.Vergewissern Sie sich, dass der Benutzername und das Kennwort den Zugriff auf das Bootstrap-Verzeichnis wie folgt zulassen:

```html
[root@node1 tmp]# curl --user bootstrap:cookbook http://git.example.com/bootstrap/
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /bootstrap</title>

```

## Wie es geht

Nun, da Sie einen sicheren Ort haben, um das Bootstrap-Skript zu speichern, erstellen Sie ein Bootstrap-Skript für jedes Betriebssystem, das Sie im Bootstrap-Verzeichnis unterstützen.
In diesem Beispiel werde ich Ihnen zeigen, wie dies für eine Red Hat Enterprise Linux 6-basierte Distribution tun.

### Tipp

Obwohl der Bootstrap-Standort ein Passwort benötigt, gibt es keine Verschlüsselung, da wir kein SSL auf unserem Server konfiguriert haben. Ohne Verschlüsselung ist die Übertragung nicht sehr sicher.

Erstellen Sie ein Skript namens el6.sh im Bootstrap-Verzeichnis mit folgendem Inhalt:

```s
# bootstrap for EL6 distributions
SERVER=git.example.com
LOCATION=/bootstrap
BOOTSTRAP=bootstrap.pp
USER=bootstrap
PASS=cookbook

# install puppet
curl http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs >/etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum -y install puppet
# download bootstrap
curl --user $USER:$PASS http://$SERVER/$LOCATION/$BOOTSTRAP >/tmp/$BOOTSTRAP
# apply bootstrap
cd /tmp
puppet apply /tmp/$BOOTSTRAP
# apply puppet
puppet apply --modulepath /etc/puppet/cookbook/modules /etc/puppet/cookbook/manifests/site.pp
```

## Wie es funktioniert

Die Apache-Konfiguration erlaubt nur den Zugriff auf das Bootstrap-Verzeichnis mit einer Benutzernamen- und Passwort-Kombination.
Wir liefern diese mit dem - Benutzer-Argument zu kräuseln, wodurch man Zugang zu der Datei erhält.
Wir verwenden ein Rohr (|), um die Ausgabe von curl in bash umzuleiten.
Dies führt dazu, dass bash das Skript ausführt. Wir schreiben unsere Bash-Skript wie wir irgendwelche anderen bash Skript. Das bash script lädt unser bootstrap.pp manifest und wendet es an.
Schließlich wenden wir das Puppenmanifest aus dem Git-Repository an und die Maschine ist als Mitglied unserer dezentralen Infrastruktur konfiguriert.