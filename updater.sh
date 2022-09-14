#!/bin/bash

webhookURL='https://discord.com/api/webhooks/XXX'
gandiToken='XXX'
dnsRecords='https://api.gandi.net/v5/livedns/domains/XXX/records/XXX/XXX'

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
