---
title: ps
description: 
published: true
date: 2021-06-09T15:46:15.062Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:46:09.853Z
---

# ps Process Manager

Nach user und mit ASCII art Process

`ps -f -u wwwrun,postfix`

erweiterte Informationen

`ps -eF` `ps -ef`

oder

`ps aux`

herauszufinden ob einprogramm läuft

`ps -fC einprogramm`

und

`ps -fC einprogramm,nocheinprogramm,undnocheins`

Einen Prozessbaum anzeigen

`ps -ejH`

und

`ps axjf`

Benutzer Prozesse ausgeben

`ps -fU USER`

oder

`ps -fu $USERID`

Alle proccesse die als root laufen ausgeben:

`ps -U root -u root`

Prozesse einer Gruppe ausgeben

`ps -fG Gruppe`

oder

`ps -fG $GID`

Prozess via pid anzeigen lassen

`ps -fp $PID`

Prozess via ppid anzeigen lassen

`ps -f --ppid $PPID`

Prozess Baum anzeigen

`ps -e --forest`

Prozess Baum eines bestimmten Prozesses anzeigen

`ps -f --forest -C ProcessDeamonName`

Prozess mit Threads ausgeben

`ps -fL -C ProcessDeamonName`

Formart der Ausgabe bestimmen
Auflistung der Formate:

`ps L`

Beispiel

`ps -eo pid,ppid,user,cmd` oder  `ps -p 1154 -o pid,ppid,fgroup,ni,lstart,etime`

Suchen des Prozess-namenes via PID

`ps -p $PID -o comm=`

Mutter und Kinds Process ausgeben

`ps -C ProcessDeamonName -o pid=`

Ressourcen Nutzung ausgeben

`ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head`

oder

`ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head`

PID eines Precess der nicht reagiert

`ps -A | grep -i stress`

systemd csets anzeigen

`ps xawf -eo pid,user,cgroup,args`
