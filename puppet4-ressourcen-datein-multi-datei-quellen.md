<<<<<<< HEAD
Eine ordentliche Funktion der Puppet `file` Ressource ist, dass Sie mehrere Werte für den `souce` parameter angeben können. Die Puppe sucht sie nacheinander. Wenn die erste Quelle nicht gefunden wird, geht sie weiter zum nächsten und so weiter. Sie können dies verwenden, um einen Standard-Ersatz anzugeben, wenn die jeweilige Datei nicht vorhanden ist, oder sogar eine Reihe von zunehmend generischen Substituten.

### Wie es geht...

Dieses Beispiel demonstriert die Verwendung mehrerer Dateirequenzen:

1. Erstellen Sie ein neues Begrüßungsmodul wie folgt:
```
=======
# puppet4-ressourcen-datein-multi-datei-quellen

Eine ordentliche Funktion der Puppet `file` Ressource ist, dass Sie mehrere Werte für den `souce` parameter angeben können. Die Puppe sucht sie nacheinander. Wenn die erste Quelle nicht gefunden wird, geht sie weiter zum nächsten und so weiter. Sie können dies verwenden, um einen Standard-Ersatz anzugeben, wenn die jeweilige Datei nicht vorhanden ist, oder sogar eine Reihe von zunehmend generischen Substituten.

## Wie es geht

Dieses Beispiel demonstriert die Verwendung mehrerer Dateirequenzen:

1.Erstellen Sie ein neues Begrüßungsmodul wie folgt:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
class greeting {
  file { '/tmp/greeting':
    source => [ 'puppet:///modules/greeting/hello.txt',
                'puppet:///modules/greeting/universal.txt'],
  }
}
```

<<<<<<< HEAD
2. Erstellen Sie die Datei `modules/greeting/files/hello.txt` mit folgendem Inhalt:

`Hello, world.`

3. Erstellen Sie die Datei `modules/greeting/files/universal.txt` mit folgendem Inhalt:
`Bah-weep-Graaaaagnah wheep ni ni bong`

4. Füge die Klasse zu einem Knoten hinzu:
```
=======
2.Erstellen Sie die Datei `modules/greeting/files/hello.txt` mit folgendem Inhalt:

`Hello, world.`

3.Erstellen Sie die Datei `modules/greeting/files/universal.txt` mit folgendem Inhalt:
`Bah-weep-Graaaaagnah wheep ni ni bong`

4.Füge die Klasse zu einem Knoten hinzu:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
node cookbook {
  class {'greeting': }
}
```

<<<<<<< HEAD
5. Puppet run:
```
=======
5.Puppet run:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413784347'
Notice: /Stage[main]/Greeting/File[/tmp/greeting]/ensure: defined content as '{md5}54098b367d2e87b078671fad4afb9dbb'
Notice: Finished catalog run in 0.43 seconds
```

<<<<<<< HEAD
6. Überprüfen Sie den Inhalt der `/tmp/greeting`:
```
[root@cookbook ~]# cat /tmp/greeting 
Hello, world.
```

7. Entfernen Sie nun die Datei `hello.txt` aus Ihrem Puppet-Repository und führen Sie den Agenten erneut aus:
```
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413784939'
Notice: /Stage[main]/Greeting/File[/tmp/greeting]/content: 
=======
6.Überprüfen Sie den Inhalt der `/tmp/greeting`:

```pp
[root@cookbook ~]# cat /tmp/greeting
Hello, world.
```

7.Entfernen Sie nun die Datei `hello.txt` aus Ihrem Puppet-Repository und führen Sie den Agenten erneut aus:

```pp
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413784939'
Notice: /Stage[main]/Greeting/File[/tmp/greeting]/content:
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
--- /tmp/greeting	2014-10-20 01:52:28.117999991 -0400
+++ /tmp/puppet-file20141020-4960-1o9g344-0	2014-10-20 02:02:20.695999979 -0400
@@ -1 +1 @@
-Hello, world.
+Bah-weep-Graaaaagnah wheep ni ni bong

Info: Computing checksum on file /tmp/greeting
Info: /Stage[main]/Greeting/File[/tmp/greeting]: Filebucketed /tmp/greeting to puppet with sum 54098b367d2e87b078671fad4afb9dbb
Notice: /Stage[main]/Greeting/File[/tmp/greeting]/content: content changed '{md5}54098b367d2e87b078671fad4afb9dbb' to '{md5}933c7f04d501b45456e830de299b5521'
Notice: Finished catalog run in 0.77 seconds
```

<<<<<<< HEAD
### Wie es funktioniert...

Auf dem ersten Puppet-Run sucht die Puppe nach den verfügbaren Dateiquellen in der angegebenen Reihenfolge:
```
=======
## Wie es funktioniert

Auf dem ersten Puppet-Run sucht die Puppe nach den verfügbaren Dateiquellen in der angegebenen Reihenfolge:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
source => [
  'puppet:///modules/greeting/hello.txt',
  'puppet:///modules/greeting/universal.txt'
],
```

Die Datei `hello.txt` ist zuerst in der Liste und ist vorhanden, also verwendet Puppet das als Quelle für `/tmp/greeting`:
`Hello, world.`

Auf dem zweiten Puppet-Lauf fehlt `hallo.txt`, also geht die Puppe nach der nächsten Datei, `universal.txt`. Dies ist vorhanden, also wird es die Quelle für `/tmp/greeting`:

`Bah-weep-Graaaaagnah wheep ni ni bong`

<<<<<<< HEAD
### Es gibt mehr...

Sie können diesen Trick überall verwenden, wo Sie eine `file` Ressource haben. Ein gemeinsames Beispiel ist ein Dienst, der auf allen Knoten, wie z.B. `rsyslog`, bereitgestellt wird. Die `rsyslog`-Konfiguration ist auf jedem Host mit Ausnahme des rsyslog-Servers identisch. Erstellen Sie eine `rsyslog`-Klasse mit einer Datei-Ressource für die `rsyslog`-Konfigurationsdatei:
```
=======
## Es gibt mehr

Sie können diesen Trick überall verwenden, wo Sie eine `file` Ressource haben. Ein gemeinsames Beispiel ist ein Dienst, der auf allen Knoten, wie z.B. `rsyslog`, bereitgestellt wird. Die `rsyslog`-Konfiguration ist auf jedem Host mit Ausnahme des rsyslog-Servers identisch. Erstellen Sie eine `rsyslog`-Klasse mit einer Datei-Ressource für die `rsyslog`-Konfigurationsdatei:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
class rsyslog {
  file { '/etc/rsyslog.conf':
    source => [
      "puppet:///modules/rsyslog/rsyslog.conf.${::hostname}",
      'puppet:///modules/rsyslog/rsyslog.conf' ],
  }
```

<<<<<<< HEAD
Dann legen Sie die Standardkonfiguration in `rsyslog.conf`. Für Ihren Rsyslog-Server, `logger`, erstellen Sie eine Datei `rsyslog.conf.logger`. Auf dem Maschinenlogger wird `rsyslog.conf.logger` vor `rsyslog.conf` verwendet, da es zuerst im Array von Quellen aufgelistet ist.
=======
Dann legen Sie die Standardkonfiguration in `rsyslog.conf`. Für Ihren Rsyslog-Server, `logger`, erstellen Sie eine Datei `rsyslog.conf.logger`. Auf dem Maschinenlogger wird `rsyslog.conf.logger` vor `rsyslog.conf` verwendet, da es zuerst im Array von Quellen aufgelistet ist.
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
