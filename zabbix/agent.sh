#! /bin/bash
apt update
apt install zabbix-agent -y
cd /opt/
wget https://raw.githubusercontent.com/sagespidy/zox/master/zabbix/zabbix_agentd.conf
cp  zabbix_agentd.conf /etc/zabbix/
service zabbix_agent restart
