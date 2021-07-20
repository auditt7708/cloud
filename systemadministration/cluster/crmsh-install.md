---
title: crmsh-install
description: 
published: true
date: 2021-06-09T15:03:01.518Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:02:56.566Z
---

# Debian 8

## CentOS 7

Repository bei Centos kann das packet auch `clustershell` heißen.

```sh
yum install -y yum-utils
yum-config-manager http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-7/network:ha-clustering:Stable.repo
yum install -y e2fsprogs
yum install -y quota
yum install -y xfsprogs
yum install -y cifs-utils
yum install -y resource-agents
yum install -y crmsh
yum install -y crmsh-test

```
