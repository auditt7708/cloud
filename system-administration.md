# Systemd

## systemctl

Abhängigkeiten Anzeigen

`systemctl list-dependencies $service`

## journalctl

Boot vprgänge auflisten

`journalctl --list-boots`

Gefilter nach datum

`journalctl --since "2016-07-01" --until "2 minutes ago"`

Rechte Prüfen

`usermod -aG systemd-journal BENUTZERNAME`

Filter nach Datum und Fehler Level

`journalctl -p err -b --since "2019-01-11"`

## Path-Units

Mit Hilfe von systemd Path-Units können Dateien oder Verzeichnisse auf Änderungen hin überwacht werden. Tritt ein definiertes Ergebnis wie z.B. das Anlegen einer Datei ein, wird eine Service-Unit ausgeführt.

## Reposyrorys

## RPM

## APT und dep

Repository bei apt

# System Administrions Tools

Benutzerverwaltung

* [adduser  Hinzufügen eines Benutzers](../adduser)
* [chsh Änderung der Standard-Shell des Benutzers ("change shell")](../chsh)
* [deluser Löschung eines Benutzers ("delete user")](../deluser)
* [groupdel Löschung einer Gruppe ("delete group")](../groupdel)
* [groupmod Bearbeitung einer Gruppe ("modify group")](../groupmod)
* [newgrp Änderung der Gruppe des aktuellen Benutzers ("new group")](../newgrp)
* [passwd Änderung des Passworts eines Benutzers ("password")](../passwd)
* [usermod Bearbeitung eines Benutzerkontos ("modify user")](../)
* [chfn erweiterte Benutzerinformationen anpassen](../chfn)

## Prozesssteuerung

* [ps](../ps)

## Service Management

* [Systemd](../systemd)

### Grundkommandos

* [cat Verknüpfung von Dateien ("concatenate")](../cat)
* [cd Wechsel des Arbeitsverzeichnisses ("change directory")](./cd)
* [cp Kopie von Dateien oder Verzeichnissen ("copy")](../cp)
* [date Anzeige von Datum und Zeit](../date)
* [echo Anzeige eines Textes](../echo)
* [exit Ende der Sitzung](../exit)
* [info Anzeige einer Hilfe-Datei](../info)
* [ln Link zu einer Datei oder einem Verzeichnis ("link")](../link)
* [ls Auflistung von Dateien ("list")](../ls)
* [man Ausgabe der Handbuchseite zu einem Befehl oder einer Anwendung ("manual")](../man)
* [mkdir Erzeugung von Verzeichnissen ("make directory")](..(mkdir))
* [mmv Multiple move (Datei-Mehrfachoperationen mit Hilfe von Wildcard-Mustern)](../mmv)
* [mv Kopieren einer Datei und Löschen der Ursprungsdatei ("move"); mv im aktuellen Verzeichnis ausgeführt: Umbenennung einer Datei](../mv)
* [pwd Anzeige des aktuellen Verzeichnisses ("print working directory")](../pwd)
* [rm Löschen von Dateien und Verzeichnisse ("remove")](../rm)
* [rmdir Löschen eines leeren Verzeichnisses ("remove directory")](../rmdir)
* [sudo Root-Rechte für den Benutzer ("substitute user do")](../sudo)
* [touch Änderung der Zugriffs- und Änderungszeitstempel einer Datei oder eines Verzeichnisses (auch: Erstellen von Dateien)](../touch)
* [unlink Löschen einer Datei](../unlink)

### Netzwerk

* [dig Namensauflösung (DNS)](../dig)
* [iwconfig Werkzeug für WLAN-Schnittstellen](../iwconfig)
* [ip Anzeigen und Konfiguration von Netzwerkgeräten. Nachfolger von ifconfig](../ifconfig)
* [iw der Nachfolger von iwconfig](../)
* [netstat Auflistung offener Ports und bestehender Netzwerkverbindungen ("network statistics")](../)
* [ping Prüfen der Erreichbarkeit anderer Rechner über ein Netzwerk](../)
* [route 🇩🇪 Anzeige und Änderung der Route (Routingtabelle)](../)
* [ss der Nachfolger von netstat ("socket statistics")](../)
* [traceroute Routenverfolgung und Verbindungsanalyse](../)
* [nc nmap ](../nmap)

### Dateiwerkzeuge

* [basename Rückgabe des Dateinamens](../basename)
* [lsof Anzeige offener Dateien ("list open files")](../lsof)
* [](../)

Systemüberwachung

* [](../)
* [](../)
* [](../)
* [](../)
* [](../)
* [](../)

Pager

* [less](../system-administration-pager-less)

Wietere Nützliche Befehle

* [](../system-administration-pager)
* [](../system-administration-pager)
* [](../system-administration-pager)
* [](../system-administration-pager)
* [](../system-administration-pager)
* [](../system-administration-pager)

Packet Managemnet

* [](../)
* [](../)
* [](../)
* [](../)
* [](../)
* [](../)

RPM

* [RPM](../rpm)
* [YUM](../yum)
* [Repositories](../repositories)
* [](../)

APT und dep

* [APT](../apt)
* [DEP](../dep)
* [](../)
* [](../)

Repository bei apt

* [](../)
* [](../)
* [](../)
* [](../)

```s
wget -O - 'http://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add -
echo deb http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/$(lsb_release -sc)/ ./ \
| tee /etc/apt/sources.list.d/proxysql.list
```
