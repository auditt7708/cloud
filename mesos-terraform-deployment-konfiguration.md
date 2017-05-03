Terraform ist ein Infrastrukturgebäude, ein Wechsel- und Versionierungswerkzeug, um die vorhandenen beliebten Dienste sowie kundenspezifische Inhouse-Lösungen sicher und effizient zu behandeln, die im Besitz von HashiCorp sind und in Go-Sprache geschrieben sind. In diesem Modul werden wir zunächst diskutieren, wie wir Terraform installieren können, und dann werden wir überlegen, wie wir Terraform nutzen können, um einen Mesos-Cluster zu drehen.

### Terraform installieren

Gehen Sie zu https://www.terraform.io/downloads.html, laden Sie die entsprechende Version für Ihre Plattform herunter und entpacken Sie es wie folgt:

Sie werden feststellen, dass das Terraform-Archiv ein Bündel von Binärdateien ist, sobald Sie sie entpacken, was wie folgt aussieht: 

![terrform-tools](https:\\www.packtpub.com\graphics\9781785886249\graphics\B05186\_05\_04.jpg\)

Fügen Sie nun den Pfad zum Verzeichnis in der Variable PATH hinzu, damit Sie auf den Terraform-Befehl aus jedem Verzeichnis zugreifen können.

Wenn alles gut geht, dann können Sie die Verwendung von Terraform sehen, sobald Sie den Terraform-Befehl im Terminal ausführen: 

![terrform-hilfe](https:\\www.packtpub.com\graphics\9781785886249\graphics\B05186\_05\_05.jpg\)

### Aufspielen eines Mesos-Clusters mit Terraform auf Google Cloud

Um einen Mesos-Cluster in Google Cloud Engine (GCE) mit Terraform zu drehen, musst du eine JSON-Schlüsseldatei zur Authentifizierung haben. Gehen Sie zu https:\\console.developers.google.com und generieren Sie dann einen neuen JSON-Schlüssel, indem Sie zu den Credentials | navigieren Dienstkonto. Eine Datei wird dann heruntergeladen, die später benötigt wird, um Maschinen zu starten.

Wir können nun eine `terraform` Konfigurationsdatei für unseren Mesos-Cluster erstellen. Erstellen Sie eine `mesos.tf` Datei mit folgendem Inhalt:
```
module "mesos" {
  source = "github.com/ContainerSolutions/terraform-mesos"
  account_file = "/path/to/your/downloaded/key.json"
  project = "your google project"
  region = "europe-west1"
  zone = "europe-west1-d"
  gce_ssh_user = "user"
  gce_ssh_private_key_file = "/path/to/private.key"
  name = "mymesoscluster"
  masters = "3"
  slaves = "5"
  network = "10.20.30.0/24"
  domain = "example.com"
  image = "ubuntu-1404-trusty-v20150316"
  mesos_version = "0.22.1"
}
```
Wie wir feststellen können, können einige dieser Konfigurationen verwendet werden, um Versionen zu steuern, wie zB:

* `mesos_version`: Hier wird die Version von Mesos angegeben
* `image`: Das ist das Linux-Systembild

Führen Sie nun die folgenden Befehle aus, um die Bereitstellung zu starten:
```
# Download the modules
$ terraform get

# Create a terraform plan and save it to a file
$ terraform plan -out my.plan -module-depth=1

# Create the cluster
$ terraform apply my.plan
```

### Löschendes Clusters

Wir können den folgenden Befehl ausführen, um den Cluster zu zerstören:
`$ terraform destroy` 


