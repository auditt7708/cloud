Das Verwalten einer Datenbank bedeutet mehr als sicherzustellen, dass der Dienst ausgeführt wird; Ein Datenbankserver ist nichts ohne Datenbanken. Datenbanken benötigen Benutzer und Privilegien. Privilegien werden mit GRANT-Anweisungen behandelt. Wir verwenden das puppetlabs-mysql-Paket, um eine Datenbank und einen Benutzer mit Zugriff auf diese Datenbank zu erstellen. Wir erstellen einen MySQL-User Drupal und eine Datenbank namens Drupal. Wir erstellen eine Tabelle namens nodes und platzieren Sie Daten in diese Tabelle.
Wie es geht...

Gehen Sie folgendermaßen vor, um Datenbanken und Benutzer zu erstellen:

1. Erstellen Sie eine Datenbankdefinition in Ihrer `dbserver` Klasse:
```
mysql::db { 'drupal':
    host    => 'localhost',
    user    => 'drupal',
    password    => 'Cookbook',
    sql     => '/root/drupal.sql',
    require => File['/root/drupal.sql']
  }

  file { '/root/drupal.sql':
    ensure => present,
    source => 'puppet:///modules/mysql/drupal.sql',
  }
```

2. Erlaube dem Drupal-Benutzer, die Knoten-Tabelle zu ändern:
```
mysql_grant { 'drupal@localhost/drupal.nodes':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'drupal.nodes'nodes',
    user       => 'drupal@localhost',
  }
```

3. Erstellen Sie die Datei `drupal.sql` mit folgendem Inhalt:
```
CREATE TABLE users (id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(255), body TEXT);
INSERT INTO users (id, title, body) VALUES (1,'First Node','Contents of first Node');
INSERT INTO users (id, title, body) VALUES (2,'Second Node','Contents of second Node');
```

4. Führen Sie die Puppe aus, um Benutzer, Datenbank und `GRANT` zu erstellen:
```
[root@dbserver ~]# puppet agent -t
Info: Caching catalog for dbserver.example.com
Info: Applying configuration version '1414648818'
Notice: /Stage[main]/Main/Node[dbserver]/File[/root/drupal.sql]/ensure: defined content as '{md5}780f3946cfc0f373c6d4146394650f6b'
Notice: /Stage[main]/Main/Node[dbserver]/Mysql_grant[drupal@localhost/drupal.nodes]/ensure: created
Notice: /Stage[main]/Main/Node[dbserver]/Mysql::Db[drupal]/Mysql_user[drupal@localhost]/ensure: created
Notice: /Stage[main]/Main/Node[dbserver]/Mysql::Db[drupal]/Mysql_database[drupal]/ensure: created
Info: /Stage[main]/Main/Node[dbserver]/Mysql::Db[drupal]/Mysql_database[drupal]: Scheduling refresh of Exec[drupal-import]
Notice: /Stage[main]/Main/Node[dbserver]/Mysql::Db[drupal]/Mysql_grant[drupal@localhost/drupal.*]/ensure: created
Notice: /Stage[main]/Main/Node[dbserver]/Mysql::Db[drupal]/Exec[drupal-import]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 10.06 seconds
```

5. Vergewissern Sie sich, dass die Datenbank und die Tabelle erstellt wurden:
```
[root@dbserver ~]# mysql drupal
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 34
Server version: 5.1.73 Source distribution

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show tables;
+------------------+
| Tables_in_drupal |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)

```

6. Vergewissern Sie sich nun, dass unsere Standarddaten in die Tabelle geladen wurden:

```
mysql> select * from users;
+----+-------------+-------------------------+
| id | title       | body                    |
+----+-------------+-------------------------+
|  1 | First Node  | Contents of first Node  |
|  2 | Second Node | Contents of second Node |
+----+-------------+-------------------------+
2 rows in set (0.00 sec)
```

### Wie es funktioniert...

Wir beginnen mit der Definition der neuen drupal Datenbank:
```
  mysql::db { 'drupal':
    host    => 'localhost',
    user    => 'drupal',
    password    => 'Cookbook',
    sql     => '/root/drupal.sql',
    require => File['/root/drupal.sql']
  }
```

Wir geben an, dass wir von localhost (wir könnten eine Verbindung zur Datenbank von einem anderen Server) mit dem drupal Benutzer verbinden. Wir geben das Passwort für den Benutzer und geben eine SQL-Datei an, die nach der Erstellung der Datenbank auf die Datenbank angewendet wird. Wir benötigen, dass diese Datei bereits vorhanden ist und die Datei als nächstes definieren
```
file { '/root/drupal.sql':
    ensure => present,
    source => 'puppet:///modules/mysql/drupal.sql',
  }
```

Wir stellen dann sicher, dass der Benutzer die entsprechenden Berechtigungen mit einer `mysql_grant` Anweisung hat:
```
  mysql_grant { 'drupal@localhost/drupal.nodes':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'drupal.nodes',
    user       => 'drupal@localhost',
  }
```

### Es gibt mehr...

Mit dem puppetlabs-MySQL und dem puppetlabs-Apache-Modul können wir einen ganzen funktionierenden Webserver erstellen. Das Puppetlabs-Apache-Modul installiert Apache, und wir können auch das PHP-Modul und das MySQL-Modul aufnehmen. Wir können dann das Puppetlabs-Mysql-Modul verwenden, um den MySQL-Server zu installieren und dann die benötigten Drupal-Datenbanken zu erstellen und die Datenbank mit den Daten zu säen.

Die Bereitstellung einer neuen Drupal-Installation wäre so einfach wie eine Klasse auf einem Knoten.