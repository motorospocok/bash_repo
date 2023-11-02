#!/bin/bash

result=$(oc get services | grep -i yang | awk '{print $4}')

# Ellenőrizzük, hogy az $4 tartalmaz-e számot
if [[ $result =~ none ]]; then
    result=$(oc get services| grep -i yang-provider-external | awk 'BEGIN {FS=" "}{print "moshell -z -v yang_username=autodeploy,yang_password=Let.me.in123,netconfyang_port=830 " $4}')
else
    result=$(oc get services| grep -i yang | awk 'BEGIN {FS=" "}{print "moshell -z -v yang_username=autodeploy,yang_password=Let.me.in123,netconfyang_port=830 " $4}')
fi

echo $result
$result
