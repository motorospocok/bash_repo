result=$(oc get services| grep -i yang | awk 'BEGIN {FS=" "}{print "moshell -z -v yang_username=autodeploy,yang_password=Let.me.in123,netconfyang_port=830 " $4}')
echo $result
$result
