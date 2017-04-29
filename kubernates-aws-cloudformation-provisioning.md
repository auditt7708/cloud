AWS CloudFormation ist ein Service, um die AWS-Ressourcenerstellung einfach zu machen. Eine einfache JSON-Format-Textdatei könnte Ihnen die Möglichkeit geben, die Anwendungsinfrastruktur mit nur wenigen Klicks zu erstellen. Systemadministratoren und Entwickler können ihre AWS-Ressourcen einfach erstellen, aktualisieren und verwalten, ohne sich Gedanken über menschliches Fehler zu machen. In diesem Abschnitt werden wir den Inhalt der vorherigen Abschnitte in diesem Kapitel nutzen und CloudFormation verwenden, um sie zu erstellen und Instanzen mit der Kubernetes-Einstellung automatisch zu starten.

### Fertig werden

Die Einheit von CloudFormation ist ein Stack. Ein Stapel wird von einer CloudFormation-Vorlage erstellt, die eine Textdatei ist, die AWS-Ressourcen im JSON-Format auflistet. Bevor wir einen CloudFormation-Stack mit der CloudFormation-Vorlage in der AWS-Konsole starten, erhalten wir ein tieferes Verständnis der Registerkarten auf der CloudFormation-Konsole:

|Tab Name|Beschreibung|
| :---: | :---: |
|`Overview`|Stapelprofilübersicht. Name, Status und Beschreibung finden Sie hier|
|`Output`|Die Ausgabefelder dieses Stacks|
|`Resources`|Die in diesem Stack aufgeführten Ressourcen|
|`Events`|Die Ereignisse bei der Durchführung von Operationen in diesem Stack|
|`Template`|Textdatei im JSON-Format|
|`Parameters`|Die Eingabeparameter dieses Stacks|
|`Tags`|AWS-Tags für die Ressourcen|
|` Stack Policy `|Stack-Policy bei der Aktualisierung verwenden. Dies kann Sie daran hindern, Ressourcen versehentlich zu entfernen oder zu aktualisieren|

Eine CloudFormation-Vorlage enthält viele Abschnitte. Die Beschreibungen werden in die folgende Mustervorlage gesetzt:
```
{
   "AWSTemplateFormatVersion":"AWS CloudFormation templateversion date",
   "Description":"stack description",
   "Metadata":{
    # put additional information for this template
   },
   "Parameters":{
    # user-specified the input of your template

   },
   "Mappings":{
    # using for define conditional parameter values and use it in the template
   },
   "Conditions":{
    # use to define whether certain resources are created, configured in a certain condition.
   },
   "Resources":{
    # major section in the template, use to create and configure AWS resources
   },
   "Outputs":{
    # user-specified output 
   }
}
```
Wir werden diese drei Hauptabschnitte verwenden:
*     Parameters
*     Resources
*     Outputs

`Parameter` sind die Variable, die Sie beim Erstellen des Stacks eingeben möchten. Die `Resources` sind ein wichtiger Abschnitt für die Deklaration von AWS-Ressourceneinstellungen und `Outputs` sind der Abschnitt, den Sie der CloudFormation-Benutzeroberfläche aussetzen möchten, damit es einfach ist, die Ausgabeinformationen von einem zu finden Ressource, wenn eine Vorlage bereitgestellt wird.

Intrinsic Functions sind integrierte Funktionen von AWS CloudFormation. Sie geben Ihnen die Macht, Ihre Ressourcen miteinander zu verknüpfen. Es ist ein häufiger Anwendungsfall, dass Sie mehrere Ressourcen miteinander verknüpfen müssen, aber sie werden sich bis zur Laufzeit kennen. In diesem Fall könnte die intrinsische Funktion eine perfekte Ergänzung sein, um dies zu lösen. In CloudFormation werden mehrere intrinsische Funktionen bereitgestellt. In diesem Fall verwenden wir `Fn::GetAtt`, `Fn::GetAZs` und Ref.

Die folgende Tabelle hat ihre Beschreibungen:

|Funktionen| Beschreibung| Benutzung|
| :---: | :---: | :---: |
|`Fn::GetAtt`|Abrufen eines Wertes eines Attributs aus einer Ressource|`{"Fn::GetAtt" : [ "logicalNameOfResource", "attributeName" ]}`|
|`Fn::GetAZs`|Geben Sie eine Liste der AZs für die Region zurück|`{"Fn::GetAZs" : "us-east-1"}`|
|` Fn::Select `|Wählen Sie einen Wert aus einer Liste aus|`{ "Fn::Select" : [ index, listOfObjects ]}`|
|`Ref`|Geben Sie einen Wert aus einem logischen Namen oder Parameter zurück|`{"Ref" : "logicalName"}`|

