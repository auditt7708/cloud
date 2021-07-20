---
title: bacula
description: 
published: true
date: 2021-06-09T14:58:05.199Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:57:59.823Z
---

# Bacula

```sh
Pool {
  Name = Full
  Maximum Volumes = 4
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 3 Months
  Catalog Files = yes
  UseVolumeOnce = no
}
Pool {
  Name = Inc
  Maximum Volumes = 2
  Pool Type = Backup
  Recycle = yes
  AutoPrune = yes
  Volume Retention = 12 hours
  Catalog Files = yes
  UseVolumeOnce = no
}

JobDefs {
  Name = "Backup"
  Type = Backup
  Level = Incremental
  FileSet = "Full Set"
  Schedule = "Daily"
  Storage = Tape
  Messages = Standard
  Priority = 50
  Write Bootstrap = "/var/lib/bacula/%c.bsr"
  Pool = Full
}

Job {
  Name = "Backup Offsite"
  JobDefs = "Backup"
  Client = bacula-fd
  Incremental Backup Pool = Inc
  Full Backup Pool = Full
  Priority = 15
}
```

## Quellen

* [bacula](https://www.21x9.org/tag/bacula/)
