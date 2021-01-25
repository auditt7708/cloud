# Ceph Fehler Behebung

## Kommandos zur fehlerbehebung

**Cluster Übersicht**

`ceph -s`

**Logs ausgeben**

`ceph crash ls`

**Filesystem status**

`ceph fs Status`

**Inkonsistente pg ausgeben**

`ceph pg ls inconsistent`

**Details zu PG Fehlern**

`ceph health detail`

**Inkonsistente pg ausgeben in json und verarbeiten**

`ceph pg ls inconsistent -f json | jq -r .pg_stats[].pgid`

>  jq muss installiert sein

**PG id Reparatur**

`ceph pg repair`

**Fehler ins Archiv verschieben**

`ceph crash archive-all`

