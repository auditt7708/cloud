---
title: puppet4-basics-symlinks
description: 
published: true
date: 2021-06-09T15:56:45.819Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:56:40.809Z
---

Bei der Deklaration von Dateiressourcen, die Symlinks sind, verwenden Sie `ensure => link` und legen Sie das Zielattribut wie folgt fest:


```
file {../puppet/e../puppet/ph../puppet/c../puppet/php.ini':
  ensure => link,
  target =>../puppet/e../puppet/php.ini',
}
```
