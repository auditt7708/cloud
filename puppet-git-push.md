Wie wir bereits im dezentralisierten Modell gesehen haben, kann Git verwendet werden, um Dateien zwischen Maschinen mit einer Kombination von `ssh` und `ssh` schlüsseln zu übertragen. Es kann auch sinnvoll sein, einen Git-Hook auf jedem erfolgreichen Commit zum Repository zu haben.

Es gibt einen hook namens Post-Commit, der nach einem erfolgreichen Commit zum Repository ausgeführt werden kann. In diesem Beispiel erstellen wir einen hook, der den Code auf unserem Puppet Master mit Code aus unserem Git Repository auf dem Git Server aktualisiert.


### Fertig werden

Gehen Sie folgendermaßen vor:

1. Erstellen Sie einen `ssh` Schlüssel, der auf Ihren Puppet-Benutzer auf Ihrem Puppet-Master zugreifen kann und installieren Sie diesen Schlüssel in das Git-Benutzerkonto auf `git.example.com`:

```
[git@git ~]$ ssh-keygen -f ~/.ssh/puppet_rsa
Generating public/private rsa key pair.
Your identification has been saved in /home/git/.ssh/puppet_rsa.
Your public key has been saved in /home/git/.ssh/puppet_rsa.pub.
Copy the public key into the authorized_keys file of the puppet user on your puppetmaster
puppet@puppet:~/.ssh$ cat puppet_rsa.pub >>authorized_keys
```

2. Ändern Sie das Puppet account, damit der Git-Benutzer sich wie folgt anmelden kann:
```
root@puppet:~# chsh puppet -s /bin/bash
```

### Wie es geht...

Führen Sie die folgenden Schritte aus:

1. Jetzt, da sich der Git-Benutzer beim Puppet-User beim Puppet-Master anmelden kann, ändern Sie die ssh-Konfiguration des Git-Benutzers, um die neu erstellte ssh-Taste standardmäßig zu verwenden: