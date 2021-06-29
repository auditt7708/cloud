---
title: backup-mysqldump
description: 
published: true
date: 2021-06-09T14:57:49.714Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:57:44.773Z
---

# Backup mit mysqldump

Mehere Datenbanken Sichern

`mysqldump -u root -p --databases database_name_a database_name_b > databases_a_b.sql`

Alle Datenbanken sichern

`mysqldump -u root -p --all-databases > all_databases.sql`

All Daten in Separaten Datein Sichern

```sh
for DB in $(mysql -e 'show databases' -s --skip-column-names); do
    mysqldump $DB > "$DB.sql";
done
```

Ein Kompriemiertes Backup durchführen

```sh
mysqldump database_name > | gzip > database_name.sql.gz
```

oder mit xz

```sh

mysqldump database_name > | xz --z -c  > database_name.sql.gz
```

Backup mit Zeitstempel

`mysqldump  database_name > database_name-$(date +%Y%m%d).sql`

Restore eines MySQL dumps

`mysqld  database_name < file.sql`

`mysql -u root -p -e "create database database_name";`

`mysql -u root -p database_name < database_name.sql`

Restore einer DB aus einem Dump mit mehren

`mysql --one-database database_name < all_databases.sql`

Extort und import in einem

`mysqldump -u root -p database_name | mysql -h remote_host -u root -p remote_database_name`
