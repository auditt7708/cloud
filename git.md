# Git 

**Anpassen einer Fehlerhaften commit Massage vor dem  push zum  remote System**

> Hier bietet sich `--amend` an 
> Syntax: `git commit --amend`

> Beispiel: `git commit --amend -m "New commit message"`

Hinweis: Bevor das Kommando abgesetzt wird muss sichergestellt sein, dass 

**Ändern der remote URL(URI) bei git für remote repository**
Git remote set-url wird benutzt um die remote url zu ändern
Example:

`git remote set-url origin https://github.com/USERNAME/REPOSITORY_xyz.git`

Dabei ist https://github.com/USERNAME/REPOSITORY_xyz.git das neue Remote repo
Zum Überprüfen kann `git remote -v` benutzt werden. 


**Kopeiren einer Datei oder Verzeichnisses von einem branch zu einem anderen**
Kopiren von einer oder zwei Datein von einem branch zum andern. Hier von dev

`git checkout dev -- path/to/your/file.`

Kopiren von einem Verzeichnis im Bransch zu einen anderen Branch. Hier von dev

`git checkout dev -- path/to/your/folder`

Kopiren von Datein und Verzeichnissen von einem commit hash zu einem anderen branch.

`git checkout <commit_hash> <relative_path_to_file_or_dir>`
