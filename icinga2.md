Upgrade icinga
============

Ubuntu/Debian

1.  Akkuelle Version von icinga2 Notirren ```icinga2 version $( icinga2 --version | grep "^icinga2" | cut -d":" -f  2 | sed 's\)\\g' ) ```
2. 