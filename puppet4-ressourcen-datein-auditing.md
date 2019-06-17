# puppet4-ressourcen-datein-auditing

Trockenlauf-Modus, mit dem `--noop` Schalter, ist eine einfache Möglichkeit, um alle Änderungen an einer Maschine unter Puppet's Kontrolle zu überprüfen. Allerdings hat Puppet auch eine eigene Audit-Funktion, die Änderungen an Ressourcen oder spezifischen Attributen melden kann.

## Wie es geht

Hier ist ein Beispiel für die Auditing-Fähigkeiten von Puppet:

1.Ändern Sie Ihre `site.pp` Datei wie folgt:

```pp
node 'cookbook' {
  file { '/etc/passwd':
    audit => [ owner, mode ],
  }
}
```

2.Puppet run:

```s
[root@cookbook clients]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413789080'
Notice: /Stage[main]/Main/Node[cookbook]/File[/etc/passwd]/owner: audit change: newly-recorded value 0
Notice: /Stage[main]/Main/Node[cookbook]/File[/etc/passwd]/mode: audit change: newly-recorded value 644
Notice: Finished catalog run in 0.55 seconds
```

## Wie es funktioniert

Der `audit` Metaparameter sagt der Puppe, dass Sie bestimmte Dinge über die Ressource aufnehmen und überwachen möchten. Der Wert kann eine Liste der Parameter sein, die Sie auditieren möchten.

In diesem Fall, wenn Puppet läuft, wird es nun den Besitzer und den Modus der Datei `/etc/passwd` aufzeichnen. In zukünftigen Läufen wird die Puppe vorstellen, ob sich diese von ihnen geändert haben. Zum Beispiel, wenn Sie laufen:

`[root@cookbook ~]# chmod 666 /etc/passwd`

Puppet wird diese Änderung abholen und beim nächsten Lauf anmelden:

`Notice: /Stage[main]/Main/Node[cookbook]/File[/etc/passwd]/mode: audit change: previously recorded value 0644 has been changed to 0666`

## Es gibt mehr

Diese Funktion ist sehr nützlich, um große Netzwerke für alle Änderungen an Maschinen zu prüfen, entweder böswillig oder zufällig. Es ist auch sehr praktisch, Dinge im Auge zu behalten, die nicht von Puppet verwaltet werden, zum Beispiel Anwendungscode auf Produktionsservern. Hier erfahren Sie mehr über die [Auditing-Funktion](Http://puppetlabs.com/blog/all-about-auditing-with-puppet/) von Puppet:

Wenn Sie nur alles über eine Ressource auditieren wollen, verwenden Sie `alle`:

```pp
file { '/etc/passwd':
  audit => all,
}
```

Siehe auch

* [Puppet4 Monitoring, Reporting und Fehlersuche](../puppet-monitorin-reporting-fehlersuche)
