Nginx ist ein schneller, leichtgewichtiger Webserver, der in vielen Kontexten über Apache bevorzugt wird, besonders dort, wo hohe Leistung wichtig ist. Nginx ist etwas anders konfiguriert als Apache; Wie Apache aber gibt es ein Forge-Modul, das verwendet werden kann, um nginx für uns zu konfigurieren. Im Gegensatz zu Apache wird das Modul, das für den Gebrauch vorgeschlagen wird, nicht von Puppetlabs geliefert, sondern von James Fryman. Dieses Modul verwendet einige interessante Tricks, um sich selbst zu konfigurieren. Bisherige Versionen dieses Moduls nutzten das `Modul_data` Paket von R.I. Pienaar. Dieses Paket wird verwendet, um hieradata innerhalb eines Moduls zu konfigurieren. Es wird verwendet, um Standardwerte für das nginx-Modul zu liefern. Ich würde nicht empfehlen, mit diesem Modul an dieser Stelle zu beginnen, aber es ist ein gutes Beispiel dafür, wo Modulkonfiguration in der Zukunft geleitet werden kann. Den Modellen die Möglichkeit zu geben, hieradata zu modifizieren, kann sich als nützlich erweisen.

### Wie es geht...

In diesem Beispiel verwenden wir ein Forge-Modul, um nginx zu konfigurieren. Wir laden das Modul herunter und verwenden es, um virtualhosts zu konfigurieren.

1. Laden Sie das `jfryman-nginx` Modul von der Forge herunter:
```
t@mylaptop ~ $ cd ~/puppet
t@mylaptop ~/puppet $ puppet module install -i modules jfryman-nginx
Notice: Preparing to install into /home/thomas/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/thomas/puppet/modules
└─┬ jfryman-nginx (v0.2.1)
  ├── puppetlabs-apt (v1.7.0)
  ├── puppetlabs-concat (v1.1.1)
  └── puppetlabs-stdlib (v4.3.2)
```

2. Ersetzen Sie die Definition für Webserver durch eine nginx-Konfiguration:
```
node webserver {
  class {'nginx':}
  nginx::resource::vhost { 'mescalero.example.com':
      www_root => '/var/www/mescalero',
  }
  file {'/var/www/mescalero':
    ensure  => 'directory''directory',
    mode    => '0755',
    require => Nginx::Resource::Vhost['mescalero.example.com'],
  }
  file {'/var/www/mescalero/index.html':
    content => "<html>\nmescalero.example.com\nhttp://en.wikipedia.org/wiki/Mescalero\n</html>\n",
    mode    => 0644,
    require => File['/var/www/mescalero'],
  }
}
```

