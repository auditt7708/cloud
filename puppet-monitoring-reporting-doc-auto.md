
Da Ihre Manifeste größer und komplexer werden, kann es hilfreich sein, HTML-Dokumentation für Ihre Knoten und Klassen zu erstellen, indem Sie das automatische `puppet doc` Puppet verwenden.

### Wie es geht...

Gehen Sie folgendermaßen vor, um HTML-Dokumentation für Ihr Manifest zu generieren:

1. Führen Sie den folgenden Befehl aus:
`t@mylaptop ~/puppet $ puppet doc --all --outputdir=/tmp/puppet --mode rdoc --modulepath=modules/`

2. Dies erzeugt einen Satz von HTML-Dateien an `/tmp/puppet`. Öffnen Sie die oberste `index.html` Datei mit Ihrem Webbrowser (`file: ///tmp/puppet/index.html`) und Sie sehen so etwas wie den folgenden Screenshot:

![rdoc1](https://www.packtpub.com/graphics/9781788297615/graphics/B03643_10_01.jpg)

3. Klicken Sie auf den Klassen link auf der linken Seite und wählen Sie das Apache-Modul aus. Ähnliches wie folgt wird angezeigt:
![rdoc2](https://www.packtpub.com/graphics/9781788297615/graphics/B03643_10_02.jpg)

### Wie es funktioniert...

Der `puppet doc` Befehl erstellt einen strukturierten HTML-Dokumentationsbaum ähnlich dem, der von **RDoc**, dem beliebten Ruby-Dokumentationsgenerator, erzeugt wird. Dies macht es leichter zu verstehen, wie sich verschiedene Teile des Manifests aufeinander beziehen.

### Es gibt mehr...

Der Befehl `puppet doc` erzeugt eine grundlegende Dokumentation Ihrer Manifeste, während sie stehen, aber Sie können nützliche Informationen einfügen, indem Sie Kommentare zu Ihren Manifestdateien hinzufügen, indem Sie die Standard-RDoc-Syntax verwenden. Als wir unsere Basisklasse mit Puppenmodul erstellt haben, wurden diese Kommentare für uns erstellt:

```
# == Class: base
#
# Full description of class base here.
#
# === Parameters
#
# Document parameters here. #
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { base:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class base {
```
Nach der Erstellung der HTML-Dokumentation sehen wir das Ergebnis für das Basismodul wie im folgenden Screenshot gezeigt:
![rdoc3](https://www.packtpub.com/graphics/9781788297615/graphics/B03643_10_03.jpg)