Upgrade icinga
============

###Ubuntu/Debian mit mysql db

1.  Akkuelle Version von icinga2 Notieren `icinga2 version $( icinga2 --version | grep "^icinga2" | cut -d":" -f  2 | sed 's\)\\g' ) `
2. Nach dem Distributions Upgrade die versionen vergleichen für jedes minor Update muss je ein schema update gemacht werden .
3. Schema upgrade durchführen hier Zielversion 2.6.0 `mysql -u root -p icinga < /usr/share/icinga2-ido-mysql/schema/upgrade/2.6.0.sql`

`-p icinga` ist die Zieldatenbank PW ist im 



INFO
Für `MySQL Server` sind unter `/usr/share/icinga2-ido-mysql/schema/upgrade/` alle Datein für ein upgrade zu finden 

ToDo List

- [ ] Icinga2 Upgrade
    - [ ] Version Notieren
    - [] Version vergleichen
    - [ ] je minor Update ein Schema Upgrade durchführen.

