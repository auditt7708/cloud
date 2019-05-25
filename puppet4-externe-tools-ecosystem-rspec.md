Es wäre toll, wenn wir verifizieren könnten, dass unsere Marionette manifestiert, gewisse Erwartungen, ohne auch nur die Puppe laufen zu müssen. Das `rspec-puppet` Tool ist ein raffiniertes Werkzeug dazu. Auf der Basis von RSpec, einem Test-Framework für Ruby-Programme, können Sie mit `rspec-puppet` Testfälle für Ihre Puppet manifestes schreiben, die besonders nützlich sind, um Regressionen zu fangen (Fehler bei der Festsetzung eines anderen Bugs) und Refactoring-Probleme (Fehler bei der Neuordnung Ihres Codes) .

### Fertig werden

Hier ist was du brauchst, um `rspec-puppe` zu installieren.

Führen Sie die folgenden Befehle aus:
```
t@mylaptop~ $ sudo puppet resource package rspec-puppet ensure=installed provider=gem
Notice: /Package[rspec-puppet]/ensure: created
package { 'rspec-puppet':
  ensure => ['1.0.1'],
}
t@mylaptop ~ $ sudo puppet resource package puppetlabs_spec_helper ensure=installed provider=gem
Notice: /Package[puppetlabs_spec_helper]/ensure: created
package { 'puppetlabs_spec_helper':
  ensure => ['0.8.2'],
}
```

### Wie es geht...

Lassen Sie uns eine Beispielklasse, `thing` erstellen und einige Tests dafür schreiben.

1. Definiere die `thing` klasse:
```
class thing {
  service {'thing':
    ensure  => 'running',
    enable  => true,
    require => Package['thing'],
  }
  package {'thing':
    ensure => 'installed'
  }
  file {'/etc/thing.conf':
    content => 'fubar\n',
    mode    => 0644,
    require => Package['thing'],
    notify  => Service['thing'],
  }
}
```

2. Führen Sie die folgenden Befehle aus:
```
t@mylaptop ~/puppet]$cd modules/thing
t@mylaptop~/puppet/modules/thing $ rspec-puppet-init
 + spec/
 + spec/classes/
 + spec/defines/
 + spec/functions/
 + spec/hosts/
 + spec/fixtures/
 + spec/fixtures/manifests/
 + spec/fixtures/modules/
 + spec/fixtures/modules/heartbeat/
 + spec/fixtures/manifests/site.pp
 + spec/fixtures/modules/heartbeat/manifests
 + spec/fixtures/modules/heartbeat/templates
 + spec/spec_helper.rb
 + Rakefile
```

3. Erstellen Sie die Datei `spec/classes/thing_spec.rb` mit folgendem Inhalt:
```
require 'spec_helper'

describe 'thing' do
  it { should create_class('thing') }
  it { should contain_package('thing') }
  it { should contain_service('thing').with(
    'ensure' => 'running'
  ) }
  it { should contain_file('/etc/things.conf') }
end
```

4. Führen Sie die folgenden Befehle aus:
```
t@mylaptop ~/.puppet/modules/thing $ rspec
...F

Failures:

  1) thing should contain File[/etc/things.conf]
     Failure/Error: it { should contain_file('/etc/things.conf') }
       expected that the catalogue would contain File[/etc/things.conf]
     # ./spec/classes/thing_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 1.66 seconds
4 examples, 1 failure

Failed examples:

rspec ./spec/classes/thing_spec.rb:9 # thing should contain File[/etc/things.conf]
```

### Wie es funktioniert...

Der Befehl `rspec-puppet-init` erstellt einen Rahmen von Verzeichnissen für Sie, um Ihre Spezifikationen (Testprogramme) einzutragen. Im Moment interessieren wir uns nur für das `spec/classes` Verzeichnis. Hier werden Sie Ihre Klassen-Spezifikationen, eine pro Klasse, benannt nach der Klasse, die es testet, z. B. `thing_spec.rb`.

Der `spec` Code selbst beginnt mit der folgenden Anweisung, die die RSpec-Umgebung einrichtet, um die Spezifikationen auszuführen:
`require 'spec_helper'`

Dann folgt ein `describe` Block:
```
describe 'thing' do
  ..
end
```

