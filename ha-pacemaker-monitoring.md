---
title: ha-pacemaker-monitoring
description: 
published: true
date: 2021-06-09T15:24:11.520Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:24:05.919Z
---

# High Availability Pacemaker Cluster Monitoring

**ClusterMon**

The ocf:pacemaker:ClusterMon resource can monitor the cluster status and trigger alerts on each cluster event. The resource agent can execute an external program to send an email notification by using the extra_options parameter.

The following script /usr/local/bin/cluster_email.sh will send an email on every resource change. You should use it for testing the resource creation only, as it will fill up your mailbox. You have been warned.

```s
#!/bin/bash
MAIL_TO="root@example.com";
SUBJECT="CLUSTER-ALERT";
MESSAGE="Cluster even triggered on $(hostname)";
echo "$MESSAGE"|mailx -s "$SUBJECT" "$MAIL_TO";
```

To create a cloned cluster resource that runs on all nodes, do the following

```s
pcs resource add clustermail ClusterMon \
  extra_options="-E /usr/local/bin/cluster_email.sh" \
  --clone
```

It’s important to understand that in this case, the script and the mailx command must be installed on all cluster nodes.

More info about the resource

```s
pcs resource describe ClusterMon
man ocf_pacemaker_ClusterMon
less /usr/lib/ocf/resource.d/pacemaker/ClusterMon
```

**MailTo**

The ocf:heartbeat:MailTo resource notifies recipients by email in the event of resource takeover. The resource agent requires the mailx command installed on all cluster nodes.

To create a resource, do the following:

```
pcs resource create clustermail MailTo \
  email="root@example.com" \
  subject="Cluster notification"
```

If required, the resource can be added to a resource group.

More info about the resource

```
pcs resource describe MailTo
man ocf_heartbeat_MailTo
less /usr/lib/ocf/resource.d/heartbeat/MailTo
```

### References

* (high_availability_add-on_reference)[https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/high_availability_add-on_reference/s1-eventnotification-haar]