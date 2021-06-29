---
title: cp
description: 
published: true
date: 2021-06-09T15:02:54.684Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:02:49.668Z
---

# Kopie von Dateien oder Verzeichnissen

**Dateien/Ordner ausschließen**
`shopt -s extglob`
und
`cp -av /QUELLE/!(Datei1.txt|Festplattenabbild*|Ordner/Unterordner1) /ZIEL/`
