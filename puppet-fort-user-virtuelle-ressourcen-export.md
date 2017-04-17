Alle unseren Rezepten bis zu diesem Punkt hat sich um eine einzelne maschine gehandelt. Es ist möglich mit Puppet, Ressourcen von einem Nodes zu haben, die einen anderen Node beeinflussen. Diese Interaktion wird mit exportierten Ressourcen verwaltet. Exportierte Ressourcen sind genau wie jede Ressource, die Sie für einen Knoten definieren könnten, aber anstatt auf den Knoten zu klicken, auf dem sie erstellt wurden, werden sie für die Verwendung von allen Knoten in der Umgebung exportiert. Ausgeführte Ressourcen können als virtuelle Ressourcen betrachtet werden, die einen Schritt weiter gehen und über den Knoten hinausgehen, auf dem sie definiert wurden.

Es gibt zwei Aktionen mit exportierten Ressourcen. Wenn eine exportierte Ressource erstellt wird, soll sie definiert werden. Wenn alle exportierten Ressourcen geerntet werden, sollen sie gesammelt werden. Das Definieren von exportierten Ressourcen ähnelt virtuellen Ressourcen; Die Ressource in Frage hat zwei @ Symbole vorangestellt. Um beispielsweise eine Datei-Ressource als extern zu definieren, verwenden Sie @@-Datei. Das Sammeln von Ressourcen erfolgt mit dem Raumschiff-Betreiber, << | | >>; Das wird gedacht, wie ein Raumschiff auszusehen. Um die exportierte Datei Ressource (@ @ Datei) zu sammeln, würden Sie Datei << | verwenden | >>

Es gibt viele Beispiele, die exportierte Ressourcen verwenden. Die häufigste beinhaltet SSH-Host-Schlüssel. Mit exportierten Ressourcen ist es möglich, dass jede Maschine, auf der Puppet ausgeführt wird, ihre SSH-Host-Schlüssel mit den anderen verbundenen Knoten teilen. Die Idee hier ist, dass jede Maschine einen eigenen Hostschlüssel exportiert und dann alle Schlüssel von den anderen Maschinen sammelt. In unserem Beispiel erstellen wir zwei Klassen; Zuerst eine Klasse, die den SSH-Hostschlüssel von jedem Knoten aus exportiert. Wir werden diese Klasse in unsere Basisklasse aufnehmen. Die zweite Klasse wird eine Sammlerklasse sein, die die SSH-Host-Tasten sammelt. Wir werden diese Klasse auf unsere Jumpboxes oder SSH Login Server anwenden.


### Hinweis:
Jumpboxen sind Maschinen, die spezielle Firewall-Regeln haben, damit sie sich an verschiedenen Standorten anmelden können.

### Fertig werden

Um exportierte Ressourcen zu verwenden, musst du Storeconfigs auf deinen Puppet-Mastern aktivieren. Es ist möglich, exportierte Ressourcen mit einer masterless (dezentralen) Bereitstellung zu verwenden. Wir gehen jedoch davon aus, dass Sie für dieses Beispiel ein zentrales Modell verwenden. In Kapitel 2, Puppet Infrastructure, haben wir puppetdb mit dem puppetdb Modul aus der Schmiede konfiguriert. Es ist möglich, andere Backends zu benutzen, wenn Sie es wünschen; Aber alle diese außer puppetdb sind veraltet. Weitere Informationen finden Sie unter folgendem Link: http://projects.puppetlabs.com/projects/puppet/wiki/Using_Stored_Configuration.

Stellen Sie sicher, dass Ihre Puppet-Master so konfiguriert sind, dass sie puppetdb als storeconfigs-Container verwenden.
Wie es geht...

Wir erstellen eine ssh_host-Klasse, um die ssh-Schlüssel eines Hosts zu exportieren und sicherzustellen, dass es in unserer Basisklasse enthalten ist.

1. Erstellen Sie die erste Klasse, `base::ssh_host`, die wir in unsere Basisklasse aufnehmen werden:
```
class base::ssh_host {
  @@sshkey{"$::fqdn":
    ensure       => 'present',
    host_aliases => ["$::hostname","$::ipaddress"],
    key          => $::sshdsakey,
    type         => 'dsa',
  }
}
```

2. Denken Sie daran, diese Klasse aus der Basisklassendefinition aufzunehmen:
```
class base {
  ...
  include ssh_host
}
```

