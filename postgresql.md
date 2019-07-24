# Postgresql

<<<<<<< HEAD
=======
* [Postgres SQL Shell](../postgresql-sql-shell)

>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
## Postgresql Installation

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

<<<<<<< HEAD
### Quellen zu Postgres Installation
=======
## Quellen zu Postgres Installation
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275

* [YUM_Installation](https://wiki.postgresql.org/wiki/YUM_Installation)
* [install-postgresql-9-6-on-centos-7-rhel-7/](http://yallalabs.com/linux/how-to-install-postgresql-9-6-on-centos-7-rhel-7/)

## Fork BIGSQL mit Cluster

<<<<<<< HEAD
|Distribution|Zweck|Ort| Psql Version|
| :---: | :---: | :---: | :---: |
|Debain/Ubuntu|Basisverzeichnis|/opt/postgresql/$version/|9 BigSQL|

### Quellen zu BigSQL 

* [BigSQL Debian](https://www.bigsql.org/docs/deb.jsp)
=======
|Distribution|Zweck|Ort|Psql Version|
| :---: | :---: | :---: | :---: |
|Debain/Ubuntu|Basisverzeichnis|/opt/postgresql/$version/|9 BigSQL|

### Quellen zu BigSQL

* [BigSQL Debian](https://www.bigsql.org/docs/deb.jsp)
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