### Wie es geht…

Anstatt eine Bitvorlage mit tausend Zeilen zu starten, werden wir sie in zwei Teile aufteilen: eine ist für Netzwerkressourcen - nur eine andere ist nur anwendungsweise. Beide Vorlagen stehen auf unserem GitHub Repository über https://github.com/kubernetes-cookbook/cloudformation zur Verfügung.
Erstellen einer Netzwerkinfrastruktur

Überprüfen Sie die folgende Infrastruktur, die im Gebäude der Kubernetes-Infrastruktur im AWS-Bereich aufgeführt ist. Wir erstellen einen VPC mit `10.0.0.0/16` mit zwei öffentlichen Subnetzen und zwei privaten Subnetzen darin. Neben diesen werden wir ein Internet-Gateway erstellen und verwandte Routentabellenregeln zu einem öffentlichen Subnetz hinzufügen, um den Verkehr zur Außenwelt zu führen. Wir erstellen auch ein NAT Gateway, das sich im öffentlichen Subnetz mit einer Elastic IP befindet, um sicherzustellen, dass ein privates Subnetz Zugang zum Internet erhält:
![vpc-net-aws](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_31.jpg)

Wie machen wir das? Am Anfang der Vorlage definieren wir zwei Parameter: Eins ist `Präfix` und ein anderer ist `CIDRPrefix`. `Präfix` ist ein Präfix, das verwendet wird, um die Ressource zu nennen, die wir erstellen werden. `CIDRPrefix` ist zwei Abschnitte einer IP-Adresse, die wir erstellen möchten. Die Voreinstellung ist `10.0.` Wir werden auch die Länge einschränken:
```
"Parameters":{
      "Prefix":{
         "Description":"Prefix of resources",
         "Type":"String",
         "Default":"KubernetesSample",
         "MinLength":"1",
         "MaxLength":"24",
         "ConstraintDescription":"Length is too long"
      },
      "CIDRPrefix":{
         "Description":"Network cidr prefix",
         "Type":"String",
         "Default":"10.0",
         "MinLength":"1",
         "MaxLength":"8",
         "ConstraintDescription":"Length is too long"
      }
   }
```
Dann werden wir mit der Beschreibung des `Resources`-Bereichs beginnen. Für detaillierte Ressourcentypen und Attribute empfehlen wir Ihnen, die AWS-Dokumentation unter http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html zu besuchen:
```
"VPC":{
         "Type":"AWS::EC2::VPC",
         "Properties":{
            "CidrBlock":{
               "Fn::Join":[
                  ".",
                  [
                     {
                        "Ref":"CIDRPrefix"
                     },
                     "0.0/16"
                  ]
               ]
            },
            "EnableDnsHostnames":"true",
            "Tags":[
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        ".",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "vpc"
                        ]
                     ]
                  }
               },
               {
                  "Key":"EnvName",
                  "Value":{
                     "Ref":"Prefix"
                  }
               }
            ]
         }
      }
```
Hier erstellen wir eine Ressource mit dem logischen Namen `VPC` und geben `AWS::EC2::VPC` ein. Bitte beachten Sie, dass der logische Name wichtig ist und er nicht in einer Vorlage dupliziert werden kann. Sie können {"Ref": "VPC"} in einer anderen Ressource in dieser Vorlage verwenden, um auf `VPCId` zu verweisen. Der Name von VPC ist $Prefix.vpc mit CIDR `$CIDRPrefix.0.0/16`. Das folgende Bild ist das einer erstellten VPC:
![sample-vpc](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_32.jpg)

