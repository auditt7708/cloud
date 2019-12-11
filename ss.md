# Linux ssexamples

listen and exemled connections

`ss -u -a`

`ss -tulpe`

Connaction statics

`ss -s`

established connect on ipv6

`ss -t6 state established`

filter for destination net

`ss dst 70.134.160.252/16`

filter for destination port

`ss dst 70.134.160.252:1335`

dport only

`ss -nt dport = :80`
