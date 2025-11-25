# Fail2BanMQTT
Share Fail2Ban bans/unbans across Servers using MQTT

**Objective**

When any Fail2Ban server bans or unbans an IP then use MQTT to notify all others (that are subscribed to the topic) of the ban so they can add it to their bans. Note that if the receiving server doesn't have the same jail then the ban is ignored.

Dependency - mosquitto-client and wget. Naturally you will also require an MQTT Service.

```
apt install mosquitto-clients wget
```

Requires a call to `mosquitto_pub -h <mqtt-host> -u <user> -P <password> -t <topic>/# -m <JSON Ban/Unban details>` in the ban actions and unban actions
In our case this is defined in /etc/fail2ban/action.d/iptables-ipset.local (see below).

Also requires a routine that is listening/subscribed with mosquitto_sub on all hosts that participate is the sharing..

Logic needs to know if it was the sending node so that it doesn't re-add it to it's own bans. Info needed is the reporting host, ban_name, ip address, ban time, faulures. 

Script to subscribe and process messages is at /usr/local/bin/mqttsubscribebans
Script to publish messages is at /etc/fail2ban/mqttnotifyban.sh
Config file is at /etc/fail2ban/mqtt.env
Script to publish bans is at /etc/fail2ban/mqttnotifyban.sh

The file /etc/fail2ban/mqtt.env contains the following:- 

```
MQTT_USER=fail2ban
MQTT_PASSWORD=fail2ban
MQTT_HOST=192.168.1.10
MQTT_TOPIC=blacklist
```

These are generally common across all systems but in theory user/password could be different on each server. Host & Topic would be common.

**Some Notes to consider.**

When fail2ban-client is used to ban/unban IP's then the number of failures is zero. This is used in the scripts to determine if a message should be published. This then prevents multiple publishing of messages for the same IP.

By including the jail name the scripts can check if that jail exists to determine whether or not to action the ban/unban on the remote systems.

If using AbuseIPDB reporting scripts then modification to action.d files to include calls to publish routines to cater for bans by remote systems and using the <failure> to determine if ban should be actioned.


**Additional Information for using AbuseIPDB to report bans.**

Included is the file /etc/fail2ban/action.d/fail2ban-abuseipdb.sh and /etc/fail2ban/action.d/abuseipdb.local to replace those documented in https://github.com/fail2ban/fail2ban/issues/3428

I have moved the apikey to a separate config file (/etc/fail2ban/abuseipdb.apikey) which overrides any defined in jail or action.d files. You will have to create your own file if you use this. 

**Installation**

Use the following one liner to install.

```
wget -q -O- https://raw.githubusercontent.com/CyberSteve99/Fail2BanMQTT/refs/heads/main/Install/InstallF2Bmqtt.sh |bash`
```


**TODO**
Tidy up jails and action.d files to remove passing apikey as a parameter and then modify scripts accordingly. Not a high priority as it works without these changes.
