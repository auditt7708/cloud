## Postgresql 96

++Installation**
```
wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-1.noarch.rpm
sudo rpm -ihv pgdg-redhat96-9.6-1.noarch.rpm
sudo yum -y install postgresql96-server postgresql96-devel postgresql96-contrib
sudo systemctl start postgresql-9.6
sudo systemctl status postgresql-9.6
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl enable postgresql-9.6
sudo systemctl start postgresql-9.6
```
###### Quellen: 
* [YUM_Installation](https://wiki.postgresql.org/wiki/YUM_Installation)
* [install-postgresql-9-6-on-centos-7-rhel-7/](http://yallalabs.com/linux/how-to-install-postgresql-9-6-on-centos-7-rhel-7/)

# Fork BIGSQL mit Cluster

|Distribution|Zweck|Ort| Psql Version|
| :---: | :---: | :---: | :---: |
|Debain/Ubuntu|Basisverzeichnis|/opt/postgresql/$version/|9 BigSQL|

Quellen:
* [BigSQL Debian](https://www.bigsql.org/docs/deb.jsp)