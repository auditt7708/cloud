Icinga2 Konfiguration
===

### Service Monitoring

In der Datei `constants.conf` im Verzeichnis **/etc/icinga2** werden die Plugins zum monitoring definiert.
Auf einem [Ubuntu OS](../ubuntu) kann man die plugins unter **/usr/lib/nagios/plugins** finden

In der Documentation von [icinga2](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/chapter/service-monitoring) wird leider von einer anderen Einrichtung ausgegangen :
```
# su - icinga -s /bin/bash
$ /opt/monitoring/plugins/check_snmp_int.pl --help
```

Hier wird angenomen , dass wir eigene Plugins unter `/opt/monitoring/plugins/` verwenden was wir aber noch nicht am Anfang nutzen und es für die Meisten aufgaben unter `/usr/lib/nagios/plugins` eine lösung vorhanden ist . 

Folgede Plugins kann man unter `/usr/lib/nagios/plugins` bereits finden .

```
check_apt      check_disk_smb  check_hpjd          check_ldap         check_nagios    check_overcr     check_simap  check_udp
check_breeze   check_dns       check_http          check_ldaps        check_nntp      check_pgsql      check_smtp   check_ups
check_by_ssh   check_dummy     check_icmp          check_load         check_nntps     check_ping       check_snmp   check_users
check_clamd    check_file_age  check_ide_smart     check_log          check_nt        check_pop        check_spop   check_wave
check_cluster  check_flexlm    check_ifoperstatus  check_mailq        check_ntp       check_procs      check_ssh    negate
check_dbi      check_fping     check_ifstatus      check_mrtg         check_ntp_peer  check_real       check_ssmtp  urlize
check_dhcp     check_ftp       check_imap          check_mrtgtraf     check_ntp_time  check_rpc        check_swap   utils.pm
check_dig      check_game      check_ircd          check_mysql        check_nwstat    check_rta_multi  check_tcp    utils.sh
check_disk     check_host      check_jabber        check_mysql_query  check_oracle    check_sensors    check_time
```

Hier ein funktionierendes Beispiel :
```
su - icinga -s /bin/bash

/usr/lib/nagios/plugins/check_dns -H 192.168.4.14
DNS OK: 0,087 seconds response time. 192.168.4.14 returns rp4.example.com.|time=0,087306s;;;0,000000
```

#### Plugins Testen und Benutzen 


### Zonen
Zonen dienen unter [ICINGA2](../icinga2) als logische Unterscheidung der Zuständigkeiten bei einem Cluster.
Default wird der Hostname als ZoneName gesetzt in der Datei `constants.conf` 

Quellen: 
[Service Monitoring](https://docs.icinga.com/icinga2/latest/doc/module/icinga2/chapter/service-monitoring)
[]()
[]()
[]()
[]()


Icinga Administration
===
Daly Operationen zum [Icinga2](../icinga2) Monitorring

### Upgrades
Vor einem Update/Upgrade muss immer geprüft werden op auch ein  Major [Icinga2](../icinga2) vorgenommen wird.

### Ubuntu/Debian mit mysql db

1.  Akkuelle Version von icinga2 Notieren `icinga2 version $( icinga2 --version | grep "^icinga2" | cut -d":" -f  2 | sed 's\)\\g' ) `
2. Nach dem Distributions Upgrade die Versionen vergleichen für jedes Minor Update muss je ein Schema Update gemacht werden .
3. Schema upgrade durchführen hier Zielversion 2.6.0 `mysql -u root -p icinga < /usr/share/icinga2-ido-mysql/schema/upgrade/2.6.0.sql`

`-p icinga` ist die Zieldatenbank PW ist im 

**INFO**
Für `MySQL Server` sind unter `/usr/share/icinga2-ido-mysql/schema/upgrade/` alle Datein für ein upgrade zu finden 

**ToDo  bei einem Upgrade**

- [ ] Icinga2 Upgrade
    - [ ] Version Notieren
    - [] Version vergleichen
    - [ ] je minor Update ein Schema Upgrade durchführen.

