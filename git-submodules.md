# Arbeiten mit Repositorys, die Submodule enthalten

**Klonen eines Repositorys, das Submodule enthält**

`git clone --recursive [URL to Git repo]`


**Submodule eines Repos laden**

`git submodule update --init`

**wenn verschachtelt**

`git submodule update --init --recursive`


**Mehrere Submodule gleichzeitig herunterladen**

**download von bis zu 8 submodules auf einmal**

```
git submodule update --init --recursive --jobs 8
git clone --recursive --jobs 8 [URL to Git repo]
```
**kurze version**

`git submodule update --init --recursive -j 8`

**Pull mit submodulen**

Pull von allen Änderungen im Repo, einschließlich Änderungen in den Submodulen

`git pull --recurse-submodules`

**pull von allen Änderungen in submodulen**

`git submodule update --remote`


**Ausführen eines Befehls auf jedem Submodul**

`git submodule foreach 'git reset --hard'`

wenn verschachtelt

`git submodule foreach --recursive 'git reset --hard'`

Repositories mit Submodulen erstellen

**Hinzufügen eines Submoduls zu einem Git-Repository und Verfolgen eines Zweigs

Submodul hinzufügen und Master-Zweig definieren als den,  man verfolgen möchte.**

`git submodule add -b master [URL to Git repo]`
`git submodule init`

**hinzugefügte submodule mit commits und dem working tree wie mit dem branch angegeben commiten**

`git submodule update --remote`

**Hinzufügen eines Submoduls und Verfolgen von Commits**

`git submodule add [URL to Git repo]`
`git submodule init`

**Aktualisieren, welches Commit Sie verfolgen**

```
# update submodule in the master branch
# skip this if you use --recurse-submodules
# and have the master branch checked out
cd [submodule directory]
git checkout master
git pull

# commit the change in main repo
# to use the latest commit in master of the submodule
cd ..
git add [submodule directory]
git commit -m "move submodule to latest commit in master"

# share your changes
git push
```

```
# another developer wants to get the changes
git pull

# this updates the submodule to the latest
# commit in master as set in the last example
git submodule update
```

Löschen eins Submodul aus einem Repository.
Derzeit bietet Git keine Standardschnittstelle zum Löschen eines Submoduls. Um ein Submodul zu entfernen z.B _mymodule_ , muss folgendes gemacht werden :

```
Git-Submodul deinit -f - mymodule
rm -rf .git / modules / mymodule
git rm -f mymodule
```

Quellen

* [submodules_pulling](https://www.vogella.com/tutorials/GitSubmodules/article.html#submodules_pulling)