Die `describe` identifiziert die Klasse, die wir testen (`thing`) und wickelt die Liste der Behauptungen über die Klasse in einem `do .. End` block.

Behauptungen sind unsere Erwartungen der `thing` klasse. Zum Beispiel ist die erste Behauptung die folgende:
`it { should create_class('thing') }`

Die `create_class` Assertion wird verwendet, um sicherzustellen, dass die benannte Klasse tatsächlich erstellt wird. Die nächste Zeile:
`it { should contain_package('thing') }`

Die `contain_package` Assertion bedeutet, was es sagt: Die Klasse sollte eine Paket-Ressource namens `thing` enthalten.

Als nächstes testen wir auf die Existenz des `thing` dienstes:
```
it { should contain_service('thing').with(
  'ensure' => 'running'
) }
```

Der vorhergehende Code enthält tatsächlich zwei Behauptungen. Erstens, dass die Klasse einen `thing` Service enthält:
`contain_service('thing')`

Zweitens, dass der Dienst ein `ensure` Attribut mit dem Wert `running` hat:
```
with(
  'ensure' => 'running'
)
```

Sie können alle Attribute und Werte angeben, die Sie `with` der Methode mit einer kommagetrennten Liste verwenden möchten. Beispielsweise belegt der folgende Code mehrere Attribute einer `file` ressource:

```
it { should contain_file('/tmp/hello.txt').with(
  'content' => "Hello, world\n",
  'owner'   => 'ubuntu',
  'group'   => 'ubuntu',
  'mode'    => '0644'
) }
```

In unserem `thing` Beispiel müssen wir nur testen, dass die Datei `thing.conf` vorhanden ist, mit dem folgenden Code:
`it { should contain_file('/etc/thing.conf') }`

Wenn Sie den `rake spec` Befehl ausführen, wird die `rspec-puppet` die relevanten Puppet-Klassen kompilieren, alle benötigten Spezifikationen ausführen und die Ergebnisse anzeigen:
```
...F
Failures:
  1) thing should contain File[/etc/things.conf]
     Failure/Error: it { should contain_file('/etc/things.conf') }
       expected that the catalogue would contain File[/etc/things.conf]
     # ./spec/classes/thing_spec.rb:9:in `block (2 levels) in <top (required)>'
Finished in 1.66 seconds
4 examples, 1 failure
```

Wie Sie sehen können, haben wir die Datei in unserem Test als `/etc/things.conf` definiert, aber die Datei in den Manifests ist `/etc/thing.conf`, also der Test fehlschlägt. Bearbeiten Sie thing_spec.rb und ändern Sie `/etc/things.conf` zu `/etc/thing.conf`:
`  it { should contain_file('/etc/thing.conf') }`

Jetzt rspec wieder laufen lassen:

```
t@mylaptop ~/.puppet/modules/thing $ rspec
....
Finished in 1.6 seconds
4 examples, 0 failures
```

### Es gibt mehr...

Es gibt viele Bedingungen, die Sie mit rspec überprüfen können. Jeder Ressourcentyp kann mit `contain_<resource type>` (Titel) verifiziert werden. Zusätzlich zur Überprüfung Ihrer Klassen gelten ordnungsgemäß, können Sie auch Funktionen und Definitionen testen, indem Sie die entsprechenden Unterverzeichnisse innerhalb des Spezifikationsverzeichnisses (Klassen, Definitionen oder Funktionen) verwenden.

Weitere Informationen über `rspec-puppet` finden Sie hier, einschließlich der vollständigen Dokumentation für die vorhandenen Assertionen und ein Tutorial unter http://rspec-puppet.com/.

Wenn du anfangen willst zu testen, wie dein Code auf Knoten anwendet, musst du ein anderes Werkzeug anschauen, Becher. Beaker arbeitet mit verschiedenen Virtualisierungsplattformen, um temporäre virtuelle Maschinen zu erstellen, auf die Puppencode angewendet wird. Die Ergebnisse werden dann für die Abnahmeprüfung des Puppenkodes verwendet. Diese Methode der Prüfung und Entwicklung zur gleichen Zeit ist bekannt als **Test-driven Entwicklung (TDD)**. Weitere Informationen über Becher finden Sie auf der GitHub-Website unter https://github.com/puppetlabs/beaker.