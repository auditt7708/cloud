Meldung im Syslog: `block drbd0: Split-Brain detected, dropping connection!`
```
root@server2:~# drbdadm disconnect drbd0
root@server2:~# drbdadm secondary drbd0
root@server2:~# drbdadm -- --discard-my-data connect drbd0
```


wenn dann noch auf der `Primary Node` im `Stand-Alone` Modus fest steckt folgendes Kommando hinter auf der `Primary Node`:
```
drbdadm connect drbd0
```

