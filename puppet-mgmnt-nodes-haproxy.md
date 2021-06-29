---
title: puppet-mgmnt-nodes-haproxy
description: 
published: true
date: 2021-06-09T15:52:46.804Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:52:41.297Z
---

# Puppet Managemnt von HAProxy

Lastausgleicher(Load balancers) werden verwendet, um eine Ladung auf eine Anzahl von Servern zu verbreiten. Hardware-Lastverteiler sind immer noch etwas teuer, während Software-Balancer die meisten Vorteile einer Hardware-Lösung erreichen können.

**HAProxy** ist die Software-Load-Balancer der Wahl für die meisten Menschen: schnell, leistungsstark und hoch konfigurierbar.

## Wie es geht

In diesem Rezept, werde ich Ihnen zeigen, wie man einen HAProxy-Server zu laden-Balance Web-Anfragen über Web-Servern zu bauen. Wir verwenden exportierte Ressourcen, um die `haproxy` Konfigurationsdatei zu erstellen, genau wie wir es für das NFS-Beispiel getan haben.

1.Erstellen Sie die Datei `modules/haproxy/manifests/master.pp` mit folgendem Inhalt:

```ruby
class haproxy::master ($app = 'myapp') {
  # The HAProxy master server
  # will collect haproxy::slave resources and add to its balancer
  package { 'haproxy': ensure => installed }
  service { 'haproxy':
    ensure  => running,
    enable  => true,
    require => Package['haproxy'],
  }

  include haproxy::config

  concat::fragment { 'haproxy.cfg header':
    target  => 'haproxy.cfg',
    source  => 'puppet:///modules/haproxy/haproxy.cfg',
    order   => '001',
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }

  # pull in the exported entries
  Concat::Fragment <<| tag == "$app" |>> {
    target => 'haproxy.cfg',
    notify => Service['haproxy'],
  }
}

```

2.Erstellen Sie die Datei `module/haproxy/files/haproxy.cfg` mit folgendem Inhalt:

```s
global
        daemon
        user haproxy
        group haproxy
        pidfile /var/run/haproxy.pid

defaults
        log     global
        stats   enable
        mode    http
        option  httplog
        option  dontlognull
        option  dontlog-normal
        retries 3
        option  redispatch
        timeout connect 4000
        timeout client 60000
        timeout server 30000

listen  stats :8080
        mode http
        stats uri /
        stats auth haproxy:topsecret

listen  myapp 0.0.0.0:80
        balance leastconn
```

3.Ändern Sie Ihre `manifests/nodes.pp` Datei wie folgt:

```ruby
node 'cookbook' {
  include haproxy
}
```

4.Erstellen Sie die Slave-Server-Konfiguration in der `haproxy::slave` Klasse:

```ruby
class haproxy::slave ($app = "myapp", $localport = 8000) {
  # haproxy slave, export haproxy.cfg fragment
  # configure simple web server on different port
  @@concat::fragment { "haproxy.cfg $::fqdn":
    content => "\t\tserver ${::hostname} ${::ipaddress}:${localport}   check maxconn 100\n",
    order   => '0010',
    tag     => "$app",
  }
  include myfw
  firewall {"${localport} Allow HTTP to haproxy::slave":
    proto  => 'tcp',
    port   => $localport,
    action => 'accept',
  }

  class {'apache': }
  apache::vhost { 'haproxy.example.com':
    port          => '8000',
    docroot => '/var/www/haproxy',
  }
  file {'/var/www/haproxy':
    ensure  => 'directory',
    mode    => 0755,
    require => Class['apache'],
  }
  file {'/var/www/haproxy/index.html':
    mode    => '0644',
    content => "<html><body><h1>${::fqdn} haproxy::slave\n</body></html>\n",
    require => File['/var/www/haproxy'],
  }
}
```

5.Erstellen Sie die `concat` Container-Ressource in der `haproxy::config` Klasse wie folgt:

```ruby
class haproxy::config {
  concat {'haproxy.cfg':
    path  => '/etc/haproxy/haproxy.cfg',
    order => 'numeric',
    mode  => '0644',
  }
}
```

6.Ändern Sie `site.pp`, um die Master- und Slave-Nodes zu definieren:

```ruby
node master {
  class {'haproxy::master':
    app => 'cookbook'
  }
}
node slave1,slave2 {
  class {'haproxy::slave':
    app => 'cookbook'
  }
}
```

