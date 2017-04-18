Die `Puppetfile` ist ein sehr gutes Format, um zu beschreiben, welche Module Sie in Ihre Umgebung aufnehmen möchten. Auf der `Puppetfile` ist ein weiteres Werkzeug, ** r10k **. R10k ist ein gesamtes umweltmanagement-tool. Sie können r10k verwenden, um ein lokales Git-Repository in Ihren `environmentpath` zu klonen und dann die in deiner `Puppetfile` angegebenen Module in dieses Verzeichnis zu platzieren. Das lokale Git-Repository wird als Master-Repository bezeichnet. Es ist, wo r10k erwartet, um Ihre `Puppetfile` zu ​​finden. r10k versteht auch Puppet-Umgebungen und wird Git-Zweige in Unterverzeichnisse Ihres `environmentpath` klonen, was die Bereitstellung von mehreren Umgebungen vereinfacht. Was macht r10k besonders nützlich ist die Verwendung eines lokalen Cache-Verzeichnisses, um die Implementierungen zu beschleunigen. Mit einer Konfigurationsdatei `r10k.yaml` können Sie festlegen, wo dieser Cache gespeichert werden soll und wo auch Ihr Master-Repository gehalten wird.

### Fertig werden

Wir installieren r10k auf unserem Steuergerät (meist der Master). Hier werden wir alle heruntergeladenen und installierten Module steuern.

1. Installiere r10k auf deinem Puppet master oder auf welcher Maschine du dein `environmentpath` verwalten möchtest:
```
root@puppet:~# puppet resource package r10k ensure=installed provider=gem
Notice: /Package[r10k]/ensure: created
package { 'r10k':
  ensure => ['1.3.5'],
}
```

2. Machen Sie eine neue Kopie Ihres Git-Repositorys (optional, dies auf Ihrem Git-Server):
```
[git@git repos]$ git clone --bare puppet.git puppet-r10k.git
Initialized empty Git repository in /home/git/repos/puppet-r10k.git/
```

3. Schauen Sie sich das neue Git-Repository (auf Ihrem lokalen Rechner) an und verschieben Sie das vorhandene Modulverzeichnis an einen neuen Speicherort. Wir verwenden `/lokal` in diesem Beispiel:
```
t@mylaptop ~ $ git clone git@git.example.com:repos/puppet-r10k.git
Cloning into 'puppet-r10k'...
remote: Counting objects: 2660, done.
remote: Compressing objects: 100% (2136/2136), done.
remote: Total 2660 (delta 913), reused 1049 (delta 238)
Receiving objects: 100% (2660/2660), 738.20 KiB | 0 bytes/s, done.
Resolving deltas: 100% (913/913), done.
Checking connectivity... done.
t@mylaptop ~ $ cd puppet-r10k/
t@mylaptop ~/puppet-r10k $ git checkout production
Branch production set up to track remote branch production from origin.
Switched to a new branch 'production'
t@mylaptop ~/puppet-r10k $ git mv modules local
t@mylaptop ~/puppet-r10k $ git commit -m "moving modules in preparation for r10k"
[master c96d0dc] moving modules in preparation for r10k
 9 files changed, 0 insertions(+), 0 deletions(-)
 rename {modules => local}/base (100%)
 rename {modules => local}/puppet/files/papply.sh (100%)
 rename {modules => local}/puppet/files/pull-updates.sh (100%)
 rename {modules => local}/puppet/manifests/init.pp (100%)

```

### Wie es geht...

Wir erstellen eine Puppetfile, um r10k zu steuern und Module auf unserem Master zu installieren.

1. Erstellen Sie eine `Puppetfile` in das neue Git-Repository mit folgendem Inhalt:
```
forge "http://forge.puppetlabs.com"
mod 'puppetlabs/puppetdb', '3.0.0'
mod 'puppetlabs/stdlib', '3.2.0'
mod 'puppetlabs/concat'
mod 'puppetlabs/firewall'
```

2. Füge die Puppetfile deinem neuen Repository hinzu:
```
t@mylaptop ~/puppet-r10k $ git add Puppetfile
t@mylaptop ~/puppet-r10k $ git commit -m "adding Puppetfile"
[production d42481f] adding Puppetfile
 1 file changed, 7 insertions(+)
 create mode 100644 Puppetfile
t@mylaptop ~/puppet-r10k $ git push
Counting objects: 7, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 589 bytes | 0 bytes/s, done.
Total 5 (delta 2), reused 0 (delta 0)
To git@git.example.com:repos/puppet-r10k.git
   cf8dfb9..d42481f  production -> production
```

3. Zurück zu Ihrem Master, erstellen Sie `/etc/r10k.yaml` mit folgendem Inhalt:
```
---
:cachedir: '/var/cache/r10k'
:sources:
 :plops:
  remote: 'git@git.example.com:repos/puppet-r10k.git'
  basedir: '/etc/puppet/environments'
```

4. Führen Sie r10k aus, um das Verzeichnis `/etc/puppet/environments` zu füllen (Hinweis: Erstellen Sie zuerst eine Sicherung Ihres `/etc/puppet/environments` Verzeichnisses):
`root@puppet:~# r10k deploy environment -p`

5. Vergewissern Sie sich, dass Ihr `/etc/puppet/environments` Verzeichnis ein Produktions-Unterverzeichnis hat. Innerhalb dieses Verzeichnisses existiert das `/lokale` Verzeichnis und das Modulverzeichnis hat alle Module, die in der `Puppetfile` aufgeführt sind:
```
root@puppet:/etc/puppet/environments# tree -L 2
.
├── master
│   ├── manifests
│   ├── modules
│   └── README
└── production
    ├── environment.conf
    ├── local
    ├── manifests
    ├── modules
    ├── Puppetfile
    └── README
```

### Wie es funktioniert...

Wir haben damit begonnen, eine Kopie unseres Git-Repositorys zu erstellen. Dies wurde nur getan, um die früheren Arbeiten zu bewahren und ist nicht erforderlich. Die wichtige Sache, mit r10k und bibliothekar-puppe zu erinnern ist, dass sie beide davon ausgehen, dass sie die Kontrolle über das `/module` Unterverzeichnis haben. Wir müssen unsere Module aus dem Weg ziehen und einen neuen Standort für die Module erstellen.

In der Datei `r10k.yaml` haben wir den Standort unseres neuen Repositories angegeben. Als wir `r10k` liefen, lud es zuerst dieses Repository in seinen lokalen Cache herunter. Sobald das Git-Repository lokal heruntergeladen wird, wird r10k durch jeden Zweig gehen und nach einer Puppetfile im Zweig suchen. Für jede 
`branch/Puppetfile` Kombination werden die im Lieferumfang enthaltenen Module zuerst in das lokale Cache-Verzeichnis (`cachedir`) und dann in das Basedir heruntergeladen, das in `r10k.yaml` gegeben wurde.

### Es gibt mehr...

Sie können die Bereitstellung Ihrer Umgebungen mit `r10k` automatisieren. Der Befehl, den wir verwendet haben, um `r10k` auszuführen und unser Umgebungsverzeichnis zu bevölkern, kann leicht in einen Git-Haken gelegt werden, um automatisch deine Umgebung zu aktualisieren. Es gibt auch ein **marionette collective (mcollective)** (https://github.com/acidprime/r10k), mit dem man `r10k` auf einem beliebigen Satz von Servern laufen lassen kann.

Mit einem dieser Tools wird dazu beitragen, Ihre Website konsistent, auch wenn Sie nicht nutzen die verschiedenen Module auf der Forge.