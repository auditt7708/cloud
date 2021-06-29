---
title: puppet-cron-start
description: 
published: true
date: 2021-06-09T15:47:33.703Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:47:28.073Z
---

# Puppet für fortgeschrittene: cron benutzen

Sie können viel mit dem Setup tun, das Sie bereits haben: Arbeiten Sie an Ihren Puppet manifes als Team, kommunizieren Änderungen über ein zentrales Git-Repository und manuell auf eine Maschine mit dem `papply` Skript anwenden.

Allerdings musst du dich immer noch in jede Maschine einloggen, um die Git Repo zu aktualisieren und Puppet erneut auszuführen. 
Es wäre hilfreich, jede Maschine selbst zu aktualisieren und Änderungen automatisch vorzunehmen. Dann alles, was Sie tun müssen, ist, eine Änderung in den Repo zu puschen, und es wird zu allen Ihren Maschinen innerhalb einer bestimmten Zeit gehen.

Der einfachste Weg, dies zu tun ist mit einem Cron Job, der Updates aus dem Repo in regelmäßigen Abständen abholt und dann läuft Puppet, wenn sich etwas geändert hat.

## Fertig werden

Du brauchst Rezepte für den Git Repo, den wir in der [Umgebungen mit Git Managen](../puppet/puppet-mgmnt-env-git) und [Erstellen einer dezentralisierten Puppenarchitektur](../puppet/puppet-dezentralisierte-env), und das [papply Skript](../puppet/puppet-papply-script). 
Sie müssen das bootstrap.pp-Manifest anwenden, das wir erstellt haben, um ssh-Schlüssel zu installieren, um das neueste Repository herunterzuladen.

## Wie es geht...

Folge diesen Schritten:

1. Kopiere das Skript bootstrap.pp auf einen beliebigen Node, den du ausrollen möchtest. 
Das bootstrap.pp-Manifest umfasst den privaten Schlüssel, der für den Zugriff auf das Git-Repository verwendet wird. 
Er sollte in einer Produktionsumgebung geschützt werden.

2. Erstelle die Datei `modul../puppet/pupp../puppet/fil../puppet/pull-updates.sh` mit folgendem Inhalt.
```
../puppet/b../puppet/sh
c../puppet/e../puppet/pupp../puppet/cookbook
sudo –u puppet git pull &../puppet/u../puppet/loc../puppet/b../puppet/papply
```

3. Ändern Sie die Module../puppet/pupp../puppet/manifes../puppet/init.pp` Datei und fügen Sie das folgende snippet nach der `papply` Datei Definition hinzu:
```
file {../puppet/u../puppet/loc../puppet/b../puppet/pull-updates':
  source => 'puppe../puppet///modul../puppet/pupp../puppet/pull-updates.sh',
  mode   => '0755',
}
cron { 'run-puppet':
  ensure  => 'present',
  user    => 'puppet',
  command =>../puppet/u../puppet/loc../puppet/b../puppet/pull-updates',
  minute  => ../puppet/10',
  hour    => '*',
}
```

4. Commiten Sie die Änderungen wie zuvor und machen Sie ein git push Sie auf den Git-Server, wie in der folgenden Befehlszeile gezeigt:
```
t@mylaptop puppet$ git add modul../puppet/puppet
t@mylaptop puppet$ git commit -m "adding pull-updates"
[master 7e9bac3] adding pull-updates
 2 files changed, 14 insertions(+)
 create mode 100644 modul../puppet/pupp../puppet/fil../puppet/pull-updates.sh
t@mylaptop puppet$ git push
Counting objects: 14, done.
Delta compression using up to 4 threads.
Compressing objects: 100% ../puppet/7), done.
Writing objects: 100% ../puppet/8), 839 bytes | 0 byt../puppet/s, done.
Total 8 (delta 0), reused 0 (delta 0)
To git@git.example.com:rep../puppet/puppet.git
   7c2e3d5..7e9bac3  master -> master
