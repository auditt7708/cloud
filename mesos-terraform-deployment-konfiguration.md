Terraform ist ein Infrastrukturgebäude, ein Wechsel- und Versionierungswerkzeug, um die vorhandenen beliebten Dienste sowie kundenspezifische Inhouse-Lösungen sicher und effizient zu behandeln, die im Besitz von HashiCorp sind und in Go-Sprache geschrieben sind. In diesem Modul werden wir zunächst diskutieren, wie wir Terraform installieren können, und dann werden wir überlegen, wie wir Terraform nutzen können, um einen Mesos-Cluster zu drehen.



\#\#\# Terraform installieren





Gehen Sie zu https:\/\/www.terraform.io\/downloads.html, laden Sie die entsprechende Version für Ihre Plattform herunter und entpacken Sie es wie folgt: 

```

```

Sie werden feststellen, dass das Terraform-Archiv ein Bündel von Binärdateien ist, sobald Sie sie entpacken, was wie folgt aussieht: 

!\[terrform-tools\]\(https:\/\/www.packtpub.com\/graphics\/9781785886249\/graphics\/B05186\_05\_04.jpg\)

Fügen Sie nun den Pfad zum Verzeichnis in der Variable PATH hinzu, damit Sie auf den Terraform-Befehl aus jedem Verzeichnis zugreifen können.



Wenn alles gut geht, dann können Sie die Verwendung von Terraform sehen, sobald Sie den Terraform-Befehl im Terminal ausführen: 

!\[terrform-hilfe\]\(https:\/\/www.packtpub.com\/graphics\/9781785886249\/graphics\/B05186\_05\_05.jpg\)



### Spinnen eines Mesos-Clusters mit Terraform auf Google Cloud



Um einen Mesos-Cluster in Google Cloud Engine \(GCE\) mit Terraform zu drehen, musst du eine JSON-Schlüsseldatei zur Authentifizierung haben. Gehen Sie zu https:\/\/console.developers.google.com und generieren Sie dann einen neuen JSON-Schlüssel, indem Sie zu den Credentials \| navigieren Dienstkonto. Eine Datei wird dann heruntergeladen, die später benötigt wird, um Maschinen zu starten.



Wir können nun eine Terraform-Konfigurationsdatei für unseren Mesos-Cluster erstellen. Erstellen Sie eine mesos.tf-Datei mit folgendem Inhalt: 

```

```







