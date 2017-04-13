Manchmal ein Puppet Klasse muss über einen anderen kennen oder zumindest zu wissen, ob es vorhanden ist. Zum Beispiel kann eine Klasse, die die Firewall verwaltet müssen wissen, ob der Knoten ein Web-Server ist.

Marionette tagged Funktion werden Ihnen sagen , ob eine benannte Klasse oder Ressource für diesen Knoten im Katalog vorhanden ist. Sie können auch beliebige Tags zu einem Knoten oder Klasse und prüfen , ob das Vorhandensein dieser Tags anwenden. Tags sind eine weitere metaparameter ähnlich requireund notifywir eingeführt in Kapitel 1 , Puppet Sprache und Stil . Metaparameters werden bei der Erstellung des Puppet Katalog verwendet , sind aber kein Attribut der Ressource , an die sie gebunden sind.

## Wie es geht...

Um Ihnen zu helfen herauszufinden , ob Sie auf einem bestimmten Knoten oder eine Klasse von Knoten alle Knoten ausgeführt werden automatisch mit dem Knotennamen markiert und die Namen der Klassen , die sie enthalten. Hier ist ein Beispiel , das zeigt, wie Sie nutzen taggeddiese Informationen zu erhalten:

Fügen Sie den folgenden Code in Ihre site.ppDatei (ersetzt cookbookmit Ihrem Gerät hostname):
```
  node 'Kochbuch' {
    wenn markiert ( ‚Kochbuch‘) {
      benachrichtigen { ‚getaggt Kochbuch‘:}
    }
  }

```
Run Puppet:

```
root @ Kochbuch: ~ # Puppenmittel -vt
Info: Caching-Katalog für Kochbuch
Info: Anwenden von Konfigurationsversion ‚1410848350‘
Hinweis: getaggt Kochbuch
Hinweis: Fertig Katalog Lauf in 1,00 Sekunden

```

Die Knoten sind auch automatisch mit den Namen aller Klassen , die sie zusätzlich zu mehreren anderen automatischen Tags enthalten markiert. Sie können verwendet werden, taggedum herauszufinden , welche Klassen auf dem Knoten enthalten sind.

Sie sind nicht nur darauf beschränkt , die Tags automatisch angewendet von Puppet zu überprüfen. Sie können auch Ihre eigenen hinzufügen. Auf einen beliebigen Tag auf einem Knoten gesetzt ist , verwenden , um die tagFunktion, wie im folgenden Beispiel:

Ändern Sie bitte Ihre site.pp Datei wie folgt:

```
  node 'Kochbuch' {
    -Tag ( 'Tagging')
    Klasse { 'tag_test':}
  }

```
Fügen Sie ein tag_testModul mit der folgenden init.pp(oder faul sein und fügen Sie die folgende Definition zu Ihrem site.pp):

```
  Klasse tag_test {
    wenn markiert ( 'Tagging') {
      benachrichtigen { 'enthält, node / Klasse markiert wurde.':}
    }
  }

```
Run Puppet:


```
root @ Kochbuch: ~ # Puppenmittel -vt
Info: Caching-Katalog für Kochbuch
Info: Anwenden von Konfigurationsversion ‚1410851300‘
Hinweis: enthält Knoten / Klasse markiert wurde.
Hinweis: Fertig Katalog Lauf in 0,22 Sekunden

```
Sie können auch Tags verwenden , um zu bestimmen , welche Teile des Manifests anzuwenden. Wenn Sie die Verwendung --tagsOption auf der Puppet - Befehlszeile wird Puppet gilt nur jene Klassen oder mit den spezifischen Tags versehen Ressourcen , die Sie enthalten. Zum Beispiel können wir unsere definieren cookbookKlasse mit zwei Klassen:

```
  Knoten Kochbuch {
    Klasse { 'first_class':}
    Klasse { 'second_class':}
  }
  Klasse first_class {
    benachrichtigen { 'First Class':}
  }
  Klasse second_class {
    benachrichtigen { ‚zweite Klasse‘:}
  }

```
Nun , wenn wir laufen puppet agentauf dem cookbookKnoten, sehen wir beide teilen:

```
root @ Kochbuch: ~ # Puppenmittel -t
Hinweis: Zweite Klasse
Hinweis: First Class
Hinweis: Fertig Katalog Lauf in 0,22 Sekunden
jetzt bewerbendie first_classund add --tagsFunktion zu der Befehlszeile:

root @ Kochbuch: ~ # Puppenmittel -t --tags first_class
Hinweis: First Class
Hinweis: Fertig Katalog Lauf in 0,07 Sekunden

```
### Es gibt mehr…

Sie können Tags verwenden, um eine Sammlung von Ressourcen zu erstellen und dann die Sammlung für eine andere Ressource eine Abhängigkeit machen. Zum Beispiel, sagen einiger Dienst auf einer Konfigurationsdatei ab, die von einer Anzahl von Datei-Schnipsel gebaut wird, wie im folgende Beispiel:

```
  Klasse Firewall :: service {
    service { 'firewall': ... 
    }
    Datei <| Tag == 'Firewall-Schnipsel' |> ~> Service [ 'Firewall']
  }
  Klasse myapp { 
    Datei { '/etc/firewall.d/myapp.conf': tag => 'Firewall-Schnipsel', ... 
    } 
  }

```

Hier haben wir festgelegt , dass der firewallDienst benachrichtigt werden soll , wenn eine Datei Ressource markiert firewall-snippetaktualisiert wird. Alles , was wir tun müssen , einen hinzuzufügen firewallConfig - Schnipsel für eine bestimmte Anwendung oder ein Dienst ist es zu markieren firewall-snippet, und Puppet erledigt den Rest.

Obwohl wir konnten eine Add - notify => Service["firewall"]Funktion zu jedem Schnipsel Ressource , wenn unsere Definition des firewallService überhaupt zu ändern, würden wir die Schnipsel nach unten und entsprechend aktualisieren alle jagen müssen. Der Tag läßt uns die Logik in einem Ort kapseln, die zukünftige Wartung zu machen und Refactoring viel einfacher.

### Hinweis
Was ist <| tag == 'firewall-snippet' |> syntax? Dies ist eine Ressource Sammler genannt, und es isteine Möglichkeit , eine Gruppe von Ressourcen zu spezifizieren , indem für einige Stück von Daten über sie suchen; in diesem Fall wird der Wert einer Variablen. Sie können mehr über Ressourcensammler finden und den <| |>Operator (manchmal als das Raumschiff Operator bekannt) auf dem Puppet LabsWebseite: http://docs.puppetlabs.com/puppet/3/reference/lang_collectors.html .