Als nächstes erstellen wir das erste öffentliche Subnetz mit CIDR `$CIDRPrefix.0.0/24`. Beachten Sie, dass `{Fn::GetAZs:""}` eine Liste aller verfügbaren AZs zurückgibt. Wir verwenden `Fn::Select`, um das erste Element mit Index 0 auszuwählen:
```
"SubnetPublicA":{
         "Type":"AWS::EC2::Subnet",
         "Properties":{
            "VpcId":{
               "Ref":"VPC"
            },
            "CidrBlock":{
               "Fn::Join":[
                  ".",
                  [
                     {
                        "Ref":"CIDRPrefix"
                     },
                     "0.0/24"
                  ]
               ]
            },
            "AvailabilityZone":{
               "Fn::Select":[
                  "0",
                  {
                     "Fn::GetAZs":""
                  }
               ]
            },
            "Tags":[
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        ".",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "public",
                           "subnet",
                           "A"
                        ]
                     ]
                  }
               },
               {
                  "Key":"EnvName",
                  "Value":{
                     "Ref":"Prefix"
                  }
               }
            ]
         }
      }
```
Das zweite öffentliche Subnetz und zwei private Subnetze sind die gleichen wie die erste nur mit einem anderen CIDR `$CIDRPrefix.1.0/24`. Der Unterschied zwischen öffentlichen und privaten Subnetzen ist, ob sie Internet erreichbar sind oder nicht. Typischerweise wird eine Instanz in einem öffentlichen Subnetz eine öffentliche IP oder eine Elastische IP mit ihr haben, die Internet erreichbar ist. Allerdings kann ein privates Subnetz nicht aus dem Internet erreichbar sein, außer mit einem Bastion-Host oder über VPN. Der Unterschied in der AWS-Einstellung sind die Routen in Routentabellen. Um Ihre Instanzen mit dem Internet zu kommunizieren, sollten wir ein Internet-Gateway zu einem öffentlichen Subnetz und einem NAT Gateway zu einem privaten Subnetz erstellen:
```
"InternetGateway":{
         "Type":"AWS::EC2::InternetGateway",
         "Properties":{
            "Tags":[
               {
                  "Key":"Stack",
                  "Value":{
                     "Ref":"AWS::StackId"
                  }
               },
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        ".",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "vpc",
                           "igw"
                        ]
                     ]
                  }
               },
               {
                  "Key":"EnvName",
                  "Value":{
                     "Ref":"Prefix"
                  }
               }
            ]
         }
      },
      "GatewayAttachment":{
         "Type":"AWS::EC2::VPCGatewayAttachment",
         "Properties":{
            "VpcId":{
               "Ref":"VPC"
            },
            "InternetGatewayId":{
               "Ref":"InternetGateway"
            }
         }
      }
```
Wir erklären ein Internet-Gateway mit dem Namen `$Prefix.vpc.igw` und dem logischen Namen InternetGateway; Wir werden es auch an VPC anschließen. Dann schaffen wir `NatGateway`. `NatGateway` benötigt standardmäßig ein EIP, also erstellen wir es zuerst und verwenden die DependsOn-Funktion, um CloudFormation mitzuteilen, dass die `NatGateway`-Ressource nach `NatGatewayEIP` erstellt werden muss. Beachten Sie, dass es `AllocationId` in den Eigenschaften von `NatGateway` anstatt der Gateway-ID gibt. Wir verwenden die intrinsische Funktion Fn :: GetAtt, um das Attribut `AllocationId` aus der Ressource `NatGatewayEIP` zu erhalten:
```
"NatGatewayEIP":{
         "Type":"AWS::EC2::EIP",
         "DependsOn":"GatewayAttachment",
         "Properties":{
            "Domain":"vpc"
         }
      },
      "NatGateway":{
         "Type":"AWS::EC2::NatGateway",
         "DependsOn":"NatGatewayEIP",
         "Properties":{
            "AllocationId":{
               "Fn::GetAtt":[
                  "NatGatewayEIP",
                  "AllocationId"
               ]
            },
            "SubnetId":{
               "Ref":"SubnetPublicA"
            }
         }
      }
```
Zeit, eine Routentabelle für öffentliche Subnetze zu erstellen:
```

 "RouteTableInternet":{
         "Type":"AWS::EC2::RouteTable",
         "Properties":{
            "VpcId":{
               "Ref":"VPC"
            },
            "Tags":[
               {
                  "Key":"Stack",
                  "Value":{
                     "Ref":"AWS::StackId"
                  }
               },
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        ".",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "internet",
                           "routetable"
                        ]
                     ]
                  }
               },
               {
                  "Key":"EnvName",
                  "Value":{
                     "Ref":"Prefix"
                  }
               }
            ]
         }
      }
```
Was ist mit privaten Subnetzen? Sie könnten die gleiche Erklärung verwenden; Ändern Sie einfach den logischen Namen in `RouteTableNat`. Nach dem Erstellen einer Route-Tabelle, lassen Sie uns die Routen:
```
 "RouteInternet":{
         "Type":"AWS::EC2::Route",
         "DependsOn":"GatewayAttachment",
         "Properties":{
            "RouteTableId":{
               "Ref":"RouteTableInternet"
            },
            "DestinationCidrBlock":"0.0.0.0/0",
            "GatewayId":{
               "Ref":"InternetGateway"
            }
         }
      }
```

