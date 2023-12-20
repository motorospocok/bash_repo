#!/bin/bash

./ctrl_etrex show mode
read -p "Do you want to start UBG mode? " userInput
if [ "$userInput" == "y" ]; then
    ./ctrl_etrex mode ubg
    echo "UBG mode started! Or at least I was tried..."$'\n'
else
    echo 'Do not forget to start ubg mode'    
fi

read -p "Do you want to load max TCP json file ? " userInput
if [ "$userInput" == "y" ]; then
 ./ctrl_etrex --debug --verbose taskcfg /root/tc145/testutils/usr/e2e/max_tcp.json
fi

echo 'Search for API GW'
API_GW=$(./list_csim|grep -i apigw | awk 'BEGIN {FS=" "}{print $4}')
ls /root/tc145/testutils/data/capabilities
echo 'Plese select capability set'
read capset
ls /root/tc145/testutils/data/capabilities/$capset
lte_cap=$(cat /root/tc145/testutils/data/capabilities/$capset/eutra.cap)
mrdc_cap=$(cat /root/tc145/testutils/data/capabilities/$capset/mrdc.cap)
nr_cap=$(cat /root/tc145/testutils/data/capabilities/$capset/nr.cap)



read -p "Please enter court parameter - Cols - if enter d then default 100 " userInput

if [ "$userInput" == "d" ]; then
    cols1=100
    echo "Cols set to 100."
else
    cols1="$userInput"    
fi

read -p "Please enter court parameter - Rows - if enter d then default 100 " userInput
if [ "$userInput" == "d" ]; then
    rows1=100
    echo "Rows set to 100."
else
    rows1="$userInput"    
fi

read -p "Please enter square size parameter - if enter d then default 10 " userInput
if [ "$userInput" == "d" ]; then
    sq1=10
    echo "Square set to 10."
else
    sq1="$userInput"    
fi


curl -X POST -H "Content-type: application/json" -d '{"id":"rem_court1","cols":'$cols1',"rows":'$rows1',"square-size":'$sq1'.0}' $API_GW/api/radio-env/v1
echo "*************************************************************************"
echo "*************************** COURT DEFINED NOW ***************************"
echo "*************************************************************************"
echo 'get court'
curl -X GET $API_GW/api/radio-env/v1/rem_court1
#echo 'deltete court'
#curl -X DELETE $API_GW/api/radio-env/v1/rem_court1

read -p "Please enter area parameter NORTH - default 260 " userInput
if [ "$userInput" == "d" ]; then
    N1=260
    echo "North set to 260."
else
    N1="$userInput"    
fi

read -p "Please enter area parameter SOUTH - default 240 " userInput
if [ "$userInput" == "d" ]; then
    S1=240
    echo "South set to 240."
else
    S1="$userInput"    
fi

read -p "Please enter area parameter WEST - default 240 " userInput
if [ "$userInput" == "d" ]; then
    W1=240
    echo "West set to 240."
else
    W1="$userInput"    
fi

read -p "Please enter area parameter EAST - default 260 " userInput
if [ "$userInput" == "d" ]; then
    E1=240
    echo "East set to 260."
else
    E1="$userInput"    
fi

curl -X POST -H 'Content-Type: application/json' -d '{"name":"area1","north":'$N1',"south":'$S1',"west":'$W1',"east":'$E1'}' $API_GW/api/ubsim-area/v1
echo "*************************************************************************"
echo "*************************** AREA DEFINED NOW ***************************"
echo "*************************************************************************"


curl -X GET $API_GW/api/ubsim-area/v1/area1




./list_cells |grep -i eutra

read -p "Please enter LTE PCI " ltePCI
lteArfcn=$(./list_cells | grep -i eutran | grep -i $ltePCI| awk 'BEGIN {FS=" "}{print $8}')
read -p "Please enter LTE Location X coordinate - d default 250 " x_coord_lte
read -p "Please enter LTE Location Y coordinate - d default 250 " y_coord_lte
read -p "Please enter LTE start angle - d default 0 " start_lte
read -p "Please enter LTE end angle - d default 360 " end_lte 


