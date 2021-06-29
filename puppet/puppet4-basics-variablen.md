---
title: puppet4-basics-variablen
description: 
published: true
date: 2021-06-09T15:56:52.729Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:56:47.745Z
---

Variablen müssen immer in geschweiften klammern sein z.b. '${PHP7ENV}.conf'

Beispiel für eine Server Quelle : 

```
source => "puppe../puppet///modul../puppet/webserv../puppet/${brand}.conf",
```

Puppet`s Parser muss immer unterscheiden können was ein charachter ist und was ein teil einer Variablen ist die geschweiften klammern machen es für den Parser eindeutig