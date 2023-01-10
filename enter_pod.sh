#!/bin/bash
if [ -z "$1" ]; then
			  echo " "
			  echo usage: enter_pod.sh "<POD name>"
			  echo ' '
			  exit
		  fi

ALMA=$1
oc exec -it $(oc get pods | awk -v VAR1=$ALMA '$0 ~ VAR1 {print $1}') -c sshd -- bash