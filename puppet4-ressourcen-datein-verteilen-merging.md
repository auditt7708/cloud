# puppet4-ressourcen-datein-verteilen-merging

Wie wir im vorigen Kapitel gesehen haben, hat die Datei Ressource einen `recurse` Parameter, der Puppet erlaubt, ganze Verzeichnisbäume zu übertragen. Wir haben diesen Parameter verwendet, um die Dotfiles eines Admin-Benutzers in ihr Home-Verzeichnis zu kopieren. In diesem Abschnitt zeigen wir, wie man `recurse` und einen anderen Parameter `sourceselect` verwendet, um unser vorheriges Beispiel zu erweitern.

## Wie es geht

Ändern Sie unser Admin-Benutzerbeispiel wie folgt:

1.Entfernen Sie den Parameter `$dotfiles`, entfernen Sie die Bedingung basierend auf `$dotfiles`. Fügen Sie eine zweite Quelle der Home-Verzeichnis `file` hinzu:

```pp
define admin_user ($key, $keytype) {
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
  $username = $name
  user { $username:
    ensure     => present,
  }
  file { "/home/${username}/.ssh":
    ensure  => directory,
    mode    => '0700',
    owner   => $username,
    group   => $username,
    require => File["/home/${username}"],
  }
  ssh_authorized_key { "${username}_key":
    key     => $key,
    type    => "$keytype",
    user    => $username,
    require => File["/home/${username}/.ssh"],
  }
  # copy in all the files in the subdirectory
  file { "/home/${username}":
    recurse => true,
    mode    => '0700',
    owner   => $username,
    group   => $username,
    source  => [
      "puppet:///modules/admin_user/${username}",
      'puppet:///modules/admin_user/base' ],
    sourceselect => 'all',
    require      => User["$username"],
  }
}

```

2.Erstellen Sie ein Basisverzeichnis und kopieren Sie alle Systemstandarddateien von `/etc/skel`:

`t@mylaptop ~/puppet/modules/admin_user/files $ cp -a /etc/skel base`

3.Erstellen Sie eine neue `admin_user` ressource, eine, die kein Verzeichnis definiert hat:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
node 'cookbook' {
  admin_user {'steven':
    key     => 'AAAAB3N...',
    keytype => 'dsa',
  }
}
```

4.Puppet run:

```pp
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413787159'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/User[steven]/ensure: created
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven]/ensure: created
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven/.bash_logout]/ensure: defined content as '{md5}6a5bc1cc5f80a48b540bc09d082b5855'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven/.emacs]/ensure: defined content as '{md5}de7ee35f4058681a834a99b5d1b048b3'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven/.bashrc]/ensure: defined content as '{md5}2f8222b4f275c4f18e69c34f66d2631b'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven/.bash_profile]/ensure: defined content as '{md5}f939eb71a81a9da364410b799e817202'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/File[/home/steven/.ssh]/ensure: created
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[steven]/Ssh_authorized_key[steven_key]/ensure: created
Notice: Finished catalog run in 1.11 seconds
```

## Wie es funktioniert

Wenn eine `file` Ressource hat die `recurse` Parameter auf sie gesetzt, und es ist ein Verzeichnis, wird Puppet nicht nur das Verzeichnis selbst, sondern alle seine Inhalte (einschließlich Unterverzeichnisse und deren Inhalt). Wie wir im vorherigen Beispiel gesehen haben, wenn eine Datei mehr als eine Quelle hat, wird die erste gefundene Quelldatei verwendet, um die Anforderung zu erfüllen. Das gilt auch für Verzeichnisse.

## Es gibt mehr

Durch die Angabe des Parameters `sourceselect` als 'all' wird der Inhalt aller Quellverzeichnisse kombiniert. Zum Beispiel fügen Sie `thomas admin_user` zurück in Ihre Knotendefinition in `site.pp` für Kochbuch:

Nun wieder Puppet ausführen auf dem Node cookbook:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook thomas]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413787770'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bash_profile]/content: content changed '{md5}3e8337f44f84b298a8a99869ae8ca76a' to '{md5}f939eb71a81a9da364410b799e817202'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bash_profile]/group: group changed 'root' to 'thomas'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bash_profile]/mode: mode changed '0644' to '0700'
Notice: /File[/home/thomas/.bash_profile]/seluser: seluser changed 'system_u' to 'unconfined_u'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bash_logout]/ensure: defined content as '{md5}6a5bc1cc5f80a48b540bc09d082b5855'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bashrc]/content: content changed '{md5}db2a20b2b9cdf36cca1ca4672622ddd2' to '{md5}033c3484e4b276e0641becc3aa268a3a'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bashrc]/group: group changed 'root' to 'thomas'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.bashrc]/mode: mode changed '0644' to '0700'
Notice: /File[/home/thomas/.bashrc]/seluser: seluser changed 'system_u' to 'unconfined_u'
Notice: /Stage[main]/Main/Node[cookbook]/Admin_user[thomas]/File[/home/thomas/.emacs]/ensure: defined content as '{md5}de7ee35f4058681a834a99b5d1b048b3'
Notice: Finished catalog run in 0.86 seconds
```