Diese Route ist für die Routentabelle eines öffentlichen Subnetzes. Es wird in die `RouteTableInternet`-Tabelle umziehen und die Pakete an `InternetGatway` weiterleiten, wenn das Ziel CIDR `0.0.0.0/0` ist. Schauen wir uns einen privaten Subnetz an:
```      "RouteNat":{
         "Type":"AWS::EC2::Route",
         "DependsOn":"RouteTableNat",
         "Properties":{
            "RouteTableId":{
               "Ref":"RouteTableNat"
            },
            "DestinationCidrBlock":"0.0.0.0/0",
            "NatGatewayId":{
               "Ref":"NatGateway"
            }
         }
      }
```
Es ist so ziemlich das gleiche mit `RouteInternet` aber die Pakete zu `NatGateway`, wenn es irgendwelche gibt, auf `0.0.0.0/0`. Warten Sie, was ist die Beziehung zwischen Subnetz und einer Routentabelle? Wir haben keine Deklaration angegeben, die Regeln in einem bestimmten Subnetz angeben. Wir müssen `SubnetRouteTableAssociation` verwenden, um ihre Beziehung zu definieren. Die folgenden Beispiele definieren sowohl das öffentliche Subnetz als auch das private Subnetz; Sie können auch ein zweites öffentliches / privates Subnetz hinzufügen, indem Sie sie kopieren:
```
      "SubnetRouteTableInternetAssociationA":{
         "Type":"AWS::EC2::SubnetRouteTableAssociation",
         "Properties":{
            "SubnetId":{
               "Ref":"SubnetPublicA"
            },
            "RouteTableId":{
               "Ref":"RouteTableInternet"
            }
         }
      },
      "SubnetRouteTableNatAssociationA":{
         "Type":"AWS::EC2::SubnetRouteTableAssociation",
         "Properties":{
            "SubnetId":{
               "Ref":"SubnetPrivateA"
            },
            "RouteTableId":{
               "Ref":"RouteTableNat"
            }
         }
      }

```
Wir sind für die Netzwerkinfrastruktur fertig. Dann lasst uns es von der AWS-Konsole starten. Zuerst klicken Sie einfach auf und starten Sie einen Stapel und wählen Sie die VPC Mustervorlage.

