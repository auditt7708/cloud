<<<<<<< HEAD
=======
# puppet4-ressourcen-datein-aufraumen

>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
Die `tidy` Ressource von Puppet wird Ihnen helfen, alte oder veraltete Dateien aufzuräumen, wodurch der Datenträgerverbrauch reduziert wird. Wenn Sie beispielsweise das Puppet-Reporting aktiviert haben, wie es im Abschnitt zum Erstellen von Berichten beschrieben ist, sollten Sie regelmäßig alte Berichtsdateien löschen.

Wie es geht...

Lass uns anfangen.

<<<<<<< HEAD
1. Ändern Sie Ihre `site.pp` Datei wie folgt:
```
=======
1.Ändern Sie Ihre `site.pp` Datei wie folgt:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
node 'cookbook' {
  tidy { '/var/lib/puppet/reports':
    age     => '1w',
    recurse => true,
  }
}
```

<<<<<<< HEAD
3. Puppet run:
```
=======
3.Puppet run:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook clients]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201409090637.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201409100556.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201409090631.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201408210557.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201409080557.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201409100558.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201408210546.yaml]/ensure: removed
Notice: /Stage[main]/Main/Node[cookbook]/File[/var/lib/puppet/reports/cookbook.example.com/201408210539.yaml]/ensure: removed
Notice: Finished catalog run in 0.80 seconds
```

<<<<<<< HEAD
### Wie es funktioniert...
=======
## Wie es funktioniert
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275

Puppet durchsucht den angegebenen Pfad für alle Dateien, die mit dem `age` parameter übereinstimmen. In diesem Fall `2w` (zwei Wochen). Es sucht auch Unterverzeichnisse (`recurse => true`).

Alle Dateien, die Ihren Kriterien entsprechen, werden gelöscht.

<<<<<<< HEAD
#### Es gibt mehr...
=======
### Es gibt mehr
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275

Sie können Dateianlagen in Sekunden, Minuten, Stunden, Tagen oder Wochen angeben, indem Sie ein einzelnes Zeichen verwenden, um die Zeiteinheit wie folgt festzulegen:

* 60s

* 180m

* 24h

* 30d

* 4w

Sie können festlegen, dass Dateien, die größer als eine gegebene Größe sind, wie folgt entfernt werden sollten:
`size => '100m',`

<<<<<<< HEAD
Dies entfernt Dateien von 100 Megabyte und mehr. Für Kilobyte verwenden Sie `k `und für Bytes verwenden Sie `b`.

### Hinweis
=======
Dies entfernt Dateien von 100 Megabyte und mehr. Für Kilobyte verwenden Sie `k` und für Bytes verwenden Sie `b`.

## Hinweis

>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
Beachten Sie, dass, wenn Sie sowohl Alters- als auch Größenparameter angeben, sie als unabhängige Kriterien behandelt werden. Wenn Sie z. B. Folgendes angeben, wird die Puppe alle Dateien entfernen, die mindestens einen Tag alt oder mindestens 512 KB groß sind:

age => "1d",

size => "512k",
<<<<<<< HEAD

=======
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
