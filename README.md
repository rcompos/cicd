# cDVR-CICD

<pre>
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (    clouds float on blue sky         )
 (          images of what once was      )
  (               illuminated           )
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          \   ^__^
           \  (oo)\_______
              (__)\       )\/\
                  ||----w |
                  ||     ||
</pre>

### Description

Ansible playbooks to provision CloudDVR Continuous Integration/Continuous Delivery (CI/CD) build servers running on virtual machines.  Implements Jenkins as a Docker container.  Multiple roles are supplied to provision a master build server, build agent server and multiple Jenkins server.

* Master Build Server
* Build Agent
* Multiple Jenkins

When run against a target VM running CentOS 7 or RedHat 7, the playbook will install Docker CE, configure the LVM thin storage pool, install Docker Compose and potentially start containers running Jenkins, Gogs, Nexus, etc.

---
### Requirements

The target VM's are expected to be freshly created CentOS 7 or RedHat 7 virtual machines.

The target VM's should have an additional virtual disk attached.  This disk is expected to be named _/dev/sdb_.  This disk should be unformatted.  The ansible playbook will run a script to use LVM to create a thin storage pool.  To specify a different disk device name, supply it as a command-line argument (*-e 'block_device=/dev/sdc'*)

The following are recommendedations for the various server roles.

  

|                   | **cDVR Build Master**          |
|:------------------|:-------------------------------|
| OS                | CentOS 7.4 or RedHat 7.4       |
| CPU               | 8 cores                        |
| RAM               | 16GB                           |
| HD                | 300GB (/dev/sdb)               |


  

|                   | **cDVR Build Agent**           |
|:------------------|:-------------------------------|
| OS                | CentOS 7.4 or RedHat 7.4       |
| CPU               | 8 cores                        |
| RAM               | 16GB                           |
| HD                | 100GB (/dev/sdb)               |


 

|                   | **cDVR Build Multi Jenkins**   |
|:------------------|:-------------------------------|
| OS                | CentOS 7.4 or RedHat 7.4       |
| CPU               | 8 cores                        |
| RAM               | 16GB                           |
| HD                | 300GB (/dev/sdb)               |

---

### Configuration

The following pre-configured build stacks are included.

**cDVR Build Master**  
Master build server with entire CICD stack, including Jenkins, Gogs and Nexus.

| Component         | Version     | Port     | Volume      |
|-------------------|-------------|----------|-------------|
| Docker            | 17.09.0-ce  |          | -           |
| Jenkins           | 2.6.30      | 8080     | jenkins-vol |
| Gogs              | 0.11.29     | 3000     |    gogs-vol |
| MariaDB           | 10.3.2      | 3306     | mariadb-vol |
| Nexux             | 3.6.0       | 8181     |   nexus-vol |
| cAdvisor          | 0.27.1      | 8089     | -           |


**cDVR Build Agent**  
Designed for use as Jenkins Build Agent.  This machine runs Docker with non-network unix socket.  This allow the VM to act as a Jenkins Build Agent to a master running the Docker plugin.

| Component         | Version     | Port     |
|-------------------|-------------|----------|
| Docker            | 17.09.0-ce  | 4243     |
| cAdvisor          | 0.27.1      | 8089     |


**cDVR Build Multi Jenkins**  
Multiple Jenkins instances listening on range of ports.

| Component         | Version     | Port     | Volume       |
|-------------------|-------------|----------|--------------|
| Docker            | 17.09.0-ce  |          | -            |
| Jenkins           | 2.6.30      | 8080     | jenkins0-vol |
| Jenkins           | 2.6.30      | 8081     | jenkins1-vol |
| Jenkins           | 2.6.30      | 8082     | jenkins2-vol |
| Jenkins           | 2.6.30      | 8083     | jenkins3-vol |
| Jenkins           | 2.6.30      | 8084     | jenkins4-vol |
| Jenkins           | 2.6.30      | 8085     | jenkins5-vol |
| cAdvisor          | 0.27.1      | 8089     | -            |

---
### Usage

**Provisioning**  

1. Clone repo to Ansible control host.

  `# git clone https://github.webapps.rr.com/MBO/cdvr-cicd.git`

2. Change to repo dir.

  `# cd cdvr-cicd`

3. Change to hosts dir.

  `# cd hosts`

4. Choose a group to deploy to.  Edit inventory file for target group.  Add target hostname(s) under the following sections.

  `[cdvr-cicd-ctec]`  

