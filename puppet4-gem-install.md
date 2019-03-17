# Puppet4 Instaliren mit hilfe von [rubygems](../rubygems)

Voraussetzung zur Installation von [rubygems](../rubygems)

CentOS

`sudo yum install ruby rubygems`

Ubuntu uns Debian

`sudo apt-get install rubygems`

anach kann mit

`sudo gem install puppet`

[Puppet](../puppet) Installiert werden.

Zum testen ob alles geht einfach eine Datei erstellen

```sh
#!/usr/bin/env ruby
puts "Hallo Welt!"

```

wenn es `Hallo Welt!` ist bis hier hin alles ok.

Testweise installiert man einfach noch
`sudo gem install sinatra`

Und testet den Ruby minimal Server mit einer Datei

```sh
#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

get '/hi' do
  "Hello World!"
end

```

Wird das Skript ausgeführt, so startet ein lokaler HTTP-Server. Unter http://localhost:4567/hi kann die entsprechende Seite abgerufen werden.

Wenn also eine Ausgabe erscheint ist alles Ok.