7.Run Puppet auf jedem der Slave-Server:

```s
root@slave1:~# puppet agent -t
Info: Caching catalog for slave1
Info: Applying configuration version '1415646194'
Notice: /Stage[main]/Haproxy::Slave/Apache::Vhost[haproxy.example.com]/File[25-haproxy.example.com.conf]/ensure: created
Info: /Stage[main]/Haproxy::Slave/Apache::Vhost[haproxy.example.com]/File[25-haproxy.example.com.conf]: Scheduling refresh of Service[httpd]
Notice: /Stage[main]/Haproxy::Slave/Apache::Vhost[haproxy.example.com]/File[25-haproxy.example.com.conf symlink]/ensure: created
Info: /Stage[main]/Haproxy::Slave/Apache::Vhost[haproxy.example.com]/File[25-haproxy.example.com.conf symlink]: Scheduling refresh of Service[httpd]
Notice: /Stage[main]/Apache::Service/Service[httpd]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Apache::Service/Service[httpd]: Unscheduling refresh on Service[httpd]
Notice: Finished catalog run in 1.71 seconds

```

8.Führen Sie Puppet auf dem Masterknoten aus, um `haproxy` zu konfigurieren und auszuführen:

```s
[root@master ~]# puppet agent -t
Info: Caching catalog for master.example.com
Info: Applying configuration version '1415647075'
Notice: /Stage[main]/Haproxy::Master/Package[haproxy]/ensure: created
Notice: /Stage[main]/Myfw::Pre/Firewall[0000 Allow all traffic on loopback]/ensure: created
Notice: /Stage[main]/Myfw::Pre/Firewall[0001 Allow all ICMP]/ensure: created
Notice: /Stage[main]/Haproxy::Master/Firewall[8080 haproxy statistics]/ensure: created
Notice: /File[/etc/sysconfig/iptables]/seluser: seluser changed 'unconfined_u' to 'system_u'
Notice: /Stage[main]/Myfw::Pre/Firewall[0022 Allow all TCP on port 22 (ssh)]/ensure: created
Notice: /Stage[main]/Haproxy::Master/Firewall[0080 http haproxy]/ensure: created
Notice: /Stage[main]/Myfw::Pre/Firewall[0002 Allow all established traffic]/ensure: created
Notice: /Stage[main]/Myfw::Post/Firewall[9999 Drop all other traffic]/ensure: created
Notice: /Stage[main]/Haproxy::Config/Concat[haproxy.cfg]/File[haproxy.cfg]/content: 
...
+listen  myapp 0.0.0.0:80
+        balance leastconn
+    server slave1 192.168.122.148:8000   check maxconn 100
+    server slave2 192.168.122.133:8000   check maxconn 100

Info: Computing checksum on file /etc/haproxy/haproxy.cfg
Info: /Stage[main]/Haproxy::Config/Concat[haproxy.cfg]/File[haproxy.cfg]: Filebucketed /etc/haproxy/haproxy.cfg to puppet with sum 1f337186b0e1ba5ee82760cb437fb810
Notice: /Stage[main]/Haproxy::Config/Concat[haproxy.cfg]/File[haproxy.cfg]/content: content changed '{md5}1f337186b0e1ba5ee82760cb437fb810' to '{md5}b070f076e1e691e053d6853f7d966394'
Notice: /Stage[main]/Haproxy::Master/Service[haproxy]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Haproxy::Master/Service[haproxy]: Unscheduling refresh on Service[haproxy]
Notice: Finished catalog run in 33.48 seconds
```

