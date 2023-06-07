alma=$(cat ~/sitefiles/oc_login_db.txt | grep -i $1 | awk 'BEGIN {FS="="}{print $2}')
echo $alma
$alma
