<<<<<<< HEAD
# Git 

**Anpassen einer Fehlerhaften commit Massage vor dem  push zum  remote System**

> Hier bietet sich `--amend` an 
> Syntax: `git commit --amend`

> Beispiel: `git commit --amend -m "New commit message"`

Hinweis: Bevor das Kommando abgesetzt wird muss sichergestellt sein, dass 

**Ändern der remote URL(URI) bei git für remote repository**
=======
# Git

**Begriffe**

- Git directory = Lokaller clone des Repos
- Git working tree = pull vom Git directory
- Git Stag = Lokalle änderungen

Anpassen einer Fehlerhaften commit Massage vor dem  push zum  remote System

Hier bietet sich `--amend` an
Syntax: `git commit --amend`
Beispiel: `git commit --amend -m "New commit message"`

## Ändern der remote URL(URI) bei git für remote repository

>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
Git remote set-url wird benutzt um die remote url zu ändern
Example:

`git remote set-url origin https://github.com/USERNAME/REPOSITORY_xyz.git`

Dabei ist https://github.com/USERNAME/REPOSITORY_xyz.git das neue Remote repo
<<<<<<< HEAD
Zum Überprüfen kann `git remote -v` benutzt werden. 


**Kopeiren einer Datei oder Verzeichnisses von einem branch zu einem anderen**
Kopiren von einer oder zwei Datein von einem branch zum andern. Hier von dev

`git checkout dev -- path/to/your/file.`

Kopiren von einem Verzeichnis im Bransch zu einen anderen Branch. Hier von dev

`git checkout dev -- path/to/your/folder`

Kopiren von Datein und Verzeichnissen von einem commit hash zu einem anderen branch.

`git checkout <commit_hash> <relative_path_to_file_or_dir>`
=======
Zum Überprüfen kann `git remote -v` benutzt werden.

## Kopieren einer Datei oder Verzeichnisses von einem branch zu einem anderen

Hier von dev

`git checkout dev -- path/to/your/file.`

## Kopieren von einem Verzeichnis im Bransch zu einen anderen Branch. Hier von dev

`git checkout dev -- path/to/your/folder`

## Kopieren von Datein und Verzeichnissen von einem commit hash zu einem anderen branch

`git checkout <commit_hash> <relative_path_to_file_or_dir>`

## Eintragungen bereitgesteller Änderungen Herausnehmen

`git reset HEAD DATEI`
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
