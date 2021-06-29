---
title: git
description: 
published: true
date: 2021-06-09T15:22:20.058Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:22:14.805Z
---

# Git Allgemein Infos

Begriffe

- Git directory = Lokaler clone des Repos
- Git working tree = pull vom Git directory
- Git Stag = Lokalle änderungen

**Anpassen einer Fehlerhaften commit Massage vor dem  push zum  remote System.**

Hier bietet sich `--amend` an
Syntax: `git commit --amend`
Beispiel: `git commit --amend -m "New commit message"`

Git remote set-url wird benutzt um die remote url zu ändern

`git remote set-url origin https://github.com/USERNAME/REPOSITORY_xyz.git`

Dabei ist https://github.com/USERNAME/REPOSITORY_xyz.git das neue Remote repo

Zum Überprüfen kann `git remote -v` benutzt werden.

**Kopieren von einer oder zwei Datein von einem branch zum andern. Hier von _dev_.**

`git checkout dev -- path/to/your/file.`

**Kopiren von Datein und Verzeichnissen von einem commit hash zu einem anderen branch.**

`git checkout <commit_hash> <relative_path_to_file_or_dir>`

Zum Überprüfen kann `git remote -v` benutzt werden.

**Kopieren einer Datei oder Verzeichnisses von einem branch zu einem anderen.**

`git checkout dev -- path/to/your/file.`

**Kopieren von einem Verzeichnis im Bransch zu einen anderen Branch.**

`git checkout dev -- path/to/your/folder`

**Kopieren von Datein und Verzeichnissen von einem commit hash zu einem anderen branch.**

`git checkout <commit_hash> <relative_path_to_file_or_dir>`

## Eintragungen bereitgesteller Änderungen Herausnehmen

`git reset HEAD DATEI`

## Git Konfiguration

## Git bransh

**Pullen von eine bransh.**

`git pull <remote> <branch>`

**Bransh festlegen.**

`git branch --set-upstream-to=origin/<branch> test`


* [git-submodules](git-submodules)