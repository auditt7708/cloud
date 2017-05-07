Apache ist der beliebteste Webserver der Welt, also ist es sehr wahrscheinlich, dass ein Teil Ihrer Puppet-Aufgaben die Installation und Verwaltung von Apache beinhalten wird.

### Wie es geht...

Wir installieren und verwenden das `puppetlabs-apache` Modul zum Installieren und Starten von Apache. Dieses Mal, wenn wir `puppet module install` installieren, verwenden wir die Option `-i`, um Puppet zu sagen, das Modul in unserem Modul des Git-Repositorys zu installieren.

1. Installieren Sie das Modul mit `puppet modules install` installieren:
```
t@mylaptop ~/puppet $ puppet module install -i modules puppetlabs-apache
Notice: Preparing to install into /home/thomas/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/thomas/puppet/modules
└─┬ puppetlabs-apache (v1.1.1)
  ├── puppetlabs-concat (v1.1.1)
  └── puppetlabs-stdlib (v4.3.2)
```

2. Fügen Sie die Module zu Ihrem Git-Repository hinzu und commiten Sie es:
```
t@mylaptop ~/puppet $ git add modules/apache modules/concat modules/stdlib
t@mylaptop ~/puppet $ git commit -m "adding puppetlabs-apache module"
[production 395b079] adding puppetlabs-apache module
 647 files changed, 35017 insertions(+), 13 deletions(-)
 rename modules/{apache => apache.cookbook}/manifests/init.pp (100%)
 create mode 100644 modules/apache/CHANGELOG.md
 create mode 100644 modules/apache/CONTRIBUTING.md
...
t@mylaptop ~/puppet $ git push origin production
Counting objects: 277, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (248/248), done.
Writing objects: 100% (266/266), 136.25 KiB | 0 bytes/s, done.
Total 266 (delta 48), reused 0 (delta 0)
remote: To puppet@puppet.example.com:/etc/puppet/environments/puppet.git
remote:    9faaa16..395b079  production -> production
```
3. Erstellen Sie eine Web-Server-Nodedefinition in `site.pp`:
```
node webserver {
  class {'apache': }
}
```

4. Führen Sie Puppet aus, um die Standard-Apache-Modulkonfiguration anzuwenden:
```
[root@webserver ~]# puppet agent -t
Info: Caching certificate for webserver.example.com
Notice: /File[/var/lib/puppet/lib/puppet/provider/a2mod]/ensure: created
...
Info: Caching catalog for webserver.example.com
...
Info: Class[Apache::Service]: Scheduling refresh of Service[httpd]
Notice: /Stage[main]/Apache::Service/Service[httpd]: Triggered 'refresh' from 51 events
Notice: Finished catalog run in 11.73 seconds
```

5. Überprüfen Sie, ob Sie `webserver.example.com` erreichen können:
```
[root@webserver ~]# curl http://webserver.example.com
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /</title>
 </head>
 <body>
<h1>Index of /</h1>
<table><tr><th><img src="/icons/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></tr><tr><th colspan="5"><hr></th></tr>
<tr><th colspan="5"><hr></th></tr>
</table>
</body></html>
```

### Wie es funktioniert...

Durch das Installieren des Puppetlabs-Apache-Moduls aus dem Forge werden sowohl Puppetlabs-Concat als auch Puppetlabs-Stdlib in unser Modulverzeichnis eingerichtet. Das Concat-Modul wird verwendet, um Snippets von Dateien zusammen in einer bestimmten Reihenfolge zu benutzen. Es wird vom Apache-Modul verwendet, um die wichtigsten Apache-Konfigurationsdateien zu erstellen.

Wir haben dann einen Web-Server-Node definiert und die Apache-Klasse auf diesen Node angewendet. Wir haben alle Standardwerte verwendet und lassen das Apache Modul unseren Server als Apache Webserver konfigurieren.

Das Apache-Modul ging dann hin und schrieb alle unsere Apache-Konfigurationen um. Standardmäßig löscht das Modul alle Konfigurationsdateien aus dem Apache-Verzeichnis (`/etc/apache2` oder `/etc/httpd` je nach Verteilung). 
Das Modul kann viele verschiedene Verteilungen konfigurieren und die Nuancen jeder Verteilung behandeln. Als Benutzer des Moduls müssen Sie nicht wissen, wie sich Ihre Distribution mit der Konfiguration des Apache-Moduls befasst.

Nach dem Aufräumen und Umschreiben der Konfigurationsdateien sorgt das Modul dafür, dass der Apache2-Dienst läuft (`httpd` auf Enterprise Linux (EL)).

Wir haben dann den Webserver mit curl getestet. Es wurde nichts zurückgegeben, sondern eine leere Indexseite. Dies ist das erwartete Verhalten. Normalerweise, wenn wir Apache auf einem Server installieren, gibt es einige Dateien, die eine Standardseite (`welcome.conf` auf EL-basierten Systemen) anzeigen, da das Modul diese Konfigurationen gelöscht hat, sehen wir nur eine leere Seite.

In einer Produktionsumgebung würden Sie die vom Apache-Modul angewendeten Vorgaben ändern. 
Die vorgeschlagene Konfiguration aus dem README ist wie folgt:

```
class { 'apache':
  default_mods        => false,
  default_confd_files => false,
}
```