```
![choose-template](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_33.jpg)

Klicken Sie auf **Next**; Sie sehen die Seiten der Seiten. Es hat seinen eigenen Standardwert, aber man konnte ihn bei der Erstellungs- / Aktualisierungszeit des Stacks ändern.
![aws-specify-details](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_34.jpg)

Nachdem Sie auf das Ziel geklickt haben, beginnt CloudFormation mit der Erstellung der Ressourcen, die Sie auf der Vorlage beanspruchen. Es wird den Status als CREATE_COMPLETE nach Abschluss zurückgeben.

### Erstellen von OpsWorks für das Anwendungsmanagement

Für das Anwendungsmanagement nutzen wir OpsWorks, ein Application Lifecycle Management in AWS. Bitte beachten Sie die vorherigen zwei Abschnitte, um mehr über OpsWorks und Chef zu erfahren. Hier beschreiben wir, wie man die Erstellung des OpsWorks Stacks und der damit verbundenen Ressourcen automatisiert.

Wir haben hier acht Parameter. Fügen Sie `K8sMasterBaAccount`, `K8sMasterBaPassword` und `EtcdBaPassword` als die grundlegende Authentifizierung für Kubernetes master und etcd hinzu. Wir werden auch die VPC ID und die private Subnetz ID hier als Eingabe eingeben, die im vorherigen Sample angelegt werden. Als Parameter könnten wir den Typ `AWS::EC2::VPC::Id` als Dropdown-Liste in der Benutzeroberfläche verwenden. Bitte beachten Sie den unterstützten Typ in der AWS-Dokumentation über http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html:
```
"Parameters":{
      "Prefix":{
         "Description":"Prefix of resources",
         "Type":"String",
         "Default":"KubernetesSample",
         "MinLength":"1",
         "MaxLength":"24",
         "ConstraintDescription":"Length is too long"
      },
      "PrivateNetworkCIDR":{
         "Default":"192.168.0.0/16",
         "Description":"Desired Private Network CIDR or Flanneld (must not overrap VPC CIDR)",
         "Type":"String",
         "MinLength":"9",
         "AllowedPattern":"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}",
         "ConstraintDescription":"PrivateNetworkCIDR must be IPv4 format"
      },
      "VPCId":{
         "Description":"VPC Id",
         "Type":"AWS::EC2::VPC::Id"
      },
      "SubnetPrivateIdA":{
         "Description":"Private SubnetA",
         "Type":"AWS::EC2::Subnet::Id"
      },
      "SubnetPrivateIdB":{
         "Description":"Private SubnetB",
         "Default":"subnet-9007ecc9",
         "Type":"AWS::EC2::Subnet::Id"
      },
      "K8sMasterBaAccount":{
         "Default":"admin",
         "Description":"The account of basic authentication for k8s Master",
         "Type":"String",
         "MinLength":"1",
         "MaxLength":"75",
         "AllowedPattern":"[a-zA-Z0-9]*",
         "ConstraintDescription":"Account and Password should follow Base64 pattern"
      },
      "K8sMasterBaPassword":{
         "Default":"Passw0rd",
         "Description":"The password of basic authentication for k8s Master",
         "Type":"String",
         "MinLength":"1",
         "MaxLength":"75",
         "NoEcho":"true",
         "AllowedPattern":"[a-zA-Z0-9]*",
         "ConstraintDescription":"Account and Password should follow Base64 pattern"
      },
      "EtcdBaPassword":{
         "Default":"Passw0rd",
         "Description":"The password of basic authentication for Etcd",
         "Type":"String",
         "MinLength":"1",
         "MaxLength":"71",
         "NoEcho":"true",
         "AllowedPattern":"[a-zA-Z0-9]*",
         "ConstraintDescription":"Password should follow Base64 pattern"
      }
   }
```
Bevor wir mit dem OpsWorks Stack anfangen, müssen wir zwei IAM Rollen für sie erstellen. Einer ist eine Dienstleistungsrolle, die zum Starten von Instanzen, zum Anfügen von ELB und so weiter verwendet wird. Eine andere ist eine Instanzrolle, die die Berechtigung für das, was Ihre OpsWorks-Instanzen ausführen können, definieren, um auf die AWS-Ressourcen zuzugreifen. Hier werden wir nicht auf AWS-Ressourcen von EC2 zugreifen, so dass wir nur ein Skelett erstellen können. Bitte beachten Sie, dass Sie IAM-Berechtigung benötigen, wenn Sie CloudFormation mit IAM-Erstellung starten. Klicken Sie auf das folgende Kontrollkästchen, wenn Sie den Stapel starten:

![aws-iam](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_35.jpg)

Im Bereich `SecurityGroup` definieren wir jeden Eingang und Ausgang zu einem Satz von Maschinen. Wir nehmen den Kubernetes Meister als Beispiel. Da wir ELB vor den Master und ELB setzen, um die Flexibilität für zukünftige HA-Einstellungen beizubehalten. Mit ELB müssen wir eine Sicherheitsgruppe zu ELB erstellen und den Eintritt des Kubernetes-Masters, der mit `8080` und `6443` von der ELB-Sicherheitsgruppe in Berührung kommen kann, zeigen. Nachfolgend ist das Beispiel der Sicherheitsgruppe für den Kubernetes-Meister; Es öffnet `80` und `8080` nach außen:
```
"SecurityGroupELBKubMaster":{
         "Type":"AWS::EC2::SecurityGroup",
         "Properties":{
            "GroupDescription":{
               "Ref":"Prefix"
            },
            "SecurityGroupIngress":[
               {
                  "IpProtocol":"tcp",
                  "FromPort":"80",
                  "ToPort":"80",
                  "CidrIp":"0.0.0.0/0"
               },
               {
                  "IpProtocol":"tcp",
                  "FromPort":"8080",
                  "ToPort":"8080",
                  "SourceSecurityGroupId":{
                     "Ref":"SecurityGroupKubNode"
                  }
               }
            ],
            "VpcId":{
               "Ref":"VPCId"
            },
            "Tags":[
               {
                  "Key":"Application",
                  "Value":{
                     "Ref":"AWS::StackId"
                  }
               },
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        "-",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "SGElbKubMaster"
                        ]
                     ]
                  }
               }
            ]
         }
      },
