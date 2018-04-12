# Case Study  : zox
#Problem Statement

Consider that you are a DevOps engineer at a product based company - Zox. Zox has a multi-tenant architecture which you need to manage as a DevOps engineer.  

Following is the setup of servers for Zox

- **Google Cloud Platform : 10**
- **AWS EC2 : 10**
- **MS Azure :10**

How will you help Zox do following programmatically:

1. **Get information of machine specs - CPU, RAM configured, Linux  kernel and distribution.**
2. **Spawn specific instance in any of the cloud environment and terminate that instance when needed.**
3. **Setup monitoring of these servers. Zox needs a dashboard where it can monitor CPU usage, RAM usage.**
4. **DevOps team needs to be alerted if for any of the server, % RAM usage is more than 80% for more than 5 minutes.**





# The Solution 

> 1. **Get information of machine specs - CPU, RAM configured, Linux  kernel and distribution.**

<script src="https://asciinema.org/a/JdVxkhcitfBHzE91FdwhRldkX.js" id="asciicast-JdVxkhcitfBHzE91FdwhRldkX" async></script>

## Prerequisite

- IP address  of all the servers


- SSH key with access to servers
- Ansible installed your Machine

## Let's Begin

- Create a Ansible inventory file with IP address. IP address can be managed in groups. Here [aws] is a group . We can operate on groups  

  ```
  [aws]
  1.1.1.1
  2.2.2.2
  [gcp]
  3.3.3.3
  4.4.4.4
  [Azure]
  5.5.5.5
  6.6.6.6
  ```

- Create a Ansible playbook **info.yml**. There is a Ansible  module called **setup** which is used to gather system facts and is run by default. We can cut out what we need.

  ```yaml
  ---
  - hosts: all # Define which group to Operate on
    remote_user: ubuntu #  Define the SSH user name
    gather_facts: True  #
    tasks:  # Define task for host group all

       - name: System info  # Just the name of task 
         debug:  # 
           msg: "Processor = {{ ansible_processor }} ,
                CPU Cores = {{ ansible_processor_cores }},
                RAM = {{ ansible_memtotal_mb }} MB,
                Distrubtion Details = {{ ansible_distribution }} {{ansible_distribution_version}} {{ansible_distribution_release}},
                Kernel = {{ansible_kernel}} with architecture {{ansible_architecture}} "

  ```

- Finally , run this command to get the info.

  ```
  ansible-playbook info.yml -i inventory --private-key ~/Documents/zox
  ```

  ​