```

5. Führen Sie einen Git-Pull auf dem Testknoten aus:
```
root@testnode ~# c../puppet/e../puppet/pupp../puppet/cookbo../puppet/
root@testnod../puppet/e../puppet/pupp../puppet/cookbook# sudo –u puppet git pull
remote: Counting objects: 14, done.
remote: Compressing objects: 100% ../puppet/7), done.
remote: Total 8 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% ../puppet/8), done.
From git.example.com:rep../puppet/puppet
   23e887c..7e9bac3  master     -> orig../puppet/master
Updating 7c2e3d5..7e9bac3
Fast-forward
 modul../puppet/pupp../puppet/fil../puppet/pull-updates.sh |    3 +++
 modul../puppet/pupp../puppet/manifes../puppet/init.pp     |   11 +++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 modul../puppet/pupp../puppet/fil../puppet/pull-updates.sh
```

6. Führen Sie Puppet am test node aus:
```
root@testnod../puppet/e../puppet/pupp../puppet/cookbook# papply
Notice: Compiled catalog for testnode.example.com in environment production in 0.17 seconds
Notice../puppet/Stage[mai../puppet/Pupp../puppet/Cron[run-puppe../puppet/ensure: created
Notice../puppet/Stage[mai../puppet/Pupp../puppet/Fil../puppet/u../puppet/loc../puppet/b../puppet/pull-update../puppet/ensure: defined content as '{md5}04c023feb5d566a417b519ea51586398'
Notice: Finished catalog run in 0.16 seconds
```

7. Überprüfen Sie ob das `pull-updates` script richtig arbeitet:
```
root@testnod../puppet/e../puppet/pupp../puppet/cookbook# pull-updates
Already up-to-date.
Notice: Compiled catalog for testnode.example.com in environment production in 0.15 seconds
Notice: Finished catalog run in 0.14 seconds
```

8. Überprüfen das der 'cron' job erfolgreich erstellt wurde. 
```
root@testnod../puppet/e../puppet/pupp../puppet/cookbook# crontab -l -u puppet
# HEADER: This file was autogenerated at Tue Sep 09 02:31:00 -0400 2014 by puppet.
# HEADER: While it can still be managed manually, it is definitely not recommended.
# HEADER: Note particularly that the comments starting with 'Puppet Name' should
# HEADER: not be deleted, as doing so could cause duplicate cron jobs.
# Puppet Name: run-puppet
*/10 * * * ../puppet/u../puppet/loc../puppet/b../puppet/pull-updates
```

Wie es funktioniert...

Als wir das `bootstrap.pp` manifest erstellt haben, haben wir dafür gesorgt, dass der Puppet-User das Git-Repository mit einem `ssh` Schlüssel auschecken kann. Dies ermöglicht dem Puppet-Benutzer, den Git-Pull im Cookbook-Verzeichnis unbeaufsichtigt auszuführen. Wir haben auch das `pull-updates` Skript hinzugefügt, was das macht und läuft Puppet, wenn irgendwelche Änderungen gezogen werden:

```
../puppet/b../puppet/sh
c../puppet/e../puppet/pupp../puppet/cookbook
sudo –u puppet git pull && papply

```
Wir deployen das script zum node mit Puppet:
```
``

Zum Schluß haben wir einen `cron` job erstellt der `pull-updates` in intervalen (hier alle 10 minuten)
```
cron { 'run-puppet':
  ensure  => 'present',
  command =>../puppet/u../puppet/loc../puppet/b../puppet/pull-updates',
  minute  => ../puppet/10',
  hour    => '*',
}
```

## Es gibt mehr...

Herzlichen Glückwunsch, Sie haben jetzt eine vollautomatische Puppeninfrastruktur! 
Sobald Sie das `bootstrap.pp` manifest angewendet haben, führen Sie Puppet auf dem Repository aus. 
Die Maschine wird eingerichtet, um neue Änderungen zu pullen und sie automatisch anzuwenden.

Wenn Sie also zum Beispiel ein neues Benutzerkonto für alle Ihre Maschinen hinzufügen möchten, müssen Sie das Konto in Ihrer Arbeitskopie des Manifests hinzufügen und die Änderungen an das zentrale Git-Repository übernehmen. 
Innerhalb von 10 Minuten wird es automatisch auf jede Maschine angewendet, die Puppet läuft.

