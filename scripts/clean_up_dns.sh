HOSTED_ZONE_NAME=$1
echo 'Preparing DNS record cleanup'
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones | jq ".HostedZones[] | select(.Name==\"${HOSTED_ZONE_NAME}.\") | .Id" | sed -e 's/^"//' -e 's/"$//')
RECORD_SETS=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID)

WEB_APP_RECORD_SET=$(echo $RECORD_SETS | jq -r --arg domain "web-app.$HOSTED_ZONE_NAME." '.ResourceRecordSets[] | select(.Name == $domain and .Type == "CNAME")')

# Delete the record set
cat <<EOF >change-resource-record-sets.json
{
  "Comment": "delete k8s cluster records",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": $WEB_APP_RECORD_SET
    }
  ]
}
EOF

CHANGE_RECORD_SET=$(aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://change-resource-record-sets.json)

CHANGE_ID=$(echo $CHANGE_RECORD_SET | jq -r '.ChangeInfo.Id')

echo 'Waiting for DNS cleanup to complete..'
aws route53 wait resource-record-sets-changed --id $CHANGE_ID

rm change-resource-record-sets.json