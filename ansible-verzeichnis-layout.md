# Ansible Verzeichnis layout

```sh
production                # inventory file for production servers
staging                   # inventory file for staging environment also entwicklung
                          # am ende kommt alles in die production Systeme

group_vars/
   all                    # Überschreiben von variablen für alle Gruppen Variablen
   group1                 # here we assign variables to particular groups
   group2                 # ""
host_vars/
   all                    # Überschreiben von Variablen für alle Hosts
   hostname1              # if systems need specific variables, put them here
   hostname2              # ""

library/                  # if any custom modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

Der Vorteil dieser normalen Struktur ist, dass Sie noch relativ selbsterklärend ist. Leider ist hier keine klare Trennung swichen der Produktiven benutzung und Entwicklung zu erkennen der muss hier mit Hilfe von [git](../git) und verschiedener brunches erreicht werden, die man aber nicht automatisch erkennen kann.

## Quelle

* [playbooks_best_practices](http://docs.ansible.com/ansible/playbooks_best_practices.html)