```
Here is the example of the Kubernetes master instance set. It allows you to receive traffic from `8080` and `6443` from its ELB. We will open the SSH port to use the `kubectl` command:
```
"SecurityGroupKubMaster":{
         "Type":"AWS::EC2::SecurityGroup",
         "Properties":{
            "GroupDescription":{
               "Ref":"Prefix"
            },
            "SecurityGroupIngress":[
               {
                  "IpProtocol":"tcp",
                  "FromPort":"22",
                  "ToPort":"22",
                  "CidrIp":"0.0.0.0/0"
               },
               {
                  "IpProtocol":"tcp",
                  "FromPort":"8080",
                  "ToPort":"8080",
                  "SourceSecurityGroupId":{
                     "Ref":"SecurityGroupELBKubMaster"
                  }
               },
               {
                  "IpProtocol":"tcp",
                  "FromPort":"6443",
                  "ToPort":"6443",
                  "SourceSecurityGroupId":{
                     "Ref":"SecurityGroupELBKubMaster"
                  }
               }
            ],
            "VpcId":{
               "Ref":"VPCId"
            },
            "Tags":[
               {
                  "Key":"Application",
                  "Value":{
                     "Ref":"AWS::StackId"
                  }
               },
               {
                  "Key":"Name",
                  "Value":{
                     "Fn::Join":[
                        "-",
                        [
                           {
                              "Ref":"Prefix"
                           },
                           "SG-KubMaster"
                        ]
                     ]
                  }
               }
            ]
         }
      }      
```
Bitte beachten Sie die Beispiele aus dem Buch über die Sicherheitsgruppeneinstellung von etcd und Knoten. Als nächstes beginnen wir mit dem Erstellen des OpsWorks Stacks. `CustomJson` fungiert als Eingang des Chefrezepts. Wenn es irgendetwas gibt, das Chef am Anfang nicht kennt, musst du die Parameter in `CustomJson` übergeben:
```
      "OpsWorksStack":{
         "Type":"AWS::OpsWorks::Stack",
         "Properties":{
            "DefaultInstanceProfileArn":{
               "Fn::GetAtt":[
                  "RootInstanceProfile",
                  "Arn"
               ]
            },
            "CustomJson":{
               "kubernetes":{
                  "cluster_cidr":{
                     "Ref":"PrivateNetworkCIDR"
                  },
                  "version":"1.1.3",
                  "master_url":{
                     "Fn::GetAtt":[
                        "ELBKubMaster",
                        "DNSName"
                     ]
                  }
               },
               "ba":{
                  "account":{
                     "Ref":"K8sMasterBaAccount"
                  },
                  "password":{
                     "Ref":"K8sMasterBaPassword"
                  },
                  "uid":1234
               },
               "etcd":{
                  "password":{
                     "Ref":"EtcdBaPassword"
                  },
                  "elb_url":{
                     "Fn::GetAtt":[
                        "ELBEtcd",
                        "DNSName"
                     ]
                  }
               },
               "opsworks_berkshelf":{
                  "debug":true
               }
            },
            "ConfigurationManager":{
               "Name":"Chef",
               "Version":"11.10"
            },
            "UseCustomCookbooks":"true",
            "UseOpsworksSecurityGroups":"false",
            "CustomCookbooksSource":{
               "Type":"git",
               "Url":"https://github.com/kubernetes-cookbook/opsworks-recipes.git"
            },
            "ChefConfiguration":{
               "ManageBerkshelf":"true"
            },
            "DefaultOs":"Red Hat Enterprise Linux 7",
            "DefaultSubnetId":{
               "Ref":"SubnetPrivateIdA"
            },
            "Name":{
               "Ref":"Prefix"
            },
            "ServiceRoleArn":{
               "Fn::GetAtt":[
                  "OpsWorksServiceRole",
                  "Arn"
               ]
            },
            "VpcId":{
               "Ref":"VPCId"
            }
         }
      },
