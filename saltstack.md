# Saltstack

In der Datei `/etc/salt/grains` sind eigene Variablen definiert

Begriffe: 

* Minions
* Pillars
* 


## Administration

Status eines Benutzers ausgeben

`sudo salt '*' state.sls user-jenkins`

Service neu Starten

`sudo salt-call service.restart selenium-node`

SLS Datei ausführen

`sudo salt  $(hostname -s) state.show_sls user-jenkins`

> Es wird hier vorausgesetzt, das z.b im Verzeichnis _/srv/salt_ die `*.sls` Datein stehen. Bei diesem Beispiel ist es die Datei `user-jenkins.sls`
> Wenn keine `*.sls` für die Abfrage definiert ist sollte folgender fehler angezigt werden `- No matching sls found for 'user-tobkern' in env 'base'`

Grains im json formart ausgeben

`salt 'minion-node' grains.items --out=json`

Bestimte Grains ausgeben

`salt 'minion-node' grains.item id zmqversion kernel os_family --out=pprint`

Systeme via Grain auswählen

`sudo salt -G 'os_family:RedHat' test.ping`

## Saltstack neues rezept erstellen

## Saltstack Debunging

`salt-call --local pkg.group_list -l debug`

## Eigene grains defieniren

Ein Minimalbeispiel eigener grains ist, in /etc/salt/grains ein key: value-Paar zu setzen:

```
sed 's/^[ ]*//' <<EOF | sudo tee -a /etc/salt/grains
SLA: 24/7-Economie
EOF
```

Danach solte mit:

`salt -G 'SLA:24/7-Economie' test.ping --out=pprint`

die passenden Systeme selectierbar sein.

In der Praxis werden gerne mehrere werte für eine Variable zu setzen:

`sudo salt 'minion-node' grains.setval roles  "['server', 'developer']"`

Vorausgeset wir häten ein Variable `sla: platinium247` defeniert

Mit folgender ausgabe:

```s
{
    "vmd36612": {
        "id": "vmd36612",
        "sla": "platinium247"
    }
}
````

Und möchten nun z.b mit Python den ausgabe parsen.
Dazu können wir die json wert von `sla` auswerten.
Bei mehren werten muss man nur Überlegen wie weit man in der strucktur vorwertz gehen muss um auf die Ebene zum Wert zu kommen

`salt 'vmd36612' grains.item id  sla --out=json | python -c 'import sys, json; print json.load(sys.stdin)["vmd36612"]["sla"]'`

Wenn wir z.b nun unser Beispile erweitern

```s
{
    "vmd36612": {
        "id": "vmd36612",
        "sla": "platinium247"
        "New-Cloud-Systems": {
            Platform: "aws"
            Storage: "caph"
        }
    }
}
````

## Saltstack Pillars verwenden

Da grains allen Minins zugänlich sind sollte diese nicht für z.B Benutzerpasswörter oder Lizenzschlüssel verwendung finden.
Dafür gibt es die pillars bei Saltstack.

Nehmen wir an, das 


## Saltstack master of masters Einrichten

### Quellen

* [Automatisierung mit SaltStack](https://www.informatik-aktuell.de/entwicklung/methoden/gut-gewuerzt-automatisierung-mit-saltstack.html)