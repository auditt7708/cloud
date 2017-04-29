Amazon Web Services (AWS) ist der beliebteste Cloud Service. Sie können mehrere virtuelle Maschinen auf dem Amazon-Rechenzentrum starten. Dieser Abschnitt umfasst die Anmeldung, die Einrichtung der AWS-Infrastruktur und die Einführung von Kubernetes auf AWS.

### Fertig werden

Sie müssen sich bei AWS anmelden, um ein Konto zu erstellen. Access http://aws.amazon.com, um Ihre Informationen und Kreditkartennummer:
![aws-02](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_01.jpg)
AWS registration

Nach der Registrierung müssen Sie bis zu 24 Stunden warten, um Ihr Konto zu bestätigen. Danach sehen Sie die folgende Seite nach der Anmeldung an der AWS-Konsole:

![aws-console](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_02.jpg)

### Wie es geht…

AWS unterstützt mehrere Region-Rechenzentren; Sie können die nächstgelegene und billigste Region wählen. Innerhalb der Region gibt es mehrere Verfügbarkeitszonen (AZ), die physisch isolierte Orte sind, die verfügbar sind.

Sobald du eine Region ausgewählt hast, kannst du die Virtual Private Cloud (VPC) in deinem eigenen Netzwerk wie `10.0.0.0/16 `einrichten. Innerhalb von VPC können Sie auch öffentliche und private Subnetze definieren, die folgendes tun:

* Öffentliches Subnetz: Ermöglicht es Ihnen, eine öffentliche IP-Adresse zuzuordnen und von / zu öffentlichem Internet über Internet-Gateway zuzugreifen

* Private Subnetz: Weist nur eine private IP-Adresse zu. Kann nicht aus dem öffentlichen Internet, ausgehenden Zugang zum Internet über NAT zugreifen

* Zwischen öffentlichem Subnetz und privatem Subnetz sind zugänglich

Jedes Subnetz muss sich in einem einzigen AZ befinden. Daher wäre es besser, mehrere öffentliche Subnetze und mehrere private Subnetze zu erstellen, um einen einzigen Ausfallpunkt (SPOF) zu vermeiden.

![aws-vpc](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_03.jpg)
Typische VPC- und Subnetz-Design

Es wäre besser, multiAZ für NAT zu betrachten; Aber in diesem Kochbuch werden wir es überspringen, da es nicht nötig ist. Für weitere Details über das NAT-Gateway, folgen Sie bitte dem Link http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html.

Lassen Sie uns diese VPC auf Ihrem AWS erstellen.

### VPC und Subnetze

1. Klicken Sie auf der AWS-Konsole auf VPC und klicken Sie auf VPC erstellen. Dann geben Sie das Namensschild als My Kubernetes VPC und CIDR als **10.0.0.0/16** ein:
![cpc-window](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_04.jpg)
Create VPC window

Unter der VPC werden in der folgenden Tabelle Subnetze für öffentlich und privat auf multiAZ erwähnt:

|Tag NAme|CIDER Bereich|Verfügbarkeits Zone|Auto-Assign Public IP|
| :---: | :---: | :---: | :----: |
| `My Kubernetes Public A` |` 10.0.0.0/24 `|` us-east-1a `|Ja|
|` My Kubernetes Public D `|` 10.0.1.0/24 `|` us-east-1d `|Ja|
|` My Kubernetes Private A `|` 10.0.2.0/24 `|` us-east-1a `|Nein (Default)|
|` My Kubernetes Private D `|` 10.0.3.0/24 `|` us-east-1d `|Nein (default)|

2. Klicken Sie auf **Subnets** auf der linken Navigationsleiste. Klicken Sie dann auf die Schaltfläche **Create Subnet**. Füllen Sie die Informationen aus und wählen Sie die **VPC**- und **Availability Zone** für jedes Subnetz. Wiederholen Sie diese viermal, um vier Subnetze zu erstellen:
![Creating-subnet](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_05.jpg)
Creating subnet

3. Wählen Sie das öffentliche Subnetz aus und klicken Sie auf die Schaltfläche **Subnet Actions**. Wählen Sie dann "Auto-Assign Public IP", um die öffentliche IP-Auto-Zuweisung zu aktivieren.
![Auto-Assign-Public-IP](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_06.jpg)
Set Auto-Assign Public IP


### Internet Gateway und NAT

Jedes Subnetz sollte ein Gateway haben, das zu einem externen Netzwerk führt. Es gibt zwei Arten von Gateway, wie folgt:

* Internet Gateway (IGW): Es erlaubt Ihnen, von / zum Internet (bidirektional) für einen Server zuzugreifen, der eine öffentliche IP-Adresse hat

* Network Address Translation (NAT): Es ermöglicht Ihnen den Zugriff auf das Internet (eine Richtung) für einen Server mit privater IP-Adresse

Öffentliche Subnetze assoziieren mit einem Internet-Gateway; Auf der anderen Seite können private Subnetze über NAT ins Internet gehen. Lassen Sie uns IGW und NAT wie folgt erstellen:

|Typ|Verbunden mit|
| :---: | :---: |
|Internet Gateway|VPS|
|NAT Gateway|Public Subnet A|

### Route Tabelle

1. Nach dem Erstellen von IGW und NAT müssen Sie die Routentabelle anpassen, um das Standard-Gateway auf IGW oder NAT zu setzen, wie folgt:

|Name der Routing Tabelle|Routen Ziel|Verbindung|
| :---: | :---:| :---: |
|` My Kubernetes Public Route `|` 10.0.0.0/16 local ` ` 0.0.0.0/0 IGW `|Public Subnet A Public Subnet D|
|` My Kubernetes Private Route `|` 10.0.0.0/16 local ` ` 0.0.0.0/0 NAT `|Private Subnet A Private Subnet D|

2. Klicken Sie auf der AWS-Konsole auf Routen-Tabellen im linken Navigationsbereich. Klicken Sie dann auf die Schaltfläche Route ändern. Füllen Sie den Tabellennamen aus und wählen Sie das VPN aus, das Sie erstellt haben. Wiederholen Sie diesen Vorgang zweimal für eine öffentliche Strecke und eine private Route.

3. Nach dem Erstellen von Routen müssen Sie die Standardroute entweder als Internet Gateway (IGW) oder NAT hinzufügen.

Für eine öffentliche **Route** klicken Sie auf die Registerkarte Routen und klicken auf **Edit**. Fügen Sie dann die Standardroute als `0.0.0.0/0` und Target als IGW-ID hinzu.

Für eine private **Route** klicken Sie auf die Registerkarte Routen und klicken auf **Edit**. Fügen Sie dann die Standardroute als `0.0.0.0/0` und Target als NAT Gateway ID hinzu.
![net-default-route-nat](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_07.jpg)

4. Klicken Sie abschließend auf die Registerkarte **Subnet Associations** und dann auf die Schaltfläche Bearbeiten. Dann wählen Sie öffentliche Subnetze für eine öffentliche Route und private Subnetze für eine private Route, wie folgt:
![aws-route-table-subnet](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_08.jpg)
Associate route table to subnet

Sicherheitsgruppe

Sicherheitsgruppe ist eine Art Firewall, um eine Regel einzurichten, die entweder eingehenden Verkehr oder ausgehenden Verkehr erlaubt. Für Kubernetes gibt es einige bekannte Verkehrsregeln, die wie folgt gesetzt werden sollten:

|Rul Name|Protokol und Port Nummer|Quelle|
| :---: | :--: | :---: |
|` My Kubernetes master SG `|* `8080/tcp `|* `My Kubernetes node `|
|` My Kubernetes node SG `|* `30000-32767/tcp (Service)`|* `0.0.0.0/0 `|
|` My etcd SG`|* `7001/tcp` * `4001/tcp` * `2379/tcp` * `2380/tcp`| * `My etcd SG` * `My Kubernetes master SG` * `My Kubernetes node SG `|
|` My flannel SG `| * ` 8285/udp ` * ` 8472/udp `| * `     My flannel SG `|
|` My ssh SG `|* ` 22/tcp `|* `0.0.0.0/0 `|

Klicken Sie auf der AWS-Konsole auf Sicherheitsgruppen im linken Navigationsbereich, erstellen Sie fünf Sicherheitsgruppen und fügen Sie Inbound Rules wie folgt hinzu:
![aws-sec-group](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_09.jpg)

Rulen Name 
- My Kubernetes master SG 
Inbound Protocol und Portnummer
- 
Quelle
- 