if [ "$x_coord_lte" == "d" ]; then
    x_coord_lte=250
    echo "LTE X coordinate set to 250."
else
    echo "LTE X Coordinate set to $x_coord_lte."
fi

if [ "$y_coord_lte" == "d" ]; then
    y_coord_lte=250
    echo "LTE Y coordinate set to 250."
else
    echo "LTE Y Coordinate set to $y_coord_lte."
fi

if [ "$start_lte" == "d" ]; then
    start_lte=0
    echo "LTE start angle set to 0."
else
    echo "LTE Start angle set to $start_lte."
fi

if [ "$end_lte" == "d" ]; then
    end_lte=360
    echo "LTE End angle angle set to 360."
else
    echo "LTE Start angle set to $end_lte."
fi

./list_cells |grep -i gutra

read -p "How NR cells will be defined? " numParameters

# Check if the input is a positive integer
if ! [[ "$numParameters" =~ ^[1-9][0-9]*$ ]]; then
    echo "Please enter a valid positive integer."
    exit 1
fi

# Initialize an array to store parameters
nr_pci=()
nr_ssb=()
nr_x=()
nr_y=()
nr_start=()
nr_end=()

# Loop to get input for each parameter
for ((i=1; i<=$numParameters; i++)); do
    read -p "$i Enter Nr CeLL PCI: " param
    nr_pci+=("$param")
	nr_ssb+=$(./list_cells | grep -i gutran | grep -i $param| awk 'BEGIN {FS=" "}{print $12}')
    read -p "$i Enter Nr CeLL X coordinate - d default 250: " param
    if [ "$param" == "d" ]; then
     nr_x+=250
     echo "NR X coord set to 250."
    else
     nr_x+=("$param")
     echo "NR X coord angle set to $param."
    fi
    read -p "$i Enter Nr CeLL Y coordinate - d default 250: " param
    if [ "$param" == "d" ]; then
     nr_y+=250
     echo "NR X coord set to 250."
    else
     nr_y+=("$param")
     echo "NR Y coord angle set to $param."
    fi
    read -p "$i Enter Nr CeLL  Start angle - d default 0: " param
    if [ "$param" == "d" ]; then
     nr_start+=0
     echo "NR start angle set to 0."
    else
     nr_start+=("$param")
     echo "NR start angle set to $param."
    fi
    read -p "$i Enter Nr CeLL  end angle - d default 360: " param
    if [ "$param" == "d" ]; then
     nr_end+=360
     echo "NR start angle set to 360."
    else
     nr_end+=("$param")
     echo "NR start angle set to $param."
    fi
done

# Display the entered parameters
echo ${nr_pci[0]}
echo ${nr_ssb[0]}
echo ${nr_x[@]}
echo ${nr_y[@]}
echo ${nr_start[@]}
echo ${nr_end[@]}

echo 'have a break have a kit-katt'
read valami

if [ "$numParameters" -eq 1 ]; then
   curl -X POST -H "Content-type: application/json" -d '{"antennas":[{"idx":"1","pci":'${nr_pci[0]}',"arfcn":'${nr_ssb[0]}',"rat":"NR","location":{"x":'${nr_x[0]}'.0,"y":'${nr_y[0]}'.0},"radiation-angle":{"start-angle":'${nr_start[0]}',"end-angle":'${nr_end[0]}'}},{"idx":"2","pci":'$ltePCI',"arfcn":'$lteArfcn',"rat":"LTE","location":{"x":'$x_coord_lte'.0,"y":'$y_coord_lte'.0},"radiation-angle":{"start-angle":'$start_lte',"end-angle":'$end_lte'}}]}' $API_GW/api/radio-env/v1/rem_court1/antennas