```
Nach dem Erstellen des Stapels können wir mit jedem Layer beginnen. Nehmen Sie den Kubernetes-Meister als Beispiel:
```
 "OpsWorksLayerKubMaster":{
         "Type":"AWS::OpsWorks::Layer",
         "Properties":{
            "Name":"Kubernetes Master",
            "Shortname":"kube-master",
            "AutoAssignElasticIps":"false",
            "AutoAssignPublicIps":"false",
            "CustomSecurityGroupIds":[
               {
                  "Ref":"SecurityGroupKubMaster"
               }
            ],
            "EnableAutoHealing":"false",
            "StackId":{
               "Ref":"OpsWorksStack"
            },
            "Type":"custom",
            "CustomRecipes":{
               "Setup":[
                  "kubernetes-rhel::flanneld",
                  "kubernetes-rhel::repo-setup",
                  "kubernetes-rhel::master-setup"
               ],
               "Deploy":[
                  "kubernetes-rhel::master-run"
               ]
            }
         }
      },
```
Die Laufliste des Chefs in dieser Schicht ist `["kubernetes-rhel::flanneld", "kubernetes-rhel::repo-setup", "kubernetes-rhel::master-setup"]` und `["kubernetes-rhel::master -run "]` im Einsatzbereich. Für die Laufliste von etcd verwenden wir `["kubernetes-rhel::etcd", "kubernetes-rhel::etcd-auth"]`, um die Bereitstellung und Authentifizierung durchzuführen. Für die Kubernetes-Knoten werden wir `["kubernetes-rhel::flanneld", "kubernetes-rhel::docker-engine", "kubernetes-rhel::repo-setup", "kubernetes-rhel::node-setup" verwenden "]` Als Laufliste im Setup-Stadium und `[" kubernetes-rhel::node-run "]` im Einsatzstadium.

Nach dem Einrichten der Ebene können wir ELB erstellen und an den Stack anschließen. Das Ziel der Gesundheitscheck für die Instanz ist HTTP: 8080 / Version. Es empfängt dann den Datenverkehr vom Port 80 und leitet ihn an den 6443-Port in den Master-Instanzen weiter und empfängt den Traffic von 8080 zum Instanzport 8080:
```
      "ELBKubMaster":{
         "DependsOn":"SecurityGroupELBKubMaster",
         "Type":"AWS::ElasticLoadBalancing::LoadBalancer",
         "Properties":{
            "LoadBalancerName":{
               "Fn::Join":[
                  "-",
                  [
                     {
                        "Ref":"Prefix"
                     },
                     "Kub"
                  ]
               ]
            },
            "Scheme":"internal",
            "Listeners":[
               {
                  "LoadBalancerPort":"80",
                  "InstancePort":"6443",
                  "Protocol":"HTTP",
                  "InstanceProtocol":"HTTPS"
               },
               {
                  "LoadBalancerPort":"8080",
                  "InstancePort":"8080",
                  "Protocol":"HTTP",
                  "InstanceProtocol":"HTTP"
               }
            ],
            "HealthCheck":{
               "Target":"HTTP:8080/version",
               "HealthyThreshold":"2",
               "UnhealthyThreshold":"10",
               "Interval":"10",
               "Timeout":"5"
            },
            "Subnets":[
               {
                  "Ref":"SubnetPrivateIdA"
               },
               {
                  "Ref":"SubnetPrivateIdB"
               }
            ],
            "SecurityGroups":[
               {
                  "Fn::GetAtt":[
                     "SecurityGroupELBKubMaster",
                     "GroupId"
                  ]
               }
            ]
         }
      }     
```
Nach dem Erstellen des Master ELB, fügen wir es an den OpsWorks Stack:
```
"OpsWorksELBAttachKubMaster":{
         "Type":"AWS::OpsWorks::ElasticLoadBalancerAttachment",
         "Properties":{
            "ElasticLoadBalancerName":{
               "Ref":"ELBKubMaster"
            },
            "LayerId":{
               "Ref":"OpsWorksLayerKubMaster"
            }
         }
      }
```
Das ist es! Die ELB von etcd ist die gleiche Einstellung, aber hören Sie `HTTP:4001/Version` als Gesundheitskontrolle und umleiten 80 Verkehr von außen zum Instanzport `4001`. Für ein detailliertes Beispiel verweisen wir auf unsere Codereferenz. Nach dem Start der zweiten Mustervorlage sollten Sie die OpsWorks Stacks, Layer, Sicherheitsgruppen, IAM und ELBs sehen können. Wenn Sie standardmäßig mit CloudFormation starten möchten, fügen Sie einfach den Ressourcentyp mit `AWS::OpsWorks::Instance` hinzu, geben Sie die Spezifikation an und Sie sind alle eingestellt.