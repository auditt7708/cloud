MySQL ist ein sehr weit verbreiteter Datenbankserver, und es ist ziemlich sicher, dass Sie irgendwann einen MySQL Server installieren und konfigurieren müssen. Das `puppetlabs-mysql` Modul kann Ihre MySQL-Implementierungen vereinfachen.

### Wie es geht...

Gehen Sie folgendermaßen vor, um das Beispiel zu erstellen:

1. Installiere das `puppetlabs-mysql` Modul:
```
t@mylaptop ~/puppet $ puppet module install -i modules puppetlabs-mysql
Notice: Preparing to install into /home/thomas/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/thomas/puppet/modules
└─┬ puppetlabs-mysql (v2.3.1)
  └── puppetlabs-stdlib (v4.3.2)
```

2. Erstellen Sie eine neue Knotendefinition für Ihren MySQL Server:
```
node dbserver {
  class { '::mysql::server':
    root_password    => 'PacktPub',
    override_options => { 
      'mysqld' => { 'max_connections' => '1024' } 
    }
  }
}
```

3. Führen Sie die Puppe aus, um den Datenbankserver zu installieren und das neue Root-Passwort anzuwenden:
```
[root@dbserver ~]# puppet agent -t
Info: Caching catalog for dbserver.example.com
Info: Applying configuration version '1414566216'
Notice: /Stage[main]/Mysql::Server::Install/Package[mysql-server]/ensure: created
Notice: /Stage[main]/Mysql::Server::Service/Service[mysqld]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Mysql::Server::Service/Service[mysqld]: Unscheduling refresh on Service[mysqld]
Notice: /Stage[main]/Mysql::Server::Root_password/Mysql_user[root@localhost]/password_hash: defined 'password_hash' as '*6ABB0D4A7D1381BAEE4D078354557D495ACFC059'
Notice: /Stage[main]/Mysql::Server::Root_password/File[/root/.my.cnf]/ensure: defined content as '{md5}87bc129b137c9d613e9f31c80ea5426c'
Notice: Finished catalog run in 35.50 seconds
```

4. Vergewissern Sie sich, dass Sie eine Verbindung zur Datenbank herstellen können:
```
[root@dbserver ~]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 5.1.73 Source distribution

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

### Wie es funktioniert...

Das MySQL-Modul installiert den MySQL-Server und stellt sicher, dass der Server läuft. Es konfiguriert dann das Root-Passwort für MySQL. Das Modul macht noch viele andere Dinge für Sie. Es erstellt eine `.my.cnf` Datei mit dem Root-Benutzer-Passwort. Wenn wir den `mysql` Client ausführen, setzt die .`my.cnf` Datei alle Vorgaben, so dass wir keine Argumente liefern müssen.
Es gibt mehr...

Im nächsten Abschnitt zeigen wir, wie man Datenbanken und Benutzer erstellt.