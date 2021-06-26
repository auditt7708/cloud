---
title: ruby
description: 
published: true
date: 2021-06-09T16:03:55.667Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:03:50.855Z
---

# Installation Distributions unabhängig

Centos7 Abhängigkeiten

```s
yum install gcc-c++ patch readline readline-devel zlib zlib-devel \
   libyaml-devel libffi-devel openssl-devel make \
   bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
```

## Installation

```s
# echo progress-bar >> ~/.curlrc && \
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - && \
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - && \
curl -L get.rvm.io | bash -s stable && \
source /etc/profile.d/rvm.sh && \
rvm reload && \
rvm requirements run && \
rvm install 2.6 && \
rvm docs generate-ri && \
rvm use 2.6 --default
```

* [RVM Installation](https://rvm.io/rvm/install)

## Testing

* [Capybara](http://teamcapybara.github.io/capybara/)

## Rake

**Links:**

*  http://rake.rubyforge.org/