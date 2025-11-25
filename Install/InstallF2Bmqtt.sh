#!/bin/bash
# This script installs the Fail2BanMQTT central functions for sharing bans/unbans via mqtt.

# Copy individual files from archive to /etc/fail2ban
#   mqttsubscribebans
#   mqttnotifyban
#   mqtt.env
#           /etc/systemd/system/f2bmqttsub.service
#           /etc/fail2ban/action.d/iptables-ipset.local

# Get the github archive

wget https://github.com/CyberSteve99/Fail2BanMQTT/archive/refs/heads/main.zip -O Fail2BanMQTT.zip
unzip Fail2BanMQTT.zip

mv Fail2BanMQTT-main/mqtt.env                           /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/mqttsubscribebans     /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/mqttnotifyban         /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/f2bmqttsub.service    /etc/fail2ban/

mv Fail2BanMQTT-main/etc/fail2ban/action.d/fail2ban-abuseipdb.sh    /etc/fail2ban/action.d/
mv Fail2BanMQTT-main/etc/fail2ban/action.d/iptables-ipset.local     /etc/fail2ban/action.d/
mv Fail2BanMQTT-main/etc/fail2ban/action.d/abuseipdb.local          /etc/fail2ban/action.d/

chmod +x /etc/fail2ban/mqttsubscribebans
chmod +x /etc/fail2ban/mqttnotifyban

mv /etc/fail2ban/f2bmqttsub.service /etc/systemd/system/f2bmqttsub.service
systemctl daemon-reload
systemctl enable f2bmqttsub.service
systemctl restart f2bmqttsub.service

rm -r Fail2BanMQTT-main