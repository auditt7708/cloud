Im vorherigen Beispiel haben wir die Raumschiff-Syntax verwendet, um virtuelle Host-Ressourcen für Hosts von Typ-Datenbank zu sammeln oder Web zu schreiben. Sie können den gleichen Trick mit exportierten Ressourcen verwenden. Der Vorteil der Verwendung von exportierten Ressourcen ist, dass beim Hinzufügen weiterer Datenbankserver die Kollektor-Syntax automatisch die neu erstellten exportierten Host-Einträge für diese Server anzieht. Dies macht Ihre `/etc/hosts` Einträge dynamischer.

### Fertig werden

Wir werden exportierte Ressourcen verwenden. Wenn Sie dies noch nicht getan haben, richten Sie puppetdb ein und aktivieren Sie storeconfigs, um puppetdb zu verwenden, wie in Kapitel 2, Puppet Infrastructure beschrieben.

### Wie es geht...

In diesem Beispiel konfigurieren wir Datenbankserver und Clients, um miteinander zu kommunizieren. Wir verwenden die exportierten Ressourcen, um die Konfiguration zu machen.

1. Erstellen Sie ein neues Datenbankmodul, `db`:
`t@mylaptop ~/puppet/modules $ mkdir -p db/manifests`

2. Erstellen Sie eine neue Klasse für Ihre Datenbankserver, `db:: server:`
```
class db::server {
  @@host {"$::fqdn":
    host_aliases => $::hostname,
    ip           => $::ipaddress,
    tag          => 'db::server',
  }
  # rest of db class
}
```

3. Erstellen Sie eine neue Klasse für Ihre Datenbankclients:
```
class db::client {
  Host <<| tag == 'db::server' |>>
}
```

4. Wenden Sie das Datenbank-Server-Modul auf einige Knoten, z.B in `site.pp` an:
```
node 'dbserver1.example.com' {
  class {'db::server': }
}
node 'dbserver2.example.com' {
  class {'db::server': }
}
```

5. Führen Sie die Puppe auf den Knoten mit dem Datenbankservermodul aus, um die exportierten Ressourcen zu erstellen.

6. Wenden Sie das Datenbank-Client-Modul an das Kochbuch an:
```
node 'cookbook' {
  class {'db::client': }
}
```

7. Puppet run:
```
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413782501'
Notice: /Stage[main]/Db::Client/Host[dbserver2.example.com]/ensure: created
Info: Computing checksum on file /etc/hosts
Notice: /Stage[main]/Db::Client/Host[dbserver1.example.com]/ensure: created
Notice: Finished catalog run in 0.10 seconds
```

8. Überprüfen Sie die Host-Einträge in `/etc/hosts`:
```
[root@cookbook ~]# cat /etc/hosts
# HEADER: This file was autogenerated at Mon Oct 20 01:21:42 -0400 2014
# HEADER: by puppet.  While it can still be managed manually, it
# HEADER: is definitely not recommended.
127.0.0.1	localhost  localhost.localdomain localhost4 localhost4.localdomain4 
::1  localhost  localhost.localdomain localhost6 localhost6.localdomain6
83.166.169.231  packtpub.com
192.168.122.150  dbserver2.example.com  dbserver2
192.168.122.151  dbserver1.example.com  dbserver1
```

### Wie es funktioniert...

In der `db::server` Klasse erstellen wir eine exportierte Hostressource:
```
@@host {"$::fqdn":
  host_aliases => $::hostname,
  ip           => $::ipaddress,
  tag          => 'db::server',
}
```

Diese Ressource verwendet den vollständig qualifizierten Domänennamen (`$:fqdn`) des Knotens, auf dem sie angewendet wird. Wir verwenden auch den kurzen Hostnamen (`$::Hostname`) als Alias des Knotens. Aliase werden nach `fqdn` in `/etc/hosts` gedruckt. Wir verwenden die `$::ipaddress` Tatsache des Knotens als IP-Adresse für den Host-Eintrag. Schließlich fügen wir ein Etikett der Ressource hinzu, damit wir auf der Grundlage dieses Tags später sammeln können.

Wichtig ist, dass sich die IP-Adresse für den Host ändern sollte, wird die exportierte Ressource aktualisiert und die Knoten, die die exportierte Ressource sammeln, aktualisieren ihre Host-Datensätze entsprechend.

Wir haben einen Kollektor in `db::client` erstellt, der nur exportierte Hostressourcen sammelt, die mit 'db:: server' markiert wurden:

`Host <<| tag == 'db::server' |>>`

Wir haben die `db::server` Klasse für ein paar nodes, dbserver1 und dbserver2 angewendet, die wir dann auf Kochbuch gesammelt haben, indem wir die `db::client` class anwenden. Die Host-Einträge wurden in `/etc/hosts` (die Standarddatei) platziert. Wir können sehen, dass der Host-Eintrag sowohl den fqdn als auch den kurzen Hostnamen für dbserver1 und dbserver2 enthält.

### Es gibt mehr...

Die Verwendung von exportierten Ressourcen auf diese Weise ist sehr nützlich. Ein anderes ähnliches System wäre, eine NFS-Server-Klasse zu erstellen, die exportierte Ressourcen für die Mount-Punkte erstellt, die sie exportiert (über NFS). Sie können dann Tags verwenden, um Clients die entsprechenden Mount-Punkte vom Server zu sammeln. Im vorherigen Beispiel haben wir von einem Tag Gebrauch gemacht, um in unserer Sammlung von exportierten Ressourcen zu helfen. Es ist erwähnenswert, dass es mehrere Tags hinzugefügt, um Ressourcen, wenn sie erstellt werden, eine davon ist der Umfang, wo die Ressource erstellt wurde.