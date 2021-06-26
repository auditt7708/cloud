---
title: mysql-cluster-ms
description: 
published: true
date: 2021-06-09T15:40:48.266Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:40:43.281Z
---

# Mysql Cluster MS

| User | Zwek | Passord |
| :---: | :---: | :---: |
|repuser| Replikations user | tigris1234 |

Anlegen eines benutzers zur Replikation:

```sql
GRANT REPLICATION SLAVE ON *.* TO 'repuser'@'%' IDENTIFIED BY 'tigris1234';
FLUSH PRIVILEGES;

````

**Quelle:**

* [Mysql master slave Cluster](https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql)