Manchmal können Sie nicht eine ganze Konfigurationsdatei in einem Stück bereitstellen, aber das Zeilen-Zeilen-Editieren ist nicht genug. Oft müssen Sie eine Konfigurationsdatei aus verschiedenen Bits der Konfiguration erstellen, die von verschiedenen Klassen verwaltet wird. Sie können in eine Situation laufen, in der lokale Informationen auch in die Datei importiert werden müssen. In diesem Beispiel erstellen wir eine Konfigurationsdatei mit einer lokalen Datei sowie Snippets, die in unseren Manifesten definiert sind.
Fertig werden

Obwohl es möglich ist, unser eigenes System zu erstellen, um Dateien aus Stücken zu bauen, verwenden wir das Puppetlabs unterstützte Concat-Modul. Wir beginnen mit der Installation des Concat-Moduls, in einem früheren Beispiel haben wir das Modul auf unsere lokale Maschine installiert. In diesem Beispiel ändern wir die Puppet-Server-Konfiguration und laden das Modul zum Puppet-Server herunter.

In Ihrem Git-Repository erstellen Sie eine ¸environment.conf` Datei mit folgendem Inhalt:
```
modulepath = public:modules
manifest = manifests/site.pp
```
Erstellen Sie das öffentliche Verzeichnis und laden Sie das Modul wie folgt in dieses Verzeichnis ein:
```
t@mylaptop ~/puppet $ mkdir public && cd public
t@mylaptop ~/puppet/public $ puppet module install puppetlabs-concat --modulepath=.
Notice: Preparing to install into /home/thomas/puppet/public ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/thomas/puppet/public
└─┬ puppetlabs-concat (v1.1.1)
  └── puppetlabs-stdlib (v4.3.2)
```

Fügen Sie nun die neuen Module zu unserem Git-Repository hinzu:
```
t@mylaptop ~/puppet/public $ git add .
t@mylaptop ~/puppet/public $ git commit -m "adding concat"
[production 50c6fca] adding concat
 407 files changed, 20089 insertions(+)
```
dann einen git push zum Git server:

`t@mylaptop ~/puppet/public $ git push origin production`

### Wie es geht...

Nun, da wir das `concat` Modul auf unserem Server zur Verfügung haben, können wir in unserem `base` modul eine `concat` Container-Ressource erstellen:
```
  concat {'hosts.allow':
    path => '/etc/hosts.allow',
    mode => 0644
  }
```
Erstellen Sie ein `concat::fragment` Modul für den Header der neuen Datei:
```
  concat::fragment {'hosts.allow header':
    target  => 'hosts.allow',
    content => "# File managed by puppet\n",
    order   => '01'
  }
```
Erstellen Sie ein `concat::fragment`, das eine lokale Datei enthält:
```
  concat::fragment {'hosts.allow local':
    target => 'hosts.allow',
    source => '/etc/hosts.allow.local',
    order  => '10',
  }
```

Erstellen Sie ein `concat::fragment` Modul, das an das Ende der Datei gehen wird:
```
  concat::fragment {'hosts.allow tftp':
    target  => 'hosts.allow',
    content => "in.ftpd: .example.com\n",
    order   => '50',
  }
```

On the node, create /etc/hosts.allow.local with the following contents:
`  in.tftpd: .example.com`

Führen Sie die Puppe aus, um die Datei zu erstellen:
```
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1412138600'
Notice: /Stage[main]/Base/Concat[hosts.allow]/File[hosts.allow]/ensure: defined content as '{md5}b151c8bbc32c505f1c4a98b487f7d249'
Notice: Finished catalog run in 0.29 seconds
```

Überprüfen Sie den Inhalt der neuen Datei als:
```
[root@cookbook ~]# cat /etc/hosts.allow
# File managed by puppet
in.tftpd: .example.com
in.ftpd: .example.comc
```

### Wie es funktioniert...

Die `concat` Ressource definiert einen Container, der alle nachfolgenden `concat::fragment` Ressourcen enthält. Jede `concat::fragment` Ressource verweist auf die Concat-Ressource als Ziel. Jedes `concat:: fragment` enthält auch ein `order` attribut. Das `order` attribut wird verwendet, um die Reihenfolge anzugeben, in der die Fragmente der endgültigen Datei hinzugefügt werden. Unsere `/etc/hosts.allow` Datei wird mit der Kopfzeile, dem Inhalt der lokalen Datei und schließlich der `in.tftpd` Zeile, die wir definiert haben, gebaut.