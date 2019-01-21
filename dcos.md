# [Productive Installation](https://docs.mesosphere.com/1.12/installing/production/deploying-dcos/installation/)

# Hardware vorausetzungen

## Master nodes

The table below shows the master node hardware requirements:
Minimum 	Recommended
Nodes 	        1* 	        3 or 5
Processor 	4 cores 	4 cores
Memory 	        32 GB RAM 	32 GB RAM
Hard disk 	120 GB 	        120 GB

## Einrichtung 
Verzeichnis erstellen unter /opt/

`mkdir -p genconf`

### Erstellen eines Skripts zur IP ertsellung
```sh
#!/usr/bin/env bash
set -o nounset -o errexit
export PATH=/usr/sbin:/usr/bin:$PATH
echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
```



## Agent nodes

The table below shows the agent node hardware requirements.
	      Minimum 	    Recommended
Nodes 	      1             6 or more
Processor     2 cores 	    2 cores
Memory 	      16 GB RAM     16 GB RAM
Hard disk     60 GB 	    60 GB

# Ansible
* [DCOS Ansible](https://github.com/dcos/dcos-ansible)