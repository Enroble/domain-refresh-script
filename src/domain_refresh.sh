#!/bin/bash
DOMAIN_NAME=YOUR DOMAIN
PUBLIC_RECORD=$DOMAIN_NAME.
R53_HOSTED_ZONE=HOSTED ZONE

DOMAIN_IP=$(aws route53 list-resource-record-sets --hosted-zone-id $R53_HOSTED_ZONE | jq ".ResourceRecordSets[0].ResourceRecords[0].Value" | tr -d '"')
CURRENT_IP=$(curl -s http://checkip.amazonaws.com)

echo "DOM $DOMAIN_IP LOC $CURRENT_IP"

if [ $"$DOMAIN_IP" == "$CURRENT_IP" ]; then
	echo "Domain_IP = $DOMAIN_IP Current IP = $CURRENT_IP  ---No change---"
	exit
else 
	echo "Domain_IP = $DOMAIN_IP Current IP = $CURRENT_IP  ---Change Detected!---"
fi

read -r -d '' R53_ARECORD_JSON << EOM
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$PUBLIC_RECORD",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$CURRENT_IP"
          }
        ]
      }
    }
  ]
}
EOM

echo "$R53_ARECORD_JSON"
echo "^ Updataing class A record to above json ^"
R53_ARECORD_ID=`aws route53 change-resource-record-sets \
--hosted-zone-id $R53_HOSTED_ZONE \
--change-batch '{ "Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "'"$DOMAIN_NAME"'", "Type": "A", "TTL": 300, "ResourceRecords": [ { "Value": "'"$CURRENT_IP"'" } ] } } ] }' \
--query ChangeInfo.Id \
--output text`

echo "Querying AWS if class A record was updated..."
aws route53 wait resource-record-sets-changed --id $R53_ARECORD_ID

DOMAIN_IP=$(aws route53 list-resource-record-sets --hosted-zone-id Z067712312W82EN0U5TWL | jq ".ResourceRecordSets[0].ResourceRecords[0].Value" | tr -d '"')
echo "Domain_IP = $DOMAIN_IP Current IP = $CURRENT_IP"
exit
