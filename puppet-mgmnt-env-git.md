# Puppet Managemnt mit git

Brunches sind ein Weg, um mehrere verschiedene tracks der Entwicklung in einem einzigen Quell-Repository zu halten.
Puppet umgebungen sind oft wie Git branches.
Sie können den gleichen Code mit leichten Variationen zwischen den unterschidlichen Zweigen haben, so wie Sie verschiedene Module für verschiedene Umgebungen haben können.
In diesem Abschnitt zeigen wir, wie man Git-Zweige benutzt, um Umgebungen auf dem Puppet-Master zu definieren.

## Fertig werden

Im vorherigen Abschnitt haben wir ein Produktionsverzeichnis erstellt, das auf dem Masterzweig basierte. Wir entfernen dieses Verzeichnis jetzt:

`puppet@puppet:/etc/puppet/environments$ mv production production.master`

## Wie es geht

Ändern Sie den Post-Receiver-Hook, um eine Verzweigungsvariable zu akzeptieren.
Der Hook wird diese Variable verwenden, um ein Verzeichnis auf dem Puppet Master wie folgt zu erstellen:

```s
#!/bin/sh

read oldrev newrev refname
branch=${refname#*\/*\/}

git push puppetmaster $branch
ssh puppet@puppet.example.com "if [ ! -d
/etc/puppet/environments/$branch ]; then git clone
 /etc/puppet/environments/puppet.git
 /etc/puppet/environments/$branch; fi; cd
 /etc/puppet/environments/$branch; git checkout $branch; git pull"
```

Ändern Sie Ihre `README` Datei erneut und puchen Sie auf das Repository auf der maschine `git.example.com`:

```s
t@mylaptop puppet$ git add README
t@mylaptop puppet$ git commit -m "Adding README"
[master 539d9f8] Adding README
 1 file changed, 1 insertion(+)
t@mylaptop puppet$ git push
Counting objects: 5, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 374 bytes | 0 bytes/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: To puppet@puppet.example.com:/etc/puppet/environments/puppet.git
remote:    0d6b49f..539d9f8  master -> master
remote: Cloning into '/etc/puppet/environments/master'...
remote: done.
remote: Already on 'master'
remote: Already up-to-date.
To git@git.example.com:repos/puppet.git
   0d6b49f..539d9f8  master -> master
```

## Wie es funktioniert

Der Hook liest nun den `refname` und analysiert den branch, der aktualisiert wird.
Wir verwenden diese branch variable, um das Repository in ein neues Verzeichnis zu klonen und den branch auszuprobieren.

## Es gibt mehr

Jetzt, wenn wir eine neue Umgebung schaffen wollen, können wir im Git-Repository einen neuen branch erstellen.
Der branch wird ein Verzeichnis auf dem Puppet Master erstellen.
Jeder branch des Git-Repositories stellt eine Umgebung auf dem Puppenmeister dar:

1. git branch und checkout in production

```s
t@mylaptop puppet$ git branch production
t@mylaptop puppet$ git checkout production
Switched to branch 'production'
```

2.Aktualisiere den Produktionszweig und drücke zum Git Server wie folgt:

```s
t@mylaptop puppet$ vim README
t@mylaptop puppet$ git add README
t@mylaptop puppet$ git commit -m "Production Branch"
t@mylaptop puppet$ git push origin production
Counting objects: 7, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 372 bytes | 0 bytes/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: To puppet@puppet.example.com:/etc/puppet/environments/puppet.git
remote:    11db6e5..832f6a9  production -> production
remote: Cloning into '/etc/puppet/environments/production'...
remote: done.
remote: Switched to a new branch 'production'
remote: Branch production set up to track remote branch production from origin.
remote: Already up-to-date.
To git@git.example.com:repos/puppet.git
   11db6e5..832f6a9  production -> production
```

Jetzt, wenn wir einen neuen branch erstellen, wird im Verzeichnis unserer environment ein entsprechendes Verzeichnis angelegt.
Eine Eins-zu-Eins-Abbildung wird zwischen environment und branch hergestellt.