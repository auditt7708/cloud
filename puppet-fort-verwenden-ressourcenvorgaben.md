# Puppet für fortgeschrittene: Ressourcen vorgaben und Defaultwerte

Ein Puppet-Modul ist eine Gruppe von verwandten Ressourcen, in der Regel gruppiert, um einen bestimmten Dienst zu konfigurieren. Innerhalb eines Moduls können Sie mehrere Ressourcen definieren. Ressourcen-Standardeinstellungen können Sie die Standardattributwerte für eine Ressource angeben. In diesem Beispiel zeigen wir Ihnen, wie Sie eine Ressource-Standard für den Dateityp angeben.

## Wie es geht

Um Ihnen zu zeigen, wie Sie Ressourcen-Standardwerte verwenden, erstellen wir ein Apache-Modul. Innerhalb dieses Moduls werden wir angeben, dass der Default-Besitzer und die Gruppe der Apache-Benutzer wie folgt sind:

1.Erstellen Sie ein Apache-Modul und erstellen Sie eine Ressource-Standard für den Dateityp:

```ruby
  class apache {
    File {
      owner => 'apache',
      group => 'apache',
      mode => 0644,
    }
  }
```

2.Erstellen Sie HTML-Dateien im Verzeichnis `/var/www/html`:

```ruby
  file {'/var/www/html/index.html':
    content => "<html><body><h1><a
      href='cookbook.html'>Cookbook!
      </a></h1></body></html>\n",
  }
  file {'/var/www/html/cookbook.html':
    content =>
      "<html><body><h2>PacktPub</h2></body></html>\n",
  }
```

3.Füge diese Klasse deiner Standard Node definition hinzuzufügen oder um Puppet zu verwenden , um das Modul auf deinen Node zu übertragen. 
Ich benutze die Methode, die wir im vorherigen Kapitel konfiguriert haben, indem wir unseren Code in das Git-Repository schieben und einen Git-Hook verwenden, um den Code auf dem Puppet-Master wie folgt einzusetzen:

```s
t@mylaptop ~/puppet $ git pull origin production
From git.example.com:repos/puppet
 * branch            production -> FETCH_HEAD
Already up-to-date.
t@mylaptop ~/puppet $ cd modules
t@mylaptop ~/puppet/modules $ mkdir -p apache/manifests
t@mylaptop ~/puppet/modules $ vim apache/manifests/init.pp
t@mylaptop ~/puppet/modules $ cd ..
t@mylaptop ~/puppet $ vim manifests/site.pp 
t@mylaptop ~/puppet $ git status
On branch production
Changes not staged for commit:
modified:   manifests/site.pp
Untracked files:
modules/apache/
t@mylaptop ~/puppet $ git add manifests/site.pp modules/apache
t@mylaptop ~/puppet $ git commit -m 'adding apache module'
[production d639a86] adding apache module
 2 files changed, 14 insertions(+)
 create mode 100644 modules/apache/manifests/init.pp
t@mylaptop ~/puppet $ git push origin production
Counting objects: 13, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (8/8), 885 bytes | 0 bytes/s, done.
Total 8 (delta 0), reused 0 (delta 0)
remote: To puppet@puppet.example.com:/etc/puppet/environments/puppet.git
remote:    832f6a9..d639a86  production -> production
remote: Already on 'production'
remote: From /etc/puppet/environments/puppet
remote:    832f6a9..d639a86  production -> origin/production
remote: Updating 832f6a9..d639a86
remote: Fast-forward
remote:  manifests/site.pp                |    1 +
remote:  modules/apache/manifests/init.pp |   13 +++++++++++++
remote:  2 files changed, 14 insertions(+)
remote:  create mode 100644 modules/apache/manifests/init.pp
To git@git.example.com:repos/puppet.git
   832f6a9..d639a86  production -> production
```

4.Wenden Sie das Modul auf einen Knoten an oder führen Sie die Puppe aus:

```s
Notice: /Stage[main]/Apache/File[/var/www/html/cookbook.html]/ensure: defined content as '{md5}493473fb5bde778ca93d034900348c5d'
Notice: /Stage[main]/Apache/File[/var/www/html/index.html]/ensure: defined content as '{md5}184f22c181c5632b86ebf9a0370685b3'
Notice: Finished catalog run in 2.00 seconds
[root@hiera-test ~]# ls -l /var/www/html
total 8
-rw-r--r--. 1 apache apache 44 Sep 15 12:00 cookbook.html
-rw-r--r--. 1 apache apache 73 Sep 15 12:00 index.html

```

## Wie es funktioniert

Die von uns definierte Ressource-Default gibt den Besitzer, die Gruppe und den Modus für alle Dateiressourcen innerhalb dieser Klasse an (auch in diesem Bereich bekannt). Wenn Sie nicht explizit einen Ressourcen-Standard überschreiben, wird der Wert für ein Attribut aus der Standardeinstellung genommen.

## Es gibt mehr

Sie können Ressourcen-Standardwerte für jeden Ressourcentyp angeben. Sie können auch die Ressourcenvorgaben in site.pp. Ich finde es sinnvoll, die Standardaktion für Paket- und Serviceressourcen wie folgt anzugeben:

```ruby
  Package { ensure => 'installed' }
  Service {
    hasrestart => true,
    enable     => true,
    ensure     => true,
  }
```

Bei diesen Vorgaben wird, wenn Sie ein Paket angeben, das Paket installiert. Wenn Sie einen Dienst angeben, wird der Dienst gestartet und aktiviert, um beim Booten ausgeführt zu werden. Dies sind die üblichen Gründe, die Sie Pakete und Dienstleistungen angeben, die meiste Zeit, tun diese Vorgaben, was Sie bevorzugen und Ihr Code wird sauberer sein. Wenn Sie einen Dienst deaktivieren müssen, überschreiben Sie einfach die Vorgaben.