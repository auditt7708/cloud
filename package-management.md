| Task | apt Debian | zypp | yun/dnf | pacman | 
| :---: | :---: | :---: | --- | --- |
|**Managing software**|||||
|Install new software from package repository|apt-get install pkg|zypper install pkg|yum install pkg|pacman -S pkg|
|Install new software from package file|dpkg -i pkg|zypper install pkg|yum localinstall pkg|pacman -U pkg|
|Update existing software|apt-get install pkg|zypper update -t package pkg|yum update pkg|pacman -S pkg|
|Remove unwanted software|apt-get remove pkg|zypper remove pkg|yum erase pkg|pacman -R pkg|
|**Updating the system**|||||
|Update package list|apt-get update aptitude update|zypper refresh|yum check-update|pacman -Sy|
|Update system|apt-get upgrade aptitude safe-upgrade|zypper update|yum update|pacman -Su|
|**Searching for packages**|||||
|Search by package name|apt-cache search pkg|zypper search pkg|yum list pkg|pacman -Ss pkg|
|Search by pattern|apt-cache search pattern|zypper search -t pattern pattern|yum search pattern|pacman -Ss pattern|
|Search by file name|apt-file search path|zypper wp file|yum provides file|pacman -Qo file|
|List installed packages|dpkg -l|zypper search -is|rpm -qa|pacman -Q|
|**Configuring access to software repositories**|||||
|List repositories|cat /etc/apt/sources.list|zypper repos|yum repolist|cat /etc/pacman.conf|
|Add repository|(edit /etc/apt/sources.list)|zypper addrepo path name|(add repo to /etc/yum.repos.d/)|(edit /etc/pacman.conf)|
|Remove repository|(edit /etc/apt/sources.list)|zypper removerepo name|(remove repo from /etc/yum.repos.d/)|(edit /etc/pacman.conf)|


Lösungen

[aptly](https://www.aptly.info/) Debian repo management soll aber auch bald auch RPM können.
[pulp](http://pulpproject.org/) kann nebem RPM auch Python Puppet Docker und OSTree software packte Automatisch verwalten
[ostree](https://ostree.readthedocs.io/en/latest/#projects-using-ostree) high performance continuous delivery/testing system für RPM bald auch DEB
[Flatpak](http://flatpak.org/apps.html)  Installiert Applikationen Distribution unabhängig