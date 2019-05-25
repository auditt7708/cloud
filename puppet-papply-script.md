Wir möchten es so schnell und einfach wie möglich machen, Puppet auf eine Maschine anzuwenden. 
Dafür werden wir ein kleines Skript schreiben, das den `puppet apply` Befehlt mit den dafür benötigten Parametern umgibt. Wir werden das Skript bereitstellen, wo es für Puppet selbst benötigt wird.

### Wie es geht...

Folge diesen Schritten:

1. In deinem Puppet-Repo kannst du die für einPuppet modul benötigten Verzeichnisse erstellen:
```
t@mylaptop ~$ cd puppet/modules
t@mylaptop modules$ mkdir -p puppet/{manifests,files}
```

2. Erstellen Sie die Module `/puppet/files/papply.sh` mit folgendem Inhalt:
```
#!/bin/bash 
sudo puppet apply /etc/puppet/cookbook/manifests/site.pp \--modulepath=/etc/puppet/cookbook/modules $*
```

3. Erstellen Sie die Module `/puppet/manifests/init.pp` mit folgendem Inhalt:
```
class puppet {
  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/puppet/papply.sh',
    mode   => '0755',
  }
}
```

4. Passsen Sie die Datei `manifests/site.pp` wie folgt an:
```
node default {
  include base
  include puppet
}
```

5. Füge das Puppet-Modul dem Git-Repository hinzu und commite die Änderung wie folgt:
```
t@mylaptop puppet$ git add manifests/site.pp modules/puppet
t@mylaptop puppet$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
modified:   manifests/site.pp
new file:   modules/puppet/files/papply.sh
new file:   modules/puppet/manifests/init.pp
t@mylaptop puppet$ git commit -m "adding puppet module to include papply"
[master 7c2e3d5] adding puppet module to include papply
 3 files changed, 11 insertions(+)
 create mode 100644 modules/puppet/files/papply.sh
 create mode 100644 modules/puppet/manifests/init.pp
```

6. Denken Sie daran, die Änderungen an das Git-Repository auf `git.example.com` anzuwenden:
```
t@mylaptop puppet$ git push origin master Counting objects: 14, done. Delta compression using up to 4 threads. Compressing objects: 100% (7/7), done. Writing objects: 100% (10/10), 894 bytes | 0 bytes/s, done. Total 10 (delta 0), reused 0 (delta 0) To git@git.example.com:repos/puppet.git 23e887c..7c2e3d5  master -> master
```

7. Ziehen Sie die neueste Version des Git-Repositorys auf Ihren neuen Knoten (`testnode` für mich), wie in der folgenden Befehlszeile gezeigt:
```
root@testnode ~# sudo -iu puppet
puppet@testnode ~$ cd /etc/puppet/cookbook/puppet@testnode /etc/puppet/cookbook$ git pull origin master remote: Counting objects: 14, done. remote: Compressing objects: 100% (7/7), done. remote: Total 10 (delta 0), reused 0 (delta 0) Unpacking objects: 100% (10/10), done. From git.example.com:repos/puppet * branch            master     -> FETCH_HEAD Updating 23e887c..7c2e3d5 Fast-forward manifests/site.pp                |    1 + modules/puppet/files/papply.sh   |    4 ++++ modules/puppet/manifests/init.pp |    6 ++++++ 3 files changed, 11 insertions(+), 0 deletions(-) create mode 100644 modules/puppet/files/papply.sh create mode 100644 modules/puppet/manifests/init.pp
```

8. Wenden Sie das Manifest einmal manuell an, um das `papply` Skript zu installieren:
```
root@testnode ~# puppet apply /etc/puppet/cookbook/manifests/site.pp --modulepath /etc/puppet/cookbook/modules
Notice: Compiled catalog for testnode.example.com in environment production in 0.13 seconds
Notice: /Stage[main]/Puppet/File[/usr/local/bin/papply]/ensure: defined content as '{md5}d5c2cdd359306dd6e6441e6fb96e5ef7'
Notice: Finished catalog run in 0.13 seconds
```

9.0 Hier , das test script 
```root@testnode ~# papply
Notice: Compiled catalog for testnode.example.com in environment production in 0.13 seconds
Notice: Finished catalog run in 0.09 seconds

```

Nun, wann immer du Puppet laufen lassen musst, kannst du einfach `papply` aufrufen. 
In der Zukunft, wenn wir Puppet Änderungen anwenden, werde ich `papply` nutzen, anstelle des vollständigen Puppenbefehls anzugeben.


### Wie es funktioniert

Wie Sie gesehen haben, um Puppet auf einer Maschine auszuführen und eine bestimmte Manifest-Datei anzuwenden, verwenden wir den Befehl `puppet apply`:
`puppet apply manifests/site.pp`


Wenn du Module einsetzt (wie das Puppet-Modul, das wir gerade erstellt haben), musst du auch dem Puppet mitteilen, wo du Module suchst, mit dem Modulpath-Argument:
`puppet apply manifests/nodes.pp \--modulepath=/home/ubuntu/puppet/modules`

Um Puppet mit den root privilegien zu betreiben, muss man `sudo` vor alles setzen:
`sudo puppet apply manifests/nodes.pp \--modulepath=/home/ubuntu/puppet/modules`

Schließlich werden alle weiteren Argumente, die durch `papply` angerufen werden, an die Puppe selbst übergeben, indem sie den `$*` -Parameter addieren:

`sudo puppet apply manifests/nodes.pp \--modulepath=/home/ubuntu/puppet/modules $*`

Das ist eine Menge Tippen, so dass dies in einem Skript Sinn macht . Wir haben eine Puppet-Datei hinzugefügt, die das Skript zu `/usr/local/bin` bereitstellt und es ausführbar macht:

```
file { '/usr/local/bin/papply': source => 'puppet:///modules/puppet/papply.sh', mode   => '0755',}`

Zuletzt fügen wir das puppet module in unsere default node declaration ein:
`node default {
  include base
  include puppet
}
```

