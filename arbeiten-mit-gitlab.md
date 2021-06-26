---
title: arbeiten-mit-gitlab
description: 
published: true
date: 2021-06-09T14:57:20.241Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:57:15.099Z
---

# Arbeiten mit Gitlab

Abgesehen von der Umstellung auf SSH können Sie auch weiterhin HTTPS verwenden, wenn Sie nichts dagegen haben, Ihr Passwort in Klartext zu speichen.
Fügen Sie dies in Ihre `~/.netrc` ein und es wird nicht nach Ihrem Benutzernamen/Passwort gefragt (zumindest unter Linux und Mac):

```sh
machine github.com
       login <user>
       password <password>
```

## .gitlab-ci.yml Benutzen

## Quellen

* [implementing-gitlab-ci-dot-yml/](https://about.gitlab.com/2015/06/08/implementing-gitlab-ci-dot-yml/)