9.Überprüfen Sie die HAProxy Stats-Schnittstelle auf Master Port `8080` in [Ihrem Webbrowser](http://master.example.com:8080), um sicherzustellen, dass alles in Ordnung ist (Der Benutzername und das Passwort sind in `haproxy.cfg`, `haproxy` und `topsecret`). Versuche es auch mit dem Prospekt zu betreiben. Beachten Sie, dass sich die Seite bei jedem Reload ändert, wenn der Dienst [von Slave1 an Slave2](http://master.example.com) umgeleitet wird.

## Wie es funktioniert

Wir haben eine komplexe Konfiguration aus verschiedenen Komponenten der vorherigen Abschnitte aufgebaut. Diese Art der Bereitstellung wird einfacher, je mehr Sie es tun. Auf einer obersten Ebene haben wir den Master konfiguriert, um exportierte Ressourcen von Slaves zu sammeln. Die Slaves haben ihre Konfigurationsinformationen exportiert, damit Haproxy sie im Load Balancer verwenden kann. Da Slaves dem System hinzugefügt werden, können sie ihre Ressourcen exportieren und dem Balancer automatisch hinzugefügt werden.

Wir haben unser `myfw` Modul benutzt, um die Firewall auf den Slaves und dem Master zu konfigurieren, um die Kommunikation zu ermöglichen.

Wir haben das Forge Apache Modul verwendet, um den zuhörenden Webserver auf den Slaves zu konfigurieren. Wir konnten eine voll funktionsfähige Website mit fünf Codezeilen generieren (10 weitere, um `index.html` auf der Website zu platzieren).

Hier gibt es mehrere Sachen. Wir haben die Firewall-Konfiguration und die Apache-Konfiguration zusätzlich zur `haproxy` Konfiguration. Wir konzentrieren uns darauf, wie die exportierten Ressourcen und die `haproxy` Konfiguration zusammenpassen.

In der `haproxy::config` Klasse haben wir den Concat-Container für die `haproxy` Konfiguration erstellt:

```ruby
class haproxy::config {
  concat {'haproxy.cfg':
    path  => '/etc/haproxy/haproxy.cfg',
    order => 'numeric',
    mode  => 0644,
  }
}
```

Wir verweisen darauf in `haproxy::slave` :

```ruby
class haproxy::slave ($app = "myapp", $localport = 8000) {
  # haproxy slave, export haproxy.cfg fragment
  # configure simple web server on different port
  @@concat::fragment { "haproxy.cfg $::fqdn":
    content => "\t\tserver ${::hostname} ${::ipaddress}:${localport}   check maxconn 100\n",
    order   => '0010',
    tag     => "$app",
  }
```

Wir machen hier einen kleinen Trick mit Concat; Wir definieren das Ziel nicht in der exportierten Ressource. Wenn wir das taten, würden die Sklaven versuchen, eine Datei `/etc/haproxy/haproxy.cfg` zu erstellen, aber die Slaves haben keine `haproxy` Installation, so dass wir Katalogfehler erhalten würden. Was wir tun, ändert die Ressource, wenn wir es in `haproxy::master` sammeln:

```ruby
# pull in the exported entries
  Concat::Fragment <<| tag == "$app" |>> {
    target => 'haproxy.cfg',
    notify => Service['haproxy'],
  }
```

Zusätzlich zum Hinzufügen des Ziels, wenn wir die Ressource sammeln, fügen wir auch eine Benachrichtigung hinzu, damit der `haproxy` Dienst neu gestartet wird, wenn wir der Konfiguration einen neuen Host hinzufügen. Ein weiterer wichtiger Punkt ist, dass wir das Auftragsattribut der Slave-Konfigurationen auf 0010 setzen, wenn wir den Header für die Datei `haproxy.cfg` definieren; Wir verwenden einen Auftragswert von 0001, um sicherzustellen, dass der Header am Anfang der Datei platziert wird:

```ruby
concat::fragment { 'haproxy.cfg header':
    target  => 'haproxy.cfg',
    source  => 'puppet:///modules/haproxy/haproxy.cfg',
    order   => '001',
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }
```

Der Rest der `haproxy::master` Klasse beschäftigt sich mit der Konfiguration der Firewall wie in früheren Beispielen.

## Es gibt mehr

HAProxy verfügt über eine Vielzahl von Konfigurationsparametern, die Sie erkunden können. Siehe die HAProxy-Website unter http://haproxy.1wt.eu/#docs.

Obwohl es am häufigsten als Web-Server verwendet wird, kann HAProxy viel mehr als nur HTTP proxy. Es kann jede Art von TCP-Verkehr zu behandeln, so können Sie es verwenden, um die Last von MySQL-Servern, SMTP, Video-Server oder alles, was Sie mögen auszugleichen.

Sie können das Design verwenden, das wir gezeigt haben, um viele Probleme der Koordination von Diensten zwischen mehreren Servern anzugreifen. Diese Art von Interaktion ist sehr verbreitet; Sie können es auf viele Konfigurationen für Lastverteilung oder verteilte Systeme anwenden. Sie können denselben Workflow verwenden, der zuvor beschrieben wurde, damit Knoten Firewall-Ressourcen (`@@firewall`) exportieren können, um ihren eigenen Zugriff zu ermöglichen.