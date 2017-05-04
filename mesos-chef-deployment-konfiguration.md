Chef ist sowohl der Name eines Unternehmens als auch der Name eines Konfigurationsmanagement-Tools, das in Ruby und Erlang geschrieben wurde. Es verwendet eine reine Ruby Domain-spezifische Sprache (DSL), um Systemkonfiguration "Rezepte" zu schreiben. In diesem Modul wird erklärt, wie Sie den Apache Mesos Master und den Slave mit dem Chef Kochbuch installieren und konfigurieren können. Chef ist ein Konfigurationsmanagement-Tool, um großflächige Server- und Softwareanwendungen zu automatisieren. Wir werden davon ausgehen, dass der Leser bereits mit Chef vertraut ist. Als Referenz wird folgendes Repository verwendet:

Https://github.com/everpeace/cookbook-mesos

Die Chef-Kochbuch-Version zum Zeitpunkt des Schreibens dieses Buches unterstützt die Ubuntu und CentOS Betriebssysteme. Die CentOS-Version ist experimentell und wird nicht für den Einsatz in einer Produktionsumgebung empfohlen. Ubuntu 14.04 oder höher ist erforderlich, um die Cgroups Isolator- oder Docker-Container-Features zu nutzen. Nur Mesos 0.20.0 und später unterstützt Docker-Containerisierung.

Dieses Kochbuch unterstützt die Installation in beide Richtungen - das heißt, Mesos aus der Quelle und aus dem Mesosphärenpaket zu bauen. Standardmäßig baut dieses Kochbuch Mesos aus der Quelle. Man kann zwischen der Quelle und der Mesosphäre umschalten, indem man die folgende Variable setzt:
`node[:mesos][:type]`

Rezepte

Im Folgenden sind die Rezepte, die von diesem Kochbuch verwendet werden, um Mesos zu installieren und zu konfigurieren:

* `mesos::default`: Dies installiert Mesos mit dem Quell- oder Mesosphärenrezept, abhängig von der zuvor beschriebenen Typvariable.

* `mesos::build_from_source`: Dies installiert Mesos in der üblichen Weise - das heißt, Download-Zip von GitHub, konfigurieren, machen und installieren.

* `mesos::mesosphere`:  Diese Variable installiert Mesos mit Mesosphere's Mesos-Paket. Zusammen mit ihm können wir die folgende Variable verwenden, um das ZooKeeper Paket zu installieren.

>> * `node[:mesos][:mesosphere][:with_zookeeper]`

* `mesos::master` : Dies konfiguriert die Mesos-Master- und Cluster-Bereitstellungs-Konfigurationsdateien und verwendet mesos-master, um den Dienst zu starten. Im Folgenden sind die Variablen zugeordnet, die den Konfigurationen zugeordnet sind:

>> * node[:mesos][:prefix]/var/mesos/deploy/masters
>> * node[:mesos][:prefix]/var/mesos/deploy/slaves
>> * node[:mesos][:prefix]/var/mesos/deploy/mesos-deploy-env.sh
>> * node[:mesos][:prefix]/var/mesos/deploy/mesos-master-env.sh