3. Erstellen Sie eine Definition für `Jumpbox`, entweder in einer Klasse oder innerhalb der Node definition für `Jumpbox`:
```
node 'jumpbox' {
  Sshkey <<| |>>
}
```
4. Führen Sie nun Puppet auf ein paar Knoten, um die exportierten Ressourcen zu erstellen. In meinem Fall lief ich Puppet auf meinem Puppet-Server und meinem zweiten Beispielknoten (`node2`). Schließlich laufe Puppet auf `jumpbox`, um zu überprüfen, dass die SSH-Host-Tasten für unsere anderen Knoten gesammelt werden:
```
[root@jumpbox ~]# puppet agent -t 
Info: Caching catalog for jumpbox.example.com
Info: Applying configuration version '1413176635'
Notice: /Stage[main]/Main/Node[jumpbox]/Sshkey[node2.example.com]/ensure: created
Notice: /Stage[main]/Main/Node[jumpbox]/Sshkey[puppet]/ensure: created
Notice: Finished catalog run in 0.08 seconds
```

#### Wie es funktioniert...

Wir haben eine `sshkey` Ressource für den Knoten mit den facter facts `fqdn`, `hostname`, `ipaddress` und `sshdsakey` erstellt. Wir verwenden den `fqdn` als den Titel für unsere exportierte Ressource, da jede exportierte Ressource einen eindeutigen Namen haben muss. Wir können davon ausgehen, dass der Knoten eines Knotens in unserer Organisation einzigartig sein wird (obwohl es manchmal auch nicht der Fall ist, dass die Puppe gut sein kann, wenn man es am wenigsten erwartet). Wir definieren dann Aliase, mit denen unser Knoten bekannt sein kann. Wir verwenden die Hostname-Variable für einen Alias ​​und die Haupt-IP-Adresse der Maschine als die andere. Wenn du andere Namenskonventionen für deine Knoten hättest, könntest du hier auch andere Aliase anschließen. Wir gehen davon aus, dass Hosts DSA-Schlüssel verwenden, also verwenden wir die Variable sshdsakey in unserer Definition. In einer großen Installation würden Sie diese Definition in Tests verpacken, um sicherzustellen, dass die DSA-Schlüssel existierten. Sie würden auch die RSA-Tasten verwenden, wenn sie auch existierten.

Mit der `sshkey` Ressource definiert und exportiert, haben wir dann eine `Jumpbox` Knotendefinition erstellt. In dieser Definition haben wir die Raumschiff-Syntax verwendet `Sshkey << | | >>`, um alle definierten exportierten `sshkey` Ressourcen zu sammeln.

### Es gibt mehr...

Wenn Sie die exportierten Ressourcen definieren, können Sie der Ressource Tag-Attribute hinzufügen, um Untermengen von exportierten Ressourcen zu erstellen. Wenn Sie zum Beispiel einen Entwicklungs- und Produktionsbereich Ihres Netzwerks hatten, können Sie für jeden Bereich verschiedene Gruppen von sshkey-Ressourcen erstellen, wie im folgenden Code-Snippet gezeigt:
```
@@sshkey{"$::fqdn":
    host_aliases => ["$::hostname","$::ipaddress"],
    key          => $::sshdsakey,
    type         => 'dsa',
    tag          => "$::environment",
  }
```

Sie können dann `jumpbox` ändern, um nur Ressourcen für die Produktion zu sammeln, zum Beispiel wie folgt:
`Sshkey <<| tag == 'production' |>>`

Zwei wichtige Dinge zu erinnern, wenn die Arbeit mit exportierten Ressourcen: Erstens muss jede Ressource einen eindeutigen Namen über Ihre Installation haben. Mit dem `fqdn` Domain-Namen innerhalb des Titels ist in der Regel genug, um Ihre Definitionen einzigartig zu halten. Zweitens kann jede Ressource virtuell gemacht werden. Auch definierte Typen, die Sie erstellt haben, können exportiert werden. Ausgeführte Ressourcen können verwendet werden, um einige ziemlich komplexe Konfigurationen zu erreichen, die sich automatisch anpassen, wenn Maschinen sich ändern.

### Hinweis:
Ein Wort der Vorsicht bei der Arbeit mit einer extrem großen Anzahl von Knoten (mehr als 5.000) ist, dass exportierte Ressourcen können eine lange Zeit zu sammeln und gelten, vor allem, wenn jede exportierte Ressource erstellt eine Datei.