Weil wir das `thomas admin_user` zum Kochbuch zuvor angewendet haben, existierte der Benutzer. Die beiden im `thomas`-Verzeichnis auf dem Puppent-Server definierten Dateien waren bereits im Home-Verzeichnis, also wurden nur die zusätzlichen Dateien, `.bash_logout`, `.bash_profile` und `.emacs` angelegt. Wenn Sie diese beiden Parameter zusammen verwenden, können Sie Standarddateien haben, die einfach überschrieben werden können.

Manchmal möchten Sie Dateien in ein bestehendes Verzeichnis bereitstellen, aber alle Dateien entfernen, die nicht von Puppet verwaltet werden. Ein gutes Beispiel wäre, wenn du `mcollective` in deiner Umgebung einsetzst. Das Verzeichnis, das Client-Anmeldeinformationen besitzt, sollte nur Zertifikate haben, die von der Puppe kommen.

Der Parameter `purge` wird dies für Sie tun. Definiere das Verzeichnis als Ressource in Puppet:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
file { '/etc/mcollective/ssl/clients':
  purge   => true,
  recurse => true,
}
```

Die Kombination von `recurse` und `purge` entfernt alle Dateien und Unterverzeichnisse in `/etc/mcollective/ssl/clients`, die nicht von Puppet bereitgestellt werden. Sie können dann Ihre eigenen Dateien an diesen Speicherort bereitstellen, indem Sie sie in das entsprechende Verzeichnis auf dem Puppet-Server stellen.

Wenn es Unterverzeichnisse gibt, die Dateien enthalten, die Sie nicht löschen möchten, definieren Sie einfach das Unterverzeichnis als Puppet-Ressource, und es wird allein gelassen werden:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
file { '/etc/mcollective/ssl/clients':
  purge => true,
  recurse => true,
}
file { '/etc/mcollective/ssl/clients/local':
  ensure => directory,
}
```

### Hinweis

Seien Sie sich bewusst, dass zumindest in aktuellen Implementierungen von Puppet, rekursive Datei Kopien können ziemlich langsam und legen Sie eine schwere Speicherbelastung auf dem Server. Wenn sich die Daten nicht sehr oft ändern, könnte es besser sein, stattdessen eine `tar`-Datei einzusetzen und auszupacken. Dies kann mit einer Datei-Ressource für die `tar`-Datei und eine exec, die die Datei Ressource erfordert und entpackt das Archiv. Rekursive Verzeichnisse sind weniger ein Problem, wenn sie mit kleinen Dateien gefüllt sind. Puppe ist nicht ein sehr effizienter Dateiserver, so dass große `tar`-Dateien und die Verteilung mit Puppet ist auch keine gute Idee. Wenn Sie große Dateien kopieren müssen, mit dem Betriebssystem Packer ist eine bessere Lösung.
