Ein sinnvoller Ansatz für die Zugriffskontrolle für Server ist die Verwendung von Benutzerkonten mit passphrasegeschützten SSH-Schlüsseln, anstatt Benutzer ein Konto mit einem weithin bekannten Passwort zu teilen. Puppet macht das dank des eingebauten ssh_authorized_key Typs einfach zu verwalten.

Um dies mit virtuellen Benutzern zu kombinieren, wie im vorherigen Abschnitt beschrieben, können Sie eine Definition erstellen, die sowohl die Benutzer- als auch die Ressourcen ssh_authorized_key enthält. Dies wird auch praktisch sein, wenn Sie Anpassungsdateien und andere Ressourcen für jeden Benutzer hinzufügen.

### Wie es geht...

Gehen Sie folgendermaßen vor, um die Klasse Ihrer virtuellen Benutzer auf den SSH-Zugriff zu erweitern:

1. Erstellen Sie ein neues Modul ssh_user, um unsere ssh_user Definition zu enthalten. Erstellen Sie die Module / ssh_user / manifests / init.pp Datei wie folgt:

```
define ssh_user($key,$keytype) {
  user { $name:
    ensure     => present,
  }

  file { "/home/${name}":
    ensure => directory,
    mode   => '0700',
    owner  => $name,
    require => User["$name"]
  }
  file { "/home/${name}/.ssh":
    ensure => directory,
    mode   => '0700',
    owner  => "$name",
    require => File["/home/${name}"],
  }

  ssh_authorized_key { "${name}_key":
    key     => $key,
    type    => "$keytype",
    user    => $name,
    require => File["/home/${name}/.ssh"],
  }
}
```

2. Ändern Sie Ihre Module / user / manifests / virtual.pp Datei, kommentieren Sie die vorherige Definition für Benutzer thomas, und ersetzen Sie sie mit den folgenden:

```
@ssh_user { 'thomas':
  key     => 'AAAAB3NzaC1yc2E...XaWM5sX0z',
  keytype => 'ssh-rsa'
}
```

3. Ändern Sie Ihre `modules/user/manifests/sysadmins.pp` Datei wie folgt:

```
class user::sysadmins {
    realize(Ssh_user['thomas'])
}
``

4. Ändern Sie Ihre `site.pp` Datei wie folgt:

```
node 'cookbook' {
  include user::virtual
  include user::sysadmins
}
```

5. Puppet run:

```
cookbook# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413254461'
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/File[/home/thomas/.ssh]/ensure: created
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/Ssh_authorized_key[thomas_key]/ensure: created
Notice: Finished catalog run in 0.11 seconds
```

### Wie es funktioniert...

Für jeden Benutzer in unserem `user::virtual` Klasse müssen wir erstellen:

* Das Benutzerkonto selbst

* Das Home-Verzeichnis des Benutzers und das .ssh-Verzeichnis

* Die Datei .ssh / authorized_keys des Benutzers

Wir könnten getrennte Ressourcen deklarieren, um alle diese für jeden Benutzer zu implementieren, aber es ist viel einfacher, stattdessen eine Definition zu erstellen, die sie in eine einzige Ressource verpackt. Durch die Erstellung eines neuen Moduls für unsere Definition können wir von jedem beliebigen Ort (in jedem Bereich) auf ssh_user verweisen:

```
define ssh_user ($key, $keytype) { 
  user { $name:
    ensure     => present,
  }
```

Nachdem wir den Benutzer erstellt haben, können wir dann das Home-Verzeichnis erstellen. Wir brauchen den Benutzer zuerst, so dass, wenn wir sein Heimverzeichnisse zuweisen, können wir den Benutzernamen, `owner => $ name` verwenden:

```
  file { "/home/${name}":
    ensure => directory,
    mode => '0700',
    owner => $name,
    require => User["$name"]
  }
```

### Tip
Puppet kann das Home-Verzeichnis der Benutzer mit dem `managehome` Attribut zur Benutzerressource erstellen. Das Verlassen auf diesen Mechanismus ist in der Praxis problematisch, da es nicht für Benutzer verantwortlich ist, die außerhalb von Puppet ohne Heimverzeichnisse erstellt wurden.

Als nächstes müssen wir sicherstellen, dass das `.ssh` Verzeichnis im Home-Verzeichnis des Benutzers existiert. Wir benötigen das Home-Verzeichnis, `File["/home/${name}"]`, da muss es existieren, bevor wir dieses Unterverzeichnis erstellen. Dies bedeutet, dass der Benutzer bereits existiert, weil das Home-Verzeichnis den Benutzer benötigt hat:

```
  file { "/home/${name}/.ssh":
    ensure => directory,
    mode   => '0700',
    owner  => $name ,
    require => File["/home/${name}"],
  }
```

Schließlich erstellen wir die Ressource `ssh_authorized_key`, die wiederum den enthaltenen Ordner benötigt (`File["/home/${name}/.ssh"]`). Wir verwenden die Variablen `$key` und `$keytype`, um den Schlüssel und Typ dem Parameter `ssh_authorized_key` Typ zuzuordnen, wie folgt:

```
  ssh_authorized_key { "${name}_key":
    key     => $key,
    type    => "$keytype",
    user    => $name,
    require => File["/home/${name}/.ssh"],
  }
}
```

Wir haben die `$key` und `$keytype` Variablen übergeben, als wir die `ssh_user` Ressource für thomas definiert haben:

```
@ssh_user { 'thomas':
  key => 'AAAAB3NzaC1yc2E...XaWM5sX0z',
  keytype => 'ssh-rsa'
}
```

### Tip
Der Wert für `key`, im vorherigen Code-Snippet, ist der öffentliche Schlüssel des ssh-Schlüssels; Es wird normalerweise in einer id_rsa.pub Datei gespeichert.

Nun, mit allem definirungen, müssen wir nur `realize` nutzen , um `thomas` für all diese Ressourcen zu umzusetzen

`realize(Ssh_user['thomas'])`

Beachten Sie, dass diesmal die virtuelle Ressource, die wir realisieren, nicht einfach die `user` ressource ist, wie zuvor, sondern der `ssh_user` definierte Typ, den wir erstellt haben, der den Benutzer und die dazu erforderlichen Ressourcen enthält, um den SSH-Zugriff einzurichten:

```
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/User[thomas]/ensure: created
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/File[/home/thomas]/ensure: created
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/File[/home/thomas/.ssh]/ensure: created
Notice: /Stage[main]/User::Virtual/Ssh_user[thomas]/Ssh_authorized_key[thomas_key]/ensure: created
```

### Es gibt mehr...

Natürlich können Sie alle Ressourcen hinzufügen, die Sie der `ssh_user` Definition benötigen, damit Puppet sie automatisch für neue Benutzer erstellt. Wir sehen ein Beispiel dafür im nächsten Rezept, [Verwalten der Benutzeranpassungsdateien](../puppet-fort-user-virtuelle-ressourcen-benutzer-anpassen).