---
title: user-und-gruppen
description: 
published: true
date: 2021-06-09T16:09:16.336Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:09:11.166Z
---

# User und Gruppen

## Standart User

adm-kvm
docker
adm-libvirt
sshmgr
ansible
rsshadm

## Standart Gruppen

adm-kvm
webvirtmgr
gitlab-runner
ssh-opt
libvirtd

User für ssh verbindungen ohne password rsshadm

```s
sudo mkdir -p  /home/rsshadm/.ssh
sudo chmod 700 /home/rsshadm/.ssh
sudo chmod 0600 /home/rsshadm/.ssh/authorized_keys
sudo chown -R rsshadm:rsshadm /home/rsshadm/.ssh
```