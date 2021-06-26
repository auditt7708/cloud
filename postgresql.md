---
title: postgresql
description: 
published: true
date: 2021-06-09T15:45:20.220Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:45:14.600Z
---

# Postgresql

* [Postgres SQL Shell](../postgresql-sql-shell)
* [Postgres PSQL Dump](../postgres-sql-pgdump.md)

## Postgresql Installation

Installation auf verschiedene Linux Distributionen.

### Installation auf ein Centos 7 OS.

```s
wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-1.noarch.rpm
sudo rpm -ihv pgdg-redhat96-9.6-1.noarch.rpm
sudo yum -y install postgresql96-server postgresql96-devel postgresql96-contrib
sudo systemctl start postgresql-9.6
sudo systemctl status postgresql-9.6
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl enable postgresql-9.6
sudo systemctl start postgresql-9.6
```

Datenbank initialisiren

`sudo postgresql-setup initdb`

Service activiren und starten

`sudo systemctl enable postgresql && sudo systemctl start postgresql`

Installation Sicherer machen

```s
su - postgres
psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'newpassword';"
```

Password des Datenbank benutzers Postgres

### Installation auf ein Debian OS

### Installation auf ein Ubuntu OS

## Quellen zu Postgress Installation

* [YUM_Installation](https://wiki.postgresql.org/wiki/YUM_Installation)
* [install-postgresql-9-6-on-centos-7-rhel-7/](http://yallalabs.com/linux/how-to-install-postgresql-9-6-on-centos-7-rhel-7/)

## [Postgres Administration](../postgresql-sql-shell)

## Fork BIGSQL mit Cluster

|Distribution|Zweck|Ort| Psql Version|
| :---: | :---: | :---: | :---: |
|Debain/Ubuntu|Basisverzeichnis|/opt/postgresql/$version/|9 BigSQL|
|CentOS|Basisverzeichnis|||

### Quellen zu BigSQL

* [BigSQL Debian](https://www.bigsql.org/docs/deb.jsp)

* [app-pgdump](https://www.postgresql.org/docs/9.3/app-pgdump.html)