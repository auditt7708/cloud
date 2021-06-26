---
title: puppet4-ressourcen-datein-host
description: 
published: true
date: 2021-06-09T16:00:32.335Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:00:26.870Z
---

# puppet4-ressourcen-datein-host

Es ist nicht immer praktisch, DNS zu verwenden, um Ihre Maschinennamen auf IP-Adressen zuzuordnen, vor allem in Cloud-Infrastrukturen, wo sich diese Adressen jederzeit ändern können. Wenn Sie jedoch stattdessen Einträge in der Datei `/etc/hosts` verwenden, haben Sie dann das Problem, diese Einträge auf alle Rechner zu verteilen und auf dem Laufenden zu halten.

Hier gibt es ein besseren Weg, es umzusetzen; Der Puppet `host` Ressourcentyp  steuert einen einzelnen `/etc/hosts`-Eintrag, und Sie können dies verwenden, um einen Hostnamen einer IP-Adresse leicht über Ihr ganzes Netzwerk zuzuordnen.
Zum Beispiel, wenn alle Ihre Maschinen die Adresse des Haupt-Datenbank-Servers kennen müssen, können Sie es mit einer `host`-Ressource verwalten.

## Wie es geht

Gehen Sie folgendermaßen vor, um eine Beispiel- `host` Ressource zu erstellen:

1.Ändern Sie Ihre `site.pp` Datei wie folgt:

```pp
node 'cookbook' {
  host { 'packtpub.com':
    ensure => present,
    ip     => '83.166.169.231',
  }
}
```

2.Puppet run:

```pp
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413781153'
Notice: /Stage[main]/Main/Node[cookbook]/Host[packtpub.com]/ensure: created
Info: Computing checksum on file /etc/hosts
Notice: Finished catalog run in 0.12 seconds
```

## Wie es funktioniert

Puppet überprüft die Zieldatei (normalerweise `/etc/hosts`), um zu sehen, ob der Host-Eintrag bereits existiert und wenn nicht, fügen Puppet ihn hinzu.
Wenn ein Eintrag für diesen Hostnamen bereits mit einer anderen Adresse existiert, ändert Puppet die Adresse, um dem Manifest zu entsprechen.

## Es gibt mehr

Die Organisation Ihrer Host-Ressourcen in Klassen kann hilfreich sein. Zum Beispiel könnten Sie die Host-Ressourcen für alle Ihre DB-Server in eine Klasse namens `admin::dbhosts` ablegen, die von allen Web-Servern enthalten ist.

Wo Maschinen in mehreren Klassen definiert werden müssen (zB ein Datenbankserver könnte auch ein Repository-Server sein), können virtuelle Ressourcen dieses Problem lösen. Zum Beispiel könnten Sie alle Ihre Hosts als  in einer einzigen virtuell Klasse definieren:

```pp
class admin::allhosts {
  @host { 'db1.packtpub.com':
    tag => 'database'
    ...
  }
}
```

Sie konnten dann die hosts erkennen, die Sie in den verschiedenen Klassen benötigen:

```pp
class admin::dbhosts {
  Host <| tag=='database' |>
}

class admin::webhosts {
  Host <| tag=='web' |>
}
```
