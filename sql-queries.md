---
title: sql-queries
description: 
published: true
date: 2021-06-09T16:05:53.011Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:05:47.981Z
---

# MySQL/Mariadb

Benutzer auflisten

`SELECT User, Host FROM mysql.user;`

oder für den gesamten Status des Benutzers

`ELECT User, Host, Password, password_expired FROM mysql.user;`