5. Edit appropriate group variables file.  Update parameters as needed for versions of Docker, Compose, Jenkins, etc.

6. Run ansible-playbook commands from the top level directory of the repo (i.e. in same directory as the README.md).  The command should be executed as user _root_.  

  <pre># ansible-playbook -l <i>hostname</i> -i hosts/<i>hostfile</i> playbooks/<i>playbook</i></pre>

  | Variable   | Description                                          |
  |------------|-----------------------------------------------------:|
  | hostname   | Target of deployment (must be in hostfile)           |
  | hostfile   | Ansible inventory file                               |
  | playbook   | Ansible playbook file                                |
  | pw_file    | Ansible vault password file                          |


**Container Administration**

Container may be managed with docker-compose preferentially, but may also be managed with Docker commands directly.

_All docker-compose commands must be run from the directory where docker compose files are located or run with full path._

`# cd /root/cdvr`

* Start Services  
    `# docker-compose up`  

* Status Services  
    `# docker-compose ps`  

* Stop Services  
    `# docker-compose down`  
    
* Show logs  
    `# docker-compose logs`  
    
* Show processes  
    `# docker-compose top`  
    
**Backup Docker Volumes**

Create backup of Docker data volumes.  Applies to role cdvr-cicd-master and cdvr-cicd-jenkins because they are configured to use data volumes.  
    
  1. Identify container of interest from list of all running containers.  
  `# docker-compose ps`  
  
  2. Stop container.  
  `# docker-compose stop <container>`  
  
  3. Change to data volume directory.  
  `# cd /var/lib/docker/volumes`  
  
  4. Backup container.  
  `# tar cvpf /bkup/<volume>.tar ./<volume>`  
  
  5. Start container.  
  `# docker-compose start <container>`  

**Restore Docker Volumes**

  1. Identify container of interest from list of all running containers.  
  `# docker-compose ps`  
  
  2. Stop container.  
  `# docker-compose stop <container>`  
  
  3. Change to data volume directory.  
  `# cd /var/lib/docker/volumes`  
  
  4. Make copy of old dir.
  `# cp -a <container> <container>.old`  
  
  5. Restore container.  
  `# tar xvpf /bkup/<volume>.tar`  
  
  6. Start container.  
  `# docker-compose start <container>`  

**Backup Docker Containers**
  
  Export Docker container.  Applies to services ___not managed___ with docker compose.  i.e. Containers without a data volume.
  
  1. Identify container of interest from list of all running containers.  
  `# docker-compose ps`  
  
  2. Stop container.  
  `# docker-compose stop <container>`  
  
  3. Backup container.  
  `# docker export <container> | gzip > /bkup/<container>.tgz`  
  
  4. Start container.  
  `# docker-compose start <container>`  

**Restore Docker Containers**

  Applies to services ___not managed___ with docker compose.  i.e. Containers without a data volume.  

  1. Identify container of interest from list of all running containers.  
  `# docker-compose ps`  
  
  2. Stop container.  
  `# docker-compose stop <container>`  
  
  3. Restore container.  
  `# zcat /bkup/<container>.tgz | docker import - <container>`  
  
  4. Start container.  
  `# docker-compose start <container>`  

---
### Use cases

The following are use cases examples.

**Deploy Jenkins Build Master**
<pre># ansible-playbook -l <i>target</i> -i hosts/cdvr-cicd-ctec playbooks/cdvr-cicd-master.yml</pre>

**Deploy Jenkins Build Agent**
<pre># ansible-playbook -l <i>target</i> -i hosts/cdvr-cicd-ctec playbooks/cdvr-cicd-agent.yml</pre>
    
**Deploy Multi Jenkins**
<pre># ansible-playbook -l <i>target</i> -i hosts/cdvr-cicd-ctec playbooks/cdvr-cicd-jenkins.yml</pre>


---
### Variables

* group_vars:
Environmental variables are used to specify parameters at deploy time.

**Universal**

* block\_device: "/dev/sdb"  
* compose\_home: "/root"  
* compose\_dir: "cdvr"  

---
### Validation
The admin interfaces are available here.

**Build Master**

| Component                 |                                |
|---------------------------|--------------------------------|
| Jenkins Master            |   http://\<build_master\>:8080 |
| Gogs Git Repo             |   http://\<build_master\>:3000 |
| Nexus Repository Manager  |   http://\<build_master\>:8181 |
| cAdvisor Resource Monitor |   http://\<build_master\>:8089 |

---
### Examples

