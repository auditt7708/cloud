# Mesos Deployment mit Chef

Chef ist sowohl der Name eines Unternehmens als auch der Name eines Konfigurationsmanagement-Tools, das in Ruby und Erlang geschrieben wurde.
Es verwendet eine reine Ruby Domain-spezifische Sprache (DSL), um Systemkonfiguration "Rezepte" zu schreiben.
In diesem Modul wird erklärt, wie Sie den Apache Mesos Master und den Slave mit dem Chef Kochbuch installieren und konfigurieren können.
Chef ist ein Konfigurationsmanagement-Tool, um großflächige Server- und Softwareanwendungen zu automatisieren.
Wir werden davon ausgehen, dass der Leser bereits mit Chef vertraut ist. Als Referenz wird folgendes Repository verwendet:

* [Chef ](Https://github.com/everpeace/cookbook-mesos)

Die Chef-Kochbuch-Version zum Zeitpunkt des Schreibens dieses Buches unterstützt die Ubuntu und CentOS Betriebssysteme. Die CentOS-Version ist experimentell und wird nicht für den Einsatz in einer Produktionsumgebung empfohlen. Ubuntu 14.04 oder höher ist erforderlich, um die Cgroups Isolator- oder Docker-Container-Features zu nutzen. Nur Mesos 0.20.0 und später unterstützt Docker-Containerisierung.

Dieses Kochbuch unterstützt die Installation in beide Richtungen - das heißt, Mesos aus der Quelle und aus dem Mesosphärenpaket zu bauen. Standardmäßig baut dieses Kochbuch Mesos aus der Quelle. Man kann zwischen der Quelle und der Mesosphäre umschalten, indem man die folgende Variable setzt:
`node[:mesos][:type]`

Rezepte

Im Folgenden sind die Rezepte, die von diesem Kochbuch verwendet werden, um Mesos zu installieren und zu konfigurieren:

>
> * `mesos::default`: Dies installiert Mesos mit dem Quell- oder Mesosphärenrezept, abhängig von der zuvor beschriebenen Typvariable.
>
> * `mesos::build_from_source`: Dies installiert Mesos in der üblichen Weise - das heißt, Download-Zip von GitHub, konfigurieren, machen und installieren.

> * `mesos::mesosphere`:  Diese Variable installiert Mesos mit Mesosphere's Mesos-Paket. Zusammen mit ihm können wir die folgende Variable verwenden, um das ZooKeeper Paket zu installieren.
>
>> * `node[:mesos][:mesosphere][:with_zookeeper]`
>
> * `mesos::master` : Dies konfiguriert die Mesos-Master- und Cluster-Bereitstellungs-Konfigurationsdateien und verwendet mesos-master, um den Dienst zu starten. Im Folgenden sind die Variablen zugeordnet, die den Konfigurationen zugeordnet sind:
>
>> * node[:mesos][:prefix]/var/mesos/deploy/masters
>> * node[:mesos][:prefix]/var/mesos/deploy/slaves
>> * node[:mesos][:prefix]/var/mesos/deploy/mesos-deploy-env.sh
>> * node[:mesos][:prefix]/var/mesos/deploy/mesos-master-env.sh
>

Wenn wir die Mesosphäre als den zu bauenden Typ auswählen, dann wird der Voreinstellungsort ":" Präfix-Attribut / usr / local als das Paket von Mesosphere installiert Mesos in diesem Verzeichnis. Dieses Rezept konfiguriert auch die Upstart-Dateien an folgenden Orten:

* `/etc/mesos/zk`
* `/etc/defaults/mesos`
* `/etc/defaults/mesos-master`

## Mesos-Master konfigurieren

Mit den Befehlszeilenparametern des `mesos-master` können Sie das `node[:mesos][:master]` Attribut konfigurieren. Ein Beispiel dafür ist:

```sh
node[:mesos][:master] = {
  :port    => "5050",
  :log_dir => "/var/log/mesos",
  :zk      => "zk://localhost:2181/mesos",
  :cluster => "MesosCluster",
  :quorum  => "1"
}
```

Der Befehl `mesos-master` wird mit den in der Konfiguration angegebenen Optionen wie folgt aufgerufen:

`mesos-master --zk=zk://localhost:2181/mesos --port=5050 --log_dir=/var/log/mesos --cluster=MesosCluster`

Der Befehl `mesos::slave` stellt Konfigurationen für den `mesos-slave` zur Verfügung und startet die Mesos-Slave-Instanz. Wir können die folgende Variable verwenden, um auf die Datei `mesos-slave-env.sh` zu zeigen:

* `node[:mesos][:prefix]/var/mesos/deploy/mesos-slave-env.sh`

Die Upstart-Konfigurationsdateien für den mesos-Slave sind wie folgt:

* `/etc/mesos/zk`

* `/etc/defaults/mesos`

* `/etc/defaults/mesos-slave`

Mesos-Slave konfigurieren

Die `mesos-slave` Befehlszeilenoptionen können mit dem `node[:mesos][:slave]` hash konfiguriert werden. Eine Beispielkonfiguration ist hier gegeben:

````sh
node[:mesos][:slave] = {
  :master    => "zk://localhost:2181/mesos",
  :log_dir   => "/var/log/mesos",
  :containerizers => "docker,mesos",
  :isolation => "cgroups/cpu,cgroups/mem",
  :work_dir  => "/var/run/work"
}
```

Der Befehl `mesos-slave` wird wie folgt aufgerufen:

```sh
mesos-slave --master=zk://localhost:2181/mesos --log_dir=/var/log/mesos --containerizers=docker,mesos --isolation=cgroups/cpu,cgroups/mem --work_dir=/var/run/work
```

Nun, lassen Sie uns einen Blick darauf werfen, wie wir das alles zusammen in eine vagrant Datei stellen und einen eigenständigen Mesos-Cluster starten können. Erstellen Sie eine `Vagrantfile` mit folgendem Inhalt:

```sh
# -*- mode: ruby -*-
# vi: set ft=ruby:
# vagrant plugins required:
# vagrant-berkshelf, vagrant-omnibus, vagrant-hosts
Vagrant.configure("2") do |config|
  config.vm.box = "Official Ubuntu 14.04 daily Cloud Image amd64 (Development release,  No Guest Additions)"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

#  config.vm.box = "chef/centos-6.5"

  # enable plugins
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
  # if you want to use vagrant-cachier,
  # please activate below.
  config.cache.auto_detect = true

  # please customize hostname and private ip configuration if you need it.
  config.vm.hostname = "mesos"
  private_ip = "192.168.1.10"
  config.vm.network :private_network, ip: private_ip
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host private_ip , [ config.vm.hostname ]
  end
  # for mesos web UI.
  config.vm.network :forwarded_port, guest: 5050, host: 5050
  config.vm.provider :virtualbox do |vb|
    vb.name = 'cookbook-mesos-sample-source'
    # Use VBoxManage to customize the VM. For example, to change memory:
    vb.customize ["modifyvm", :id, "--memory", "#{1024*4}"]
    vb.customize ["modifyvm", :id,  "--cpus",  "2"]
  end

  config.vm.provision :shell do |s|
        s.path = "scripts/populate_sshkey.sh"
        s.args = "/home/vagrant vagrant"
  end

  # mesos-master doesn't create its work_dir.
  config.vm.provision :shell, :inline => "mkdir -p /tmp/mesos"

  # Mesos master depends on zookeeper emsamble since 0.19.0
  # for Ubuntu
  config.vm.provision :shell, :inline => "apt-get update && apt-get install -y zookeeper zookeeperd zookeeper-bin"
  # For CentOS
  # config.vm.provision :shell, :inline => <<-EOH
  #   rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
  #   yum install -y -q curl
  #   curl -sSfL http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera --output /tmp/cdh.key
  #   rpm --import /tmp/cdh.key
  #   yum install -y -q java-1.7.0-openjdk zookeeper zookeeper-server
  #   service zookeeper-server init
  #   service zookeeper-server start
  # EOH

  config.vm.provision :chef_solo do |chef|
#    chef.log_level = :debug
    chef.add_recipe "mesos"
    chef.add_recipe "mesos::master"
    chef.add_recipe "mesos::slave"

    # You may also specify custom JSON attributes:
    chef.json = {
      :java => {
        'install_flavor' => "openjdk",
        'jdk_version' => "7",
      },
      :maven => {
        :version => "3",
        "3" => {
          :version => "3.0.5"
        },
        :mavenrc => {
          :opts => "-Dmaven.repo.local=$HOME/.m2/repository -Xmx384m -XX:MaxPermSize=192m"
        }
      },
      :mesos => {
        :home         => "/home/vagrant",
        # command line options for mesos-master
        :master => {
          :zk => "zk://localhost:2181/mesos",
          :log_dir => "/var/log/mesos",
          :cluster => "MesosCluster",
          :quorum  => "1"
        },
        # command line options for mesos-slave
        :slave =>{
          :master => "zk://localhost:2181/mesos",
          :isolation => "posix/cpu,posix/mem",
          :log_dir => "/var/log/mesos",
          :work_dir => "/var/run/work"
        },
        # below ip lists are for mesos-[start|stop]-cluster.sh
        :master_ips => ["localhost"],
        :slave_ips  => ["localhost"]
      }
    }
  end
end
```

Geben Sie nun den folgenden Befehl ein, um einen voll funktionsfähigen Standalone-Mesos-Cluster zu haben:

`vagrant up`