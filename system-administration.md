# Systemd

## systemctl
**Abhängigkeiten Anzeigen**
`systemctl list-dependencies $service`

## journalctl

**Boot vprgänge auflisten**

`journalctl --list-boots`

**Gefilter nach datum**
`journalctl --since "2016-07-01" --until "2 minutes ago"`

**Rechte Prüfen**
`usermod -aG systemd-journal BENUTZERNAME`

**Filter nach Datum und Fehler Level**
`journalctl -p err -b --since "2019-01-11"`

## Path-Units
Mit Hilfe von systemd Path-Units können Dateien oder Verzeichnisse auf Änderungen hin überwacht werden. Tritt ein definiertes Ergebnis wie z.B. das Anlegen einer Datei ein, wird eine Service-Unit ausgeführt.

## Reposyrorys

## RPM

## APT und dep

**Repository bei apt**

```s
wget -O - 'http://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add -
echo deb http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/$(lsb_release -sc)/ ./ \
| tee /etc/apt/sources.list.d/proxysql.list
```
