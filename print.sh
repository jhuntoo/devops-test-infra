source ./env.vars
QTY=$1
for ((i=1;i<=QTY;i++)); do   curl "web-app.${HOSTED_ZONE_DOMAIN}"; echo; done