elif [ "$numParameters" -eq 2 ]; then
    curl -X POST -H "Content-type: application/json" -d '{"antennas":[{"idx":"1","pci":'${nr_pci[0]}',"arfcn":'${nr_ssb[0]}',"rat":"NR","location":{"x":'${nr_x[0]}'.0,"y":'${nr_y[0]}'.0},"radiation-angle":{"start-angle":'${nr_start[0]}',"end-angle":'${nr_end[0]}'}},{"idx":"2","pci":'${nr_pci[1]}',"arfcn":'${nr_ssb[1]}',"rat":"NR","location":{"x":'${nr_x[1]}'.0,"y":'${nr_y[1]}'.0},"radiation-angle":{"start-angle":'${nr_start[1]}',"end-angle":'${nr_end[1]}'}},{"idx":"3","pci":'$ltePCI',"arfcn":'$lteArfcn',"rat":"LTE","location":{"x":'$x_coord_lte'.0,"y":'$y_coord_lte'.0},"radiation-angle":{"start-angle":'$start_lte',"end-angle":'$end_lte'}}]}' $API_GW/api/radio-env/v1/rem_court1/antennas
fi

echo "*************************************************************************"
echo "************************* ANTENNAS DEFINED NOW **************************"
echo "*************************************************************************"

curl -X GET $API_GW/api/radio-env/v1/rem_court1/antennas
echo 'Have break have a kit kat'
read valami


echo '--------'
echo 'capset'
curl -X POST -H 'Content-Type: application/json' -d '{"name":"cc_nsa", "ue-capability-set":{"eutra":{"hex":"'"$lte_cap"'"}}}' $API_GW/api/ue-capability-set/v1
curl -X POST -H 'Content-Type: application/json' -d '{"name":"cc_nsa", "ue-capability-set":{"mrdc":{"hex":"'"$mrdc_cap"'"}}}' $API_GW/api/ue-capability-set/v1
curl -X POST -H 'Content-Type: application/json' -d '{"name":"cc_nsa", "ue-capability-set":{"nr":{"hex":"'"$nr_cap"'"}}}' $API_GW/api/ue-capability-set/v1
echo '------'
echo 'cap set get'

echo "*************************************************************************"
echo "************************ CAPABILITY DEFINED NOW *************************"
echo "*************************************************************************"


curl -X GET $API_GW/api/ue-capability-set/v1/cc_nsa

curl -X POST -H 'Content-type: application/json' -d '{"name":"NR_TCP_test","activity-sequences":[{"id" : "TcpTest","activity-list":[{"name":"FtpQci9","task-type":"etrex-ftp","isp-port":"qci9","parameters":{"direction":"DL","data-size":1000000000000000,"max-packet-size":1358,"timeout":5,"min-throughput":400000000}}],"activity-list-restart-interval":1}]}' $API_GW/api/app-usage/v1
curl -X POST -H 'Content-Type: application/json' -d '{"name":"NR_TCP_ue_set1","start-imsi":262800725591600,"count":1,"mobility-behavior":"MobilityStandStillModel","application-behavior":"NR_TCP_test","equipment-control-behavior":"CsPowerOnTrafficModel","mobility-area":"area1","ue-capabilities":"cc_nsa","admin-state":"ON"}' $API_GW/api/ue-set/v1

read -p "Do you delete UE? " userInput
if [ "$userInput" == "y" ]; then
 curl -X DELETE $API_GW/api/ue-set/v1/NR_TCP_ue_set1
fi

read -p "Do you delete app set? " userInput
if [ "$userInput" == "y" ]; then
 curl -X DELETE $API_GW/api/app-usage/v1/NR_TCP_test
fi
 
read -p "Do you want delete cabability set? " userInput
if [ "$userInput" == "y" ]; then
 curl -X DELETE $API_GW/api/ue-capability-set/v1/cc_nsa
fi

read -p "Do you want delete AREA and other stuff? " userInput
if [ "$userInput" == "y" ]; then
 curl -X DELETE $API_GW/api/ubsim-area/v1/area1
 curl -X DELETE $API_GW/api/radio-env/v1/rem_court1
fi

 

