---
title: iptables
description: 
published: true
date: 2021-06-09T15:25:59.991Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:25:54.849Z
---

# Short Cuts

iptables Reseten

`iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X`

iptabels block ip

`iptables -A INPUT -s 64.39.102.147 -j DROP`
