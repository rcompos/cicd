# Ansible for CI/CD

### Description
Provision Continuous Integration/Continuous Delivery (CI/CD) build servers.

The playbook will install Docker CE, configure the LVM thin storage pool, install Docker Compose will start the service containers.

Playbooks are included for the following:

* cicd-master
* cicd-agent
* cicd-jenkins

### Requirements
The target VM's are expected to be freshly created CentOS 7 virtual machines.

The target VM's should have an additional virtual disk attached (i.e. /dev/sdb).

All services are run as Docker containers.

---
### Deploy Jenkins Build Master
<pre># ansible-playbook -l <i>target</i> -i hosts/cicd-ctec playbooks/cicd-master.yml -k</pre>

### Deploy Jenkins Build Agent
<pre># ansible-playbook -l <i>target</i> -i hosts/cicd-ctec playbooks/cicd-agent.yml -k</pre>
    
### Deploy Multi Jenkins
<pre># ansible-playbook -l <i>target</i> -i hosts/cicd-ctec playbooks/cicd-jenkins.yml -k</pre>

---
### group_vars:
Environmental variables are used to specify parameters at deploy time.

**Universal**
- block_device: "/dev/sdb"
- compose_home: "/root"
- compose_dir: "cicd"

---
### Admin Interfaces:
The admin interfaces are available at:

* Jenkins Master             http://\<build_master\>:8080
* Gogs Git Repo                http://\<build_master\>:3000
* Nexus Repository Manager    http://\<build_master\>:8181
* cAdvisor Resource Monitor     http://\<build_master\>:8089
