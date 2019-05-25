# Kubernates AWS Autodeployment mit chef

Um eine schnelle Implementierung in AWS OpsWorks zu erreichen, können wir Installationsverfahren in Chef Rezepten schreiben. Chef ist ein Ruby-basiertes, automatisches Bereitstellungs-Management-Tool [Chef](https://www.chef.io). Es kann für die Programm-Bereitstellung und Systemkonfiguration helfen. In diesem Rezept zeigen wir Ihnen, wie Chef mit den AWS OpsWorks arbeitet.

## Fertig werden

In den folgenden Abschnitten zeigen wir Ihnen, wie Sie Chef-Rezepte mit dem OpsWorks-Stack verwenden können. Deshalb bitte die OpsWorks-Umgebung vorbereiten. Basierend auf den bisherigen Rezepten in diesem Kapitel können wir einen Kubernetes Stack mit folgender Struktur aufbauen:

![kubernetes-opsworks-stack](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_22.jpg)

Lassen Sie uns überlegen, dass Sie die gleichen Netzwerkeinstellungen im Rezept haben. Erstellen Sie die Kubernetes-Infrastruktur in AWS, was bedeutet, dass die VPC, Subnetze, Routentabellen und Sicherheitsgruppen alle einsatzbereit sind. Dann können wir die Netzwerkumgebung direkt in OpsWorks anwenden.

> Tip
> AWS-Region sollte das gleiche für Ressource-Dienstprogramm sein
> Obwohl OpsWorks ein globaler Service ist, können wir die Rechenressourcen nicht über verschiedene Regionen
> hinweg kombinieren. Seien Sie sich bewusst, dass Sie die gleiche AWS-Region der Netzwerkumgebung auswählen müssen,
> um ELB- und >Sicherheitsgruppen zu erstellen.

### Erstellen von ELB und seinen Sicherheitsgruppen

Wie Sie in der vorherigen Stack-Struktur sehen können, empfiehlt es sich, ELBs jenseits von etcd und dem Kubernetes-Master zu erstellen. Weil sowohl etcd als auch der Master ein Cluster mit mehreren Knoten sein könnten, wird eine ELB-Schicht das Portal für die anderen Anwendungsschichten bereitstellen und die Last auf die Arbeitsknoten ausgleichen. Zuerst wollen wir die Sicherheitsgruppen dieser beiden ELBs erstellen:

Regel Name

* `My ELB of etcd SG`

Protocol und Portnummer

* `80/tcp`

Quelle

* `My Kubernetes master`
* `My Kubernetes node`

Regel Name

* `My ELB of Kubernetes master SG`

Protocol und Portnummer

* `8080/tcp`

Quelle

* `My Kubernetes node SG`

Ändern Sie anschließend die vorhandenen Sicherheitsgruppen wie folgt. Es wird sichergestellt, dass der Netzwerkverkehr zu ELB zuerst umgeleitet wird:

Regel Name

* `My etcd SG`

Protocol und Portnummer

* `7001/tcp`
* `4001/tcp`

Quelle

* `My etcd SG`
* `My ELB of etcd SG`

Regel Name

* `My ELB of Kubernetes master SG`

Protocol und Portnummer

* `8080/tcp`

Quelle

* `My ELB of Kubernetes master SG`

Dann können wir die ELBs mit den angegebenen Sicherheitsgruppen erstellen. Gehen Sie zur EC2-Konsole und klicken Sie auf Load Balancers auf der linken Seite. Erstellen Sie neue ELBs mit den folgenden Konfigurationen:

ELB Name

* `my-etcd-elb`

VPC

* `My Kubernetes VPC (10.0.0.0/16)`

Listener-Konfiguration (ELB-Protokoll: Port / Instanz-Protokoll: Port)

* `HTTP:80/HTTP:4001`

Subnets

* `Meine Kubernetes Private A + Meine Kubernetes Private D`

Sicherheits Gruppe

* `My ELB of etcd SG`

Gesundheitskontrolle (Ping-Protokoll: Ping-Port / Ping-Pfad)

* HTTP:4001/version

ELB Name

* `my-k8s-master-elb`

VPC

* `My Kubernetes VPC (10.0.0.0/16)`

Listener-Konfiguration (ELB-Protokoll: Port / Instanz-Protokoll: Port)

* `HTTP:8080/HTTP:8080`

Subnets

* `Meine Kubernetes Private A + Meine Kubernetes Private D`

Sicherheits Gruppe

* `My ELB of Kubernetes master SG`

Gesundheitskontrolle (Ping-Protokoll: Ping-Port / Ping-Pfad)

* HHTTP:8080/version

Mit Ausnahme der vorherigen Konfigurationen ist es gut, andere Elemente mit den Standardeinstellungen zu verlassen. Sie müssen keine Instanzen in ELBs hinzufügen.

### Erstellen eines OpsWorks-Stacks

Die Definition eines Anwendungsstapels in OpsWorks ist einfach und einfach. Beziehen Sie sich auf die detaillierte Schritt-für-Schritt-Ansatz wie folgt:

1. Klicken Sie auf die Schaltfläche **Add stack**  und geben Sie die AWS OpsWorks Konsole ein.

2. Füllen Sie die folgenden Punkte aus. Es ist gut, die nicht erwähnten Teile mit den Vorgabewerten zu verlassen:
>
> 1. Wähle Chef 12 Stack.
>
> 2. Geben Sie einen Stapelnamen an. Zum Beispiel, mein Kubernetes-Cluster.
>
> 3. Weisen Sie Region und VPC zu, die Sie gerade für Kubernetes konfiguriert haben.
>
>4.Für Betriebssysteme, ein Linux-System und die neuesten Amazon Linux sind gut für die Installation später. Zum Beispiel Amazon Linux 2015.09.
>
>5.Klicken Sie auf **Advanced** >> unterhalb der Konfigurationen und deaktivieren Sie den Block **Use OpsWorks security groups**. Da wir bereits die erforderlichen Sicherheitsgruppen eingerichtet haben, kann diese Bewegung verhindern, dass viele unnötige Sicherheitsgruppen automatisch erstellt werden.
>
> ![ops-works-security](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_23.jpg)
>
>6.Gehen Sie jetzt vor und klicken Sie auf  **Add stack**, um einen Kubernetes Stack zu erstellen.
>

### Erstellen von Anwendungsschichten

Nachdem wir den OpsWorks Stack haben, erstellen wir die Applikationsschichten und fügen ELBs hinzu:
![aws-my-kubernetes-cluster](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_24.jpg)

Um Ebenen im Stapel zu erstellen, klicken Sie auf Hinzufügen einer Ebene auf der Vorderseite des Stapels:

![aws-etcd](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_25.jpg)

Wir können nicht einen ELB an eine Schicht im ersten Schritt der Schaffung anhängen. Klicken Sie nach dem Erstellen auf **Network** für bestimmte Ebenenänderungen. Hilf dir, folgende Schichten zu erzeugen:

Layer Name

* Etcd

Kurtzer Name(prefix für die instance)

* etcd

Sicherheits Gruppe

* My etcd SG

Hinzugefügter ELB

* my-etcd-elb

Layer Name

* Kubernetes Master

Kurtzer Name(prefix für die instance)

* k8s-master

Sicherheits Gruppe

* My Kubernetes master SG
* My flannel SG (optional)

Hinzugefügter ELB

* my-k8s-master-elb

Layer Name

* Kubernetes Node

Kurtzer Name(prefix für die instance)

* k8s-node

Sicherheits Gruppe

* My Kubernetes node SG
* My flannel SG

Hinzugefügter ELB

Sie werden erkennen, dass der Stapel wie folgt aussieht, was die gleiche Struktur ist, die wir am Anfang erwähnt haben:
![aws-layers](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_26.jpg)

Jetzt hat der OpsWorks Stack eine grundlegende Systemstruktur, aber ohne maßgeschneiderte Chef Rezepte. Im nächsten Abschnitt werden wir die Inhalts- und Setupkonzepte des Rezepts durchlaufen.

### Wie es geht…

Für die Installation von Kubernetes mit dem Chef-Rezept werden wir ein GitHub-Repository mit folgenden Dateien und relativen Pfaden vorbereiten:

```sh
$ tree .
.
└── kubernetes
    ├── recipes
    │   ├── docker.rb
    │   ├── etcd-run.rb
    │   ├── etcd.rb
    │   ├── flanneld.rb
    │   ├── kubernetes-master-run.rb
    │   ├── kubernetes-master-setup.rb
    │   ├── kubernetes-node-run.rb
    │   ├── kubernetes-node-setup.rb
    │   └── kubernetes.rb
    └── templates
        └── default
            ├── docker.erb
            ├── etcd.erb
            ├── flanneld.erb
            ├── kubernetes-master.erb
            └── kubernetes-node.erb

4 directories, 14 files
```

In diesem Abschnitt werden verschiedene Ebenen die Rezepte und Vorlagen separat, aber umfassend veranschaulichen. Erstellen Sie das Repository und das Verzeichnis auf dem GitHub Server im Voraus. Es wird Ihnen helfen, die angepassten Stapelkonfigurationen einzustellen.
Stapelkonfiguration für benutzerdefinierte Rezepte

Um die Rezepte im Stack laufen zu lassen, sollen wir in der Konfiguration des Stacks zwei Items hinzufügen: Einer ist die URL des GitHub Repo, der das Rezeptverzeichnis kubernetes gespeichert hat, das andere ist benutzerdefinierte JSON. Wir können einige Eingabeparameter für die Ausführung von Rezepten setzen.

Um die Einstellungen des aktuellen Stacks zu ändern, klicken Sie auf **Stack Settings** auf der Hauptseite und dann auf **Edit**.
Aktivieren Sie U**se custom Chef Cookbooks**. Hier finden Sie weitere Artikel für die Codebase-Konfiguration. Dann legen Sie Ihre GitHub Repository URL als Referenz:

![aws-chef](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_27.jpg)

* [](https://github.com/kubernetes-cookbook/opsworks-recipes.git.)

Als nächstes, im Block der erweiterten Optionen, geben Sie bitte die folgenden Informationen in dem Element Custom JSON:

```sh
{
  "kubernetes": {
    "version":"1.1.8",
    "cluster_cidr":"192.168.0.0/16",
    "master_url":"<The DNS name of my-k8s-master-elb>"
  },
  "etcd": {
    "elb_url":"<The DNS name of my-etcd-elb>"
  }
}
```

Der Inhalt von JSON basiert auf unseren Chefrezepten. Benutzer können beliebige Schlüsselwertstrukturdaten definieren. Normalerweise setzen wir diejenige ein, die sich dynamisch durch jede Implementierung ändern kann, zum Beispiel die Version des Kubernetes-Pakets. Es wäre besser, keinen harten Code in unseren Rezepten zu haben, oder einige Daten, die du nicht in den Rezepten zeigen will, können als Eingabeparameter gemacht werden. Zum Beispiel die URL von ELB; Es ist ein veränderbarer Wert für jeden Einsatz. Du möchtest vielleicht nicht, dass andere es wissen. Nach dem Konfigurieren des GitHub-Repository und des benutzerdefinierten JSON sind wir bereit, die Rezepte in jeder Ebene zu konfigurieren.
Rezepte für etcd

Das Lebenszyklusereignis der etcd-Schicht ist wie folgt:
![recip-etcd](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_28.jpg)

Wir trennen die Funktionalität von etcd Rezepten in zwei Event-Stufen: `kubernetes::etcd` ist auf der Setup-Phase für etcd Installation und Konfiguration gesetzt, während `kubernetes::etcd-run` ist auf der Deploy-Bühne, um den Daemon zu starten:

```sh
$ cat ./kubernetes/recipes/etcd.rb
bash 'install_etcd' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [ ! -f /usr/local/bin/etcd ]; then
    wget --max-redirect 255 https://github.com/coreos/etcd/releases/download/v2.2.5/etcd-v2.2.5-linux-amd64.tar.gz
    tar zxvf etcd-v2.2.5-linux-amd64.tar.gz
    cd etcd-v2.1.1-linux-amd64
    cp etcd etcdctl /usr/local/bin
  fi
  EOH
end

template "/etc/init.d/etcd" do
  mode "0755"
  owner "root"
  source "etcd.erb"
end
```

Das Rezept, etcd.rb, macht die Installation zuerst. Es wird das Tarball an einem temporären Ort und kopieren Sie die Binärdatei als freigegebenen lokalen Befehl. Um zu verhindern, dass die Instanz von einer bereits installierten Umgebung hochgefahren wird, werden wir eine if-Anweisung hinzufügen, um zu prüfen, ob das System den Befehl etcd hat oder nicht. Es gibt eine Vorlage etcd.erb als Dienstkonfigurationsdatei. In dieser Chef-Vorlage sind keine dynamischen Eingabeparameter erforderlich. Es ist auch dasselbe, wie wir im Bau-Rekord-Rezept in> Kapitel 1, Aufbau deiner eigenen Kubernetes erwähnt haben:

```sh
$ cat ./kubernetes/recipes/etcd-run.rb
service 'etcd' do
action [:enable,:start]
end
```

Wir haben eine kurze Funktion in der Rezeptur, etcd-run.rb, die aktiviert und startet den etcd-Service. Die Bühne, Deploy läuft direkt nach Setup. Daher wird bestätigt, dass die Installation vor dem Start des Dienstes beendet wird.
Rezepte für den Kubernetes-Meister

Die Rezepte für die Installation des Kubernetes-Masters sind so konfiguriert, wie im folgenden Screenshot gezeigt:
![kuberbnatexsdfs](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_29.jpg)
Genau wie die etcd-Schicht verwenden wir die Setup-Stufe für die Installation und die Konfigurationsdatei-Zuordnung. Das Rezept `kubernetes::kubernetes` wird zum Herunterladen des Kubernetes-Pakets verwendet. Es wird auch an die Nodeschicht geteilt:

```sh
$ cat ./kubernetes/recipes/kubernetes.rb
bash 'install_kubernetes' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [[ $(ls /usr/local/bin/kubectl) ]]; then
    current_version=$(/usr/local/bin/kubectl version | awk 'NR==1' | awk -F":\"v" '{ print $2 }' | awk -F"\"," '{ print $1 }')
    if [ "$current_version" -eq "#{node['kubernetes']['version']}" ]; then
        exit
    fi
  fi

  if [[ $(ls /usr/local/bin/kubelet) ]] ; then
    current_version=$(/usr/local/bin/kubelet --version | awk -F"Kubernetes v" '{ print $2 }')
    if [ "$current_version" -eq "#{node['kubernetes']['version']}" ]; then
        exit
    fi
  fi
  rm -rf kubernetes/
  wget --max-redirect 255 https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v#{node['kubernetes']['version']}/kubernetes.tar.gz -O kubernetes-#{node['kubernetes']['version']}.tar.gz
  tar zxvf kubernetes-#{node['kubernetes']['version']}.tar.gz
  cd kubernetes/server
  tar zxvf kubernetes-server-linux-amd64.tar.gz
  EOH
end
```

In diesem Rezept wird der Wert der Kubernetes-Version von benutzerdefiniertem JSON genommen. Wir können die neueste Version von Kubernetes angeben und die neuen Features genießen, ohne das Rezept zu verändern. Zwei verschachtelte, `if` Bedingungen verwendet werden, um zu validieren, ob die Kubernetes-Binärdatei bereitgestellt und auf die von uns angeforderte Version aktualisiert wird. Einer ist für den Meister und der andere ist für den Knoten; Wenn die Bedingung erfüllt ist, wird das Herunterladen des Paketes ignoriert. Die Haupt-Kubernetes-Master-Installation ist in das Rezept geschrieben `kubernetes-master-setup.rb`:

```sh
$ cat ./kubernetes/recipes/kubernetes-master-setup.rb
include_recipe 'kubernetes::kubernetes'

bash "master-file-copy" do
    user 'root'
    cwd '/tmp/kubernetes/server/kubernetes/server/bin'
    code <<-EOH
    if [[ $(ls /usr/local/bin/kubectl) ]]; then
        current_version=$(/usr/local/bin/kubectl version | awk 'NR==1' | awk -F":\"v" '{ print $2 }' | awk -F"\"," '{ print $1 }')
        if [ "$current_version" -eq "#{node['kubernetes']['version']}" ]; then
            exit
        fi
    fi
    cp kubectl kube-apiserver kube-scheduler kube-controller-manager kube-proxy /usr/local/bin/
    EOH
end

directory '/etc/kubernetes' do
    owner 'root'
    group 'root'
    mode '0755'
    subscribes :create, "bash[master-file-copy]", :immediately
    action :nothing
end

etcd_endpoint="http://#{node['etcd']['elb_url']}:80"

template "/etc/init.d/kubernetes-master" do
  mode "0755"
  owner "root"
  source "kubernetes-master.erb"
  variables({
    :etcd_server => etcd_endpoint,
    :cluster_cidr => node['kubernetes']['cluster_cidr']
  })
  subscribes :create, "bash[master-file-copy]", :immediately
    action :nothing
end
```

Die erste Zeile von `kubernetes-master-setup.rb` ist die Lösung, um die Abhängigkeit innerhalb der gleichen Event-Phase zu setzen. Der Ressourcentyp `include_recipe` erfordert, dass du das Rezept `kubernetes::kubernetes` zuerst ausführt. Dann ist es möglich, die notwendige Binärdatei zu kopieren, wenn der Prozess in der Versionsüberprüfungsbedingung nicht existiert und als nächstes die passende Konfigurationsdatei und das Verzeichnis für den Service vorbereitet.

Die Installation von flanneld auf dem Master-Knoten ist eine optionale Bereitstellung. Wenn ja, auf dem Kubernetes-Meister können wir auf Container zugreifen, die auf flanneld gelegt werden:

```sh
$ cat ./kubernetes/recipes/flanneld.rb
bash 'install_flannel' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [ ! -f /usr/local/bin/flanneld ]; then
    wget --max-redirect 255 https://github.com/coreos/flannel/releases/download/v0.5.2/flannel-0.5.2-linux-amd64.tar.gz
    tar zxvf flannel-0.5.2-linux-amd64.tar.gz
    cd flannel-0.5.2
    cp flanneld /usr/local/bin
    cp mk-docker-opts.sh /opt/
  fi
  EOH
end

template "/etc/init.d/flanneld" do
  mode "0755"
  owner "root"
  source "flanneld.erb"
  variables :elb_url => node['etcd']['elb_url']
  notifies :disable, 'service[flanneld]', :delayed
end

service "flanneld" do
  action :nothing
end
```

Vor allem werden wir eine Skriptdatei von flanneld an einen bestimmten Ort verschieben. Diese Datei hilft, das flanneld-definierte Netzwerk zu ordnen. Daher wird Docker auf der Einstellung basieren und seine Container im spezifischen IP-Bereich begrenzen. Für die Vorlage ist der Wert von etcd Endpunkten ein Eingangsparameter des Rezepts. Das Rezept würde die Vorlage informieren, um die etcd ELB URL als einen etcd Endpunkt zu setzen:

```sh
$ cat ./kubernetes/templates/default/flanneld.erb
:
//above lines are ignored
start() {
  # Start daemon.
  echo -n $"Starting $prog: "
  daemon $prog \
    --etcd-endpoints=http://<%= @elb_url %> -ip-masq=true \
    > /var/log/flanneld.log 2>&1 &
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && touch $lockfile
  return $RETVAL
}
:
```

Schließlich ist es gut für uns, das Rezept zu betrachten, das den Service beginnt:

```sh
$ cat ./kubernetes/recipes/kubernetes-master-run.rb
service "flanneld" do
  action :start
end

service "kubernetes-master" do
  action :start
end
```

Es ist einfach, diese beiden unabhängigen Dämonen in diesem Rezept zu starten.

### Rezepte für den Kubernetes-Node

Mit der vorherigen Erfahrung können Sie jetzt leicht verstehen, die Bereitstellung von benutzerdefinierten Rezepten und Chef-Funktionen. Dann werden wir weiter gehen, um die Rezepte für die Kubernetes-Knotenschicht zu betrachten:
![kubernetes-node](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_30.jpg)

Neben Flanneld müssen wir Docker zum Laufen von Containern installieren. Jedoch wird ein zusätzliches Rezept `kubernetes::docker` in die Setup-Stufe gestellt.

```sh
$ cat ./kubernetes/recipes/docker.rb
package "docker" do
  action :install
end

package "bridge-utils" do
  action :install
end

service "docker" do
  action :disable
end

template "/etc/sysconfig/docker" do
    mode "0644"
    owner "root"
    source "docker.erb"
end
```

Wir werden die notwendigen Pakete `docker` und `bridge-utils` in diesem Rezept installieren. Aber halten Sie den Docker Service gestoppt, da gibt es einen Service Start Abhängigkeit:

```sh
$ cat ./kubernetes/templates/default/docker.erb
# /etc/sysconfig/docker
#
# Other arguments to pass to the docker daemon process
# These will be parsed by the sysv initscript and appended
# to the arguments list passed to docker -d

. /opt/mk-docker-opts.sh
. /run/docker_opts.env

INSECURE_REGISTRY="<YOUR_DOCKER_PRIVATE_REGISTRY>"

other_args="${DOCKER_OPTS} --insecure-registry ${INSECURE_REGISTRY}"
DOCKER_CERT_PATH=/etc/docker

# Location used for temporary files, such as those created by
# docker load and build operations. Default is /var/lib/docker/tmp
# Can be overriden by setting the following environment variable.
# DOCKER_TMPDIR=/var/tmp
```

Die vorhergehende Vorlage wird mit `docker.rb` aufgerufen. Obwohl es keine Eingabeparameter gibt, ist es erwähnenswert, dass das Skript von flanneld ausgelöst wird, um zu laufen. Es wird die Netzwerkeinstellungen für Docker generieren und als Datei `/run/docker_opts.env` setzen.

Als nächstes werden Sie feststellen, dass das Knoten-Setup-Rezept ähnlich dem Master ist. Wir kopieren Binärdateien, konfigurieren Konfigurationsdateien und Verzeichnisse und halten den Knotendienst gestoppt:

```sh
$ cat ./kubernetes/recipes/kubernetes-node-setup.rb
include_recipe 'kubernetes::kubernetes'

bash "node-file-copy" do
    user 'root'
    cwd '/tmp/kubernetes/server/kubernetes/server/bin'
    code <<-EOH
    if [[ $(ls /usr/local/bin/kubelet) ]]; then
        current_version=$(/usr/local/bin/kubelet --version | awk -F"Kubernetes v" '{ print $2 }')
        if [ "$current_version" -eq "#{node['kubernetes']['version']}" ]; then
            exit
        fi
    fi
    cp kubelet kube-proxy /usr/local/bin/
    EOH
end

directory '/var/lib/kubelet' do
    owner 'root'
    group 'root'
    mode '0755'
    subscribes :create, "bash[node-file-copy]", :immediately
    action :nothing
end

directory '/etc/kubernetes' do
    owner 'root'
    group 'root'
    mode '0755'
    subscribes :create, "bash[node-file-copy]", :immediately
    action :nothing
end

template "/etc/init.d/kubernetes-node" do
  mode "0755"
  owner "root"
  source "kubernetes-node.erb"
  variables :master_url => node['kubernetes']['master_url']
  subscribes :create, "bash[node-file-copy]", :immediately
  notifies :disable, 'service[kubernetes-node]', :delayed
   action :nothing
end

service "kubernetes-node" do
  action :nothing
end

```

Auf der anderen Seite hat das Deployment Rezept des Knotens mehr Funktionen:

```sh
$ cat ./kubernetes/recipes/kubernetes-node-run.rb
service "flanneld" do
  action :start
  notifies :run, 'bash[wait_flanneld]', :delayed
end

bash 'wait_flanneld' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  tries=0
        while [ ! -f /run/flannel/subnet.env -a $tries -lt 10 ]; do
            sleep 1
            tries=$((tries + 1))
        done
  EOH

  action :nothing
  notifies :start, 'service[docker]', :delayed
end
service "docker" do
  action :nothing
  notifies :start, 'service[kubernetes-node]', :delayed
end

service "kubernetes-node" do
  action :nothing
end

```

Wegen der Abhängigkeit sollte zuerst flanneld gestartet werden und dann kann Docker nach dem Overlay-Netzwerk laufen. Der Knotendienst hängt davon ab, Docker zu betreiben, also ist es der letzte Dienst, der gestartet werden muss.
Starten der Instanzen

Schließlich haben Sie alle Rezepte bereit, einen Kubernetes-Cluster bereitzustellen. Es ist Zeit, einige Fälle zu booten! Stellen Sie sicher, dass etcd die früheste laufende Instanz ist. Zu diesem Zeitpunkt kann die Kubernetes-Master-Schicht den Master ausführen, der den Datenspeicher für Ressourceninformationen benötigt. Nachdem der Master-Knoten auch fertig ist, erstellen Sie so viele Knoten wie Sie wollen!