3. Wenn Apache noch auf Ihrem Webserver läuft, hör doch auf:
```
[root@webserver ~]# puppet resource service httpd ensure=false
Notice: /Service[httpd]/ensure: ensure changed 'running' to 'stopped'
service { 'httpd':
  ensure => 'stopped',
}
Run puppet agent on your webserver node:
[root@webserver ~]# puppet agent -t
Info: Caching catalog for webserver.example.com
Info: Applying configuration version '1414561483'
Notice: /Stage[main]/Main/Node[webserver]/Nginx::Resource::Vhost[mescalero.example.com]/Concat[/etc/nginx/sites-available/mescalero.example.com.conf]/File[/etc/nginx/sites-available/mescalero.example.com.conf]/ensure: defined content as '{md5}35bb59bfcd0cf5a549d152aaec284357'
Info: /Stage[main]/Main/Node[webserver]/Nginx::Resource::Vhost[mescalero.example.com]/Concat[/etc/nginx/sites-available/mescalero.example.com.conf]/File[/etc/nginx/sites-available/mescalero.example.com.conf]: Scheduling refresh of Class[Nginx::Service]
Info: Concat[/etc/nginx/sites-available/mescalero.example.com.conf]: Scheduling refresh of Class[Nginx::Service]
Notice: /Stage[main]/Main/Node[webserver]/Nginx::Resource::Vhost[mescalero.example.com]/File[mescalero.example.com.conf symlink]/ensure: created
Info: /Stage[main]/Main/Node[webserver]/Nginx::Resource::Vhost[mescalero.example.com]/File[mescalero.example.com.conf symlink]: Scheduling refresh of Service[nginx]
Notice: /Stage[main]/Main/Node[webserver]/File[/var/www/mescalero]/ensure: created
Notice: /Stage[main]/Main/Node[webserver]/File[/var/www/mescalero/index.html]/ensure: defined content as '{md5}2bd618c7dc3a3addc9e27c2f3cfde294'
Notice: /Stage[main]/Nginx::Config/File[/etc/nginx/conf.d/proxy.conf]/ensure: defined content as '{md5}1919fd65635d49653273e14028888617'
Info: Computing checksum on file /etc/nginx/conf.d/example_ssl.conf
Info: /Stage[main]/Nginx::Config/File[/etc/nginx/conf.d/example_ssl.conf]: Filebucketed /etc/nginx/conf.d/example_ssl.conf to puppet with sum 84724f296c7056157d531d6b1215b507
Notice: /Stage[main]/Nginx::Config/File[/etc/nginx/conf.d/example_ssl.conf]/ensure: removed
Info: Computing checksum on file /etc/nginx/conf.d/default.conf
Info: /Stage[main]/Nginx::Config/File[/etc/nginx/conf.d/default.conf]: Filebucketed /etc/nginx/conf.d/default.conf to puppet with sum 4dce452bf8dbb01f278ec0ea9ba6cf40
Notice: /Stage[main]/Nginx::Config/File[/etc/nginx/conf.d/default.conf]/ensure: removed
Info: Class[Nginx::Config]: Scheduling refresh of Class[Nginx::Service]
Info: Class[Nginx::Service]: Scheduling refresh of Service[nginx]
Notice: /Stage[main]/Nginx::Service/Service[nginx]: Triggered 'refresh' from 2 events
Notice: Finished catalog run in 28.98 seconds
```

4. Vergewissern Sie sich, dass Sie den neuen virtualhost erreichen können:
```
[root@webserver ~]# curl mescalero.example.com
<html>
mescalero.example.com
http://en.wikipedia.org/wiki/Mescalero
</html>
```

### Wie es funktioniert...

Durch das Installieren des `jfryman-nginx` Moduls werden die Concat-, Stdlib- und APT-Module installiert. Wir rennen Puppet auf unserem Master, um die Plugins zu erstellen, die von diesen Modulen zu unserem laufenden Master hinzugefügt wurden. Die Stdlib und Concat haben Facter und Puppet Plugins, die für das Nginx Modul installiert werden müssen, um richtig zu funktionieren.

Wenn die Plugins synchronisiert sind, können wir dann Puppet Agent auf unserem Webserver ausführen. Als Vorsichtsmaßnahme stoppen wir Apache, wenn es vorher gestartet wurde (wir können nicht nginx und Apache beide auf Port `80` hören). Nachdem Puppenträger ausgegeben wurden, haben wir festgestellt, dass nginx läuft und der virtuelle Host konfiguriert wurde.

### Es gibt mehr...

Dieses nginx Modul ist unter aktiver Entwicklung. Es gibt mehrere interessante Lösungen mit dem Modul. Bisherige Releases verwendeten das Modul `ripienaar-module_data`, das es einem Modul ermöglicht, Standardwerte für seine verschiedenen Attribute über ein Hiera-Plugin aufzunehmen. Obwohl es noch in einem frühen Entwicklungsstadium ist, ist dieses System bereits verwendbar und stellt eines der modernsten Module der Forge dar.

Im nächsten Abschnitt verwenden wir ein unterstütztes Modul zur Konfiguration und Verwaltung von MySQL-Installationen.