# Ansible Alternatives Verzeichnis layout

```sh
inventories/
   production/
      hosts               # inventory file for production servers
      group_vars/
         group1           # here we assign variables to particular groups
         group2           # ""
      host_vars/
         hostname1        # if systems need specific variables, put them here
         hostname2        # ""

   staging/
      hosts               # inventory file for staging environment
      group_vars/
         group1           # here we assign variables to particular groups
         group2           # ""
      host_vars/
         stagehost1       # if systems need specific variables, put them here
         stagehost2       # ""

library/
filter_plugins/

site.yml
webservers.yml
dbservers.yml

roles/
    common/
    webtier/
    monitoring/
    fooapp/
```

## Quelle

* [playbooks_best_practices](http://docs.ansible.com/ansible/playbooks_best_practices.html)