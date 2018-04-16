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

[![asciicast](https://asciinema.org/a/JdVxkhcitfBHzE91FdwhRldkX.png)](https://asciinema.org/a/JdVxkhcitfBHzE91FdwhRldkX)

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



> 2.**Spawn specific instance in any of the cloud environment and terminate that instance when needed.**

[![asciicast](https://asciinema.org/a/LFSQpy6eFiRylgTdZQFrC3wuM.png)](https://asciinema.org/a/LFSQpy6eFiRylgTdZQFrC3wuM)

## Prerequisite

- Terraform installed in local Machine
- **AWS Env**    ==>   Access Key & Secret Access Key for  
- **GCP Env**    ==> Json file with credentials 
- **Azure Env**        ==>  Azure cli 2.0 installed on local machine.

We can Terraform  modules to do so. 

 -  clone the repo of required env.

 -  Provide the required values of variable in `terraform.tfvars` file

 -  To check the vailidity of plan

    ```
    terrform plan
    ```

- To create the instances

  ```
  terraform apply
  ```

- To destory the environment

  ```
  terraform destroy
  ```




> 3. **Setup monitoring of these servers. Zox needs a dashboard where it can monitor CPU usage, RAM usage.**

We have multiple options here. We can use inbuilt  cloud services like Cloudwatch, stack driver, Azure Monitor and have them send data to a centralized Grafana 

 For demo purpose,  i have setup zabbix server here : [Zabbix](http://zabbix.sagespidy.com/zabbix)

The server is setup for auto-discovery. If there is a agent running  on a server and have the IP of Zabbix server configured, it will be automatically registered.



This is a startup script that can be run when a server is provisioned or on a running host.

```
#! /bin/bash
apt update
apt install zabbix-agent -y
cd /opt/
wget https://raw.githubusercontent.com/sagespidy/zox/master/zabbix/zabbix_agentd.conf
cp  zabbix_agentd.conf /etc/zabbix/
service zabbix_agent stop
service zabbix_agent start
```



For Dashboard, we can use grafana. For demo purpose,  i have setup Grafana server here : [Grafana](http://zabbix.sagespidy.com:3000)



> 4. **DevOps team needs to be alerted if for any of the server, % RAM usage is more than 80% for more than 5 minutes.**



Zabbix has inbuilt triggers for RAM usage. It will send alerts via configured media types

