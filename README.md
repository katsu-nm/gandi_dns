# Gandi DNS Auto-Updater

## Variables & Deployment

To deploy this project create a folder in your user directory, such as /home/katsu/gandi_dns and place the following files in said directory 'updater.sh' and 'recIP.txt'.

Within 'updater.sh', modify the following variables to contain your Discord webhook, Gandi API key, and DNS records

An example of the dnsRecords variable is an A record of 'dashboard.example.com' which would look like the following:

```bash
dnsRecords='https://api.gandi.net/v5/livedns/domains/example.com/records/dashboard/A'

```

```bash
webhookURL='https://discord.com/api/webhooks/xxx'
gandiToken='xxx'
dnsRecords='https://api.gandi.net/v5/livedns/domains/<domain>/records/<record>/<record type>'
```
Once configured, you should have the following in 'updater.sh'
```bash
#!/bin/bash

webhookURL='https://discord.com/api/webhooks/xxx'
gandiToken='xxx'
dnsRecords='https://api.gandi.net/v5/livedns/domains/<domain>/records/<record>/<record type>'

currentIP=$(curl ifconfig.me)
currentTime=$(date)
recordedIP=$(cat recIP.txt)

if grep -w ${currentIP} "recIP.txt"; then
  echo "IP not changed"
else
	echo "IP changed"
	echo "$currentIP" > recIP.txt
	curl -s -X PUT --header "Authorization: Apikey $gandiToken" --header "Content-Type: application/json" -d "{\"rrset_values\": [\"${currentIP}\"], \"rrset_ttl\": "10800"}" $dnsRecords
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"IP address change detected, relevant DNS records have been updated\"}" $webhookURL
fi
```

Run `chmod +x updater.sh` and execute the script manually to verify it's working as intended

This can then be ran via whatever means suit you, cronjob, event scheduler etc
