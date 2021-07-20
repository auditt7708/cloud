---
title: puppet4-gem-install
description: 
published: true
date: 2021-06-09T15:59:13.557Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:59:08.199Z
---

# Puppet4 Instaliren mit hilfe von [rubygems](../puppet/rubygems)

Voraussetzung zur Installation von [rubygems](../puppet/rubygems)

CentOS

`sudo yum install ruby rubygems`

Ubuntu uns Debian

`sudo apt-get install rubygems`

anach kann mit

`sudo gem install puppet`

[Puppet](../puppet/puppet) Installiert werden.

Zum testen ob alles geht einfach eine Datei erstellen

```sh
../puppet/u../puppet/b../puppet/env ruby
puts "Hallo Welt!"

```

wenn es `Hallo Welt!` ist bis hier hin alles ok.

Testweise installiert man einfach noch
`sudo gem install sinatra`

Und testet den Ruby minimal Server mit einer Datei

```sh
../puppet/u../puppet/b../puppet/env ruby
require 'rubygems'
require 'sinatra'

get../puppet/hi' do
  "Hello World!"
end

```

Wird das Skript ausgeführt, so startet ein lokaler HTTP-Server. Unter htt../puppet//localhost:45../puppet/hi kann die entsprechende Seite abgerufen werden.

Wenn also eine Ausgabe erscheint ist alles Ok.