# Updaten  von einem  Paket

`yum update mysql`

## Auflisten eine Paketes

`yum list openssh`

## Informationen über ein Paket

`yum info firefox`

## Alle Installierten Pakete auflisten

`yum list all`

## Ausgeben zu welchem Paket eine Datei gehört.

`yum provides /etc/httpd/conf/httpd.conf`

## Auf Updates prüfen

`yum check-update`

#### Alle Gruppen zum installieren auflisten

`yum grouplist`

#### Gruppen Paket installieren

`yum groupinstall 'MySQL Database'`

#### Update eines gruppen Pakets

`yum groupupdate 'DNS Name Server'`

#### Gruppen Paket entfernen

`yum groupremove 'DNS Name Server'`

#### Repos auflisten , activ

`yum repolist`

#### Alle Repos auflisten

`yum repolist all`

#### Installiere ein packt von einem bestimmten repo

`yum --enablerepo=epel install phpmyadmin`

####  History der Installationen ausgeben

`yum history`

#### History bestimmte Transaktionen auflisten

`yum history list start_id..end_id`

**Quellen:**

* [Yum-Transaction_History](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sec-Yum-Transaction_History.html)
* [Yum Priorities](https://wiki.centos.org/PackageManagement/Yum/Priorities)
* []()