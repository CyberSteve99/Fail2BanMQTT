#!/bin/bash
# This script installs the Fail2BanMQTT central functions for sharing bans/unbans via mqtt.

# Copy individual files from archive to /etc/fail2ban
#   mqttsubscribebans
#   mqttnotifyban
#   mqtt.env
#           /etc/systemd/system/f2bmqttsub.service
#           /etc/fail2ban/action.d/iptables-ipset.local

# Get the github archive
echo "🚀    Getting GitHub Archive."
wget -q https://github.com/CyberSteve99/Fail2BanMQTT/archive/refs/heads/main.zip -O Fail2BanMQTT.zip
echo "🚀    Unzipping GitHub Archive."
unzip -qq Fail2BanMQTT.zip
echo "🚀    Moving Files."
mv Fail2BanMQTT-main/etc/fail2ban/mqtt.env              /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/mqttsubscribebans     /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/mqttnotifyban         /etc/fail2ban/
mv Fail2BanMQTT-main/etc/fail2ban/f2bmqttsub.service    /etc/fail2ban/

mv Fail2BanMQTT-main/etc/fail2ban/action.d/fail2ban-abuseipdb.sh    /etc/fail2ban/action.d/
mv Fail2BanMQTT-main/etc/fail2ban/action.d/iptables-ipset.local     /etc/fail2ban/action.d/
mv Fail2BanMQTT-main/etc/fail2ban/action.d/abuseipdb.local          /etc/fail2ban/action.d/

chmod +x /etc/fail2ban/mqttsubscribebans
chmod +x /etc/fail2ban/mqttnotifyban

echo "🚀    Creating and starting f2bmqttsub Service."
mv /etc/fail2ban/f2bmqttsub.service /etc/systemd/system/f2bmqttsub.service
systemctl daemon-reload
systemctl enable f2bmqttsub.service
systemctl restart f2bmqttsub.service
echo "🚀    Tidying Up."
rm -r Fail2BanMQTT-main
rm Fail2BanMQTT.zip
echo "✅    Complete."
