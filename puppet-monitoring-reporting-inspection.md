<<<<<<< HEAD
Sie wissen wahrscheinlich, dass die Konfigurationseinstellungen von Puppet in puppet.conf gespeichert sind, aber es gibt viele Parameter, und diejenigen, die nicht in der puppet.conf aufgeführt sind, nehmen einen Standardwert an. Wie sehen Sie den Wert eines beliebigen Konfigurationsparameters, unabhängig davon, ob es explizit in puppet.conf gesetzt ist oder nicht? Die Antwort ist, den Befehl puppet config print zu verwenden.
Wie es geht...

Führen Sie den folgenden Befehl aus. Dies wird eine Menge von Ausgabe (es kann hilfreich sein, um es durch weniger, wenn Sie möchten, um die verfügbaren Konfigurationseinstellungen zu durchsuchen):
```
=======
# puppet-monitoring-reporting-inspection

Sie wissen wahrscheinlich, dass die Konfigurationseinstellungen von Puppet in puppet.conf gespeichert sind, aber es gibt viele Parameter, und diejenigen, die nicht in der puppet.conf aufgeführt sind, nehmen einen Standardwert an. Wie sehen Sie den Wert eines beliebigen Konfigurationsparameters, unabhängig davon, ob es explizit in puppet.conf gesetzt ist oder nicht? Die Antwort ist, den Befehl puppet config print zu verwenden.

## Wie es geht

Führen Sie den folgenden Befehl aus. Dies wird eine Menge von Ausgabe (es kann hilfreich sein, um es durch weniger, wenn Sie möchten, um die verfügbaren Konfigurationseinstellungen zu durchsuchen):

```d
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# puppet config print |head -25
report_serialization_format = pson
hostcsr = /var/lib/puppet/ssl/csr_cookbook.example.com.pem
filetimeout = 15
masterhttplog = /var/log/puppet/masterhttp.log
pluginsignore = .svn CVS .git
ldapclassattrs = puppetclass
certdir = /var/lib/puppet/ssl/certs
ignoreschedules = false
disable_per_environment_manifest = false
archive_files = false
hiera_config = /etc/puppet/hiera.yaml
req_bits = 4096
clientyamldir = /var/lib/puppet/client_yaml
evaltrace = false
module_working_dir = /var/lib/puppet/puppet-module
<<<<<<< HEAD
tags = 
=======
tags =
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
cacrl = /var/lib/puppet/ssl/ca/ca_crl.pem
manifest = /etc/puppet/manifests/site.pp
inventory_port = 8140
ignoreimport = false
dbuser = puppet
<<<<<<< HEAD
postrun_command = 
=======
postrun_command =
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
document_all = false
splaylimit = 1800
certificate_expire_warning = 5184000
```
<<<<<<< HEAD
### Wie es funktioniert...
=======

## Wie es funktioniert
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275

Running `puppet config print` gibt jeden Konfigurationsparameter und seinen aktuellen Wert aus (und es gibt viele davon).

Um den Wert für einen bestimmten Parameter zu sehen, füge ihn als Argument zu `puppet config print` Befehl hinzu:
<<<<<<< HEAD
```
=======

```s
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# puppet config print modulepath
/etc/puppet/modules:/usr/share/puppet/modules
```
