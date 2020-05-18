#!/bin/bash

if [ -z "${1}" ]; then
	echo LTE MOS script generator by ETHTOJA
	echo Template support by Balazs Adam and Karoly Dancso
	echo This program generates LTE integration MOS scripts for Mosaic LTE project
	echo 'The scripts are generated in <SITE_NAME> subdirectory'
	echo The generated scripts can be run on L13A or higher sw level
	echo
	echo Usage:
	echo 
	echo Generating scripts by manual data input:
	echo './LTE_SCRIPT_GEN_TEMP_v3.12.sh man'
	echo 
	echo  Generating scripts by csv file - converted from the LLD XLS:
	echo './LTE_SCRIPT_GEN_TEMP_v3.12.sh <SITENAME>'
	echo
	echo 'e.g ./LTE_SCRIPT_GEN_TEMP_v3.10sh DN_1234'
	echo 'e.g ./LTE_SCRIPT_GEN_TEMP_v3.10sh dn_1234'
	echo 
	echo 'Long life for the abbots of Scriptorium!'
	exit 1
fi

touch tma
touch 102
touch 104
touch result

if [ "${1}" == 'man' ]; then
	echo Integration file generation by manual parameter input
	read -p "Please enter sitename " SITE
	
	read -p "Please enter ARFCN_DL " ARFCN_DL
	if [ ${ARFCN_DL} -eq 6200 ]; then
		ARFCN_UL=24200
	fi
	if [ ${ARFCN_DL} -eq 1900 ]; then
		ARFCN_UL=19900
	fi
	echo 'Recommended ARFCN_UL is' ${ARFCN_UL}
	read -p "Please enter ARFCN_UL " TMP
	if [ -n "$TMP" ]; then
		ARFCN_UL=$TMP
	fi
	read -p "Please enter TAC " TAC
	${CELL1_TAC[1]}=$TAC
	read -p "Please enter ENBID " ENBID1
	ENBID=$ENBID1
	read -p "Please enter Cell range " CELLRANGE1
	if [ ${ARFCN_DL} -eq 1900 ]; then
		PRE=L18_
	else
		PRE=L8_
	fi
	read -p "Please give the number of cells " NumCells
	NumCells=$NumCells-1
	CELL1_NAME[0]=${PRE}${SITE}A1
	
	echo ${CELL1_NAME[0]}
	c=1	
	for ((b=0;b<=$NumCells;b++))
		do
			if [ ${b} -eq 1 ]; then
				CELL1_NAME[1]=${PRE}${SITE}B1
			fi
			if [ ${b} -eq 2 ]; then
				CELL1_NAME[2]=${PRE}${SITE}C1
			fi
			echo 'Recommended cellname is' ${CELL1_NAME[$b]}
			read -p "Please enter cellname " TMP
			if [ -n "$TMP" ]; then
				CELL1_NAME[$b]=$TMP
			fi
			read -p "Please enter physicalLayerCellIdGroup " TMP
			CELL1_PHYCELLID[$b]=$TMP			
			read -p "Please enter physicalLayerSubCellId " TMP
			CELL1_PHYCELLID_SUB[$b]=$TMP
			read -p "Please enter rachrootsequence " TMP
			CELL1_RACH_ROOT_SEQ[$b]=$TMP
			read -p "Please enter longitude " TMP
			CELL1_longitude[$b]=$TMP
			read -p "Please enter latitude " TMP
			CELL1_latitude[$b]=$TMP
			read -p "Please enter DL attenuation " TMP
			DLATTENU[$b]=$TMP
			read -p "Please enter UL attenuation " TMP
			ULATTENU[$b]=$TMP
			read -p "Please enter DL delay " TMP
			DLDELAY[$b]=$TMP
			read -p "Please enter UL delay " TMP
			ULDELAY[$b]=$TMP
			CELL1_earfndl[$b]=$ARFCN_DL
			CELL1_earfnul[$b]=$ARFCN_UL
			CELL1_TAC[$b]=$TAC
			CELLRANGE[$b]=$CELLRANGE1
		done
else
	echo Generating integration files from CSV file
	cat LLD.csv | grep -i $1 > result.log
	file_size=($(cat result.log | wc -c))
	CELL1_NAME=($(cat result.log|awk 'BEGIN { FS = ";" } {print $27}')) # array
	CELL1_earfndl=($(cat result.log|awk 'BEGIN { FS = ";" } {print $32}')) # array
	CELL1_earfnul=($(cat result.log|awk 'BEGIN { FS = ";" } {print $33}')) # array
	CELL1_PHYCELLID=($(cat result.log|awk 'BEGIN { FS = ";" } {print $30}')) # array
	CELL1_PHYCELLID_SUB=($(cat result.log|awk 'BEGIN { FS = ";" } {print $31}')) # array
	CELL1_TAC=($(cat result.log|awk 'BEGIN { FS = ";" } {print $25}')) # array
	CELL1_RACH_ROOT_SEQ=($(cat result.log|awk 'BEGIN { FS = ";" } {print $14}')) # array
	CELL1_longitude=($(cat result.log|awk 'BEGIN { FS = ";" } {print $7}')) # array
	CELL1_latitude=($(cat result.log|awk 'BEGIN { FS = ";" } {print $6}')) # array
	ENBID=($(cat result.log|awk 'BEGIN { FS = ";" } {print $22}')) # array
	SITE=($(cat result.log|awk 'BEGIN { FS = ";" } {print $2}')) # array
	DLATTENU=($(cat result.log|awk 'BEGIN { FS = ";" } {print $36}')) # array
	ULATTENU=($(cat result.log|awk 'BEGIN { FS = ";" } {print $37}')) # array
	DLDELAY=($(cat result.log|awk 'BEGIN { FS = ";" } {print $38}')) # array
	ULDELAY=($(cat result.log|awk 'BEGIN { FS = ";" } {print $39}')) # array
	CELLRANGE=($(cat result.log|awk 'BEGIN { FS = ";" } {print $13}')) # array
fi


if [ ${file_size} -eq 0 ]; then
	echo
	echo ' Sorry no site has been found with this name'
	rm tma*
	rm 102*
	rm 104*
	rm result*
	exit 1
fi
	

sector_RU[1]=RbsSubrack=1,RbsSlot=1,AuxPlugInUnit=RU-1-1,DeviceGroup=ru,RfPort=A
sector_RU[2]=RbsSubrack=1,RbsSlot=3,AuxPlugInUnit=RU-1-3,DeviceGroup=ru,RfPort=A
sector_RU[3]=RbsSubrack=1,RbsSlot=5,AuxPlugInUnit=RU-1-5,DeviceGroup=ru,RfPort=A

tma_delay_UL=500
tma_delay_DL=20
tma_atten=5
bandwidth=10000
band="800 Mhz"

allowedMeasBandwidth=50
cellReselectionPriority=5
connectedModeMobilityPrio=6
presenceAntennaPort1=true
qOffsetFreq=0
qQualMin=0
qRxLevMin=-122 
threshXHigh=0
threshXLow=22
tReselectionEutra=2
tReselectionEutraSfHigh=100
tReselectionEutraSfMedium=100

if [ ${CELL1_earfndl[0]} -eq 1900 ]; then
	tma_delay_UL=650
	tma_delay_DL=220
	tma_atten=4
	band="1800 Mhz"
	
	allowedMeasBandwidth=50
	cellReselectionPriority=6
	connectedModeMobilityPrio=6
	presenceAntennaPort1=true
	qOffsetFreq=0
	qQualMin=0
	qRxLevMin=-122 
	threshXHigh=22
	threshXLow=0
	tReselectionEutra=2
	tReselectionEutraSfHigh=100
	tReselectionEutraSfMedium=100
fi

echo -----------------------------------------------------------------------------------
echo Sitename------ ${SITE}
echo Band---------- ${band}
echo eNodeBID------ ${ENBID}
echo Tac----------- ${CELL1_TAC[1]}
echo Cell list----- ${CELL1_NAME[0]} ${CELL1_NAME[1]} ${CELL1_NAME[2]}
echo arfcnDL------- ${CELL1_earfndl[0]}
echo Bandwidth----- ${bandwidth}
echo -----------------------------------------------------------------------------------

	
mkdir ${SITE}
echo
echo "G E N E R A T I N G cell file for L13 sw level"

echo '# LTE_MOSAIC_CELL_DEF_FILE_GENERATED_by_TojaTOOL' >> 102_${SITE}_CELL_0.mos
echo ' ' >> 102_${SITE}_CELL_0.mos
echo 'confb+' >> 102_${SITE}_CELL_0.mos
echo 'gs+' >> 102_${SITE}_CELL_0.mos
echo ' ' >> 102_${SITE}_CELL_0.mos

echo '#LTE_MOSAIC_SCTP DEF_FILE_GENERATED_by_TojaTOOL' >> ${SITE}/01_${SITE}_SCTP.mos
echo ' ' >> ${SITE}/01_${SITE}_SCTP.mos
echo 'confb+' >> ${SITE}/01_${SITE}_SCTP.mos
echo 'gs+' >> ${SITE}/01_${SITE}_SCTP.mos
echo ' ' >> ${SITE}/01_${SITE}_SCTP.mos


echo '#LTE_MOSAIC_TMA DEF_FILE_GENERATED_by_TojaTOOL' >> ${SITE}/04_${SITE}_TMA.mos
echo ' ' >> ${SITE}/04_${SITE}_TMA.mos
echo 'confb+' >> ${SITE}/04_${SITE}_TMA.mos
echo 'gs+' >> ${SITE}/04_${SITE}_TMA.mos
echo ' ' >> ${SITE}/04_${SITE}_TMA.mos


sed s/"<ENBID>"/${ENBID[1]}/ L13_SCTP_TEMP_V9.mos >${SITE}/01_${SITE}_SCTP.mos

echo 'confb+' > ${SITE}/03_${SITE}_PARAM.mos
echo 'gs+' >> ${SITE}/03_${SITE}_PARAM.mos

cat L13_PARAM_TEMP_V9.mos >> ${SITE}/03_${SITE}_PARAM.mos

echo 'confb-' >> ${SITE}/03_${SITE}_PARAM.mos
echo 'gs-' >> ${SITE}/03_${SITE}_PARAM.mos


number=${#CELL1_NAME[@]}
number=$number-1
c=1
for ((b=0;b<=$number;b++))
	do
		sed s/"<EUTRANCELL1>"/${CELL1_NAME[$b]}/g L13_CELL_TEMP_V9.mos >a1.mos
		sed s/"<EARFCNDL>"/${CELL1_earfndl[$b]}/ a1.mos >a2.mos
		sed s/"<EARFCNUL>"/${CELL1_earfnul[$b]}/ a2.mos >a3.mos
		sed s/"<CELLID>"/${c}/ a3.mos >a4.mos
		sed s/"<GROUP>"/${CELL1_PHYCELLID[$b]}/ a4.mos >a5.mos
		sed s/"<SUBGR>"/${CELL1_PHYCELLID_SUB[$b]}/ a5.mos >a6.mos
		sed s/"<TAC>"/${CELL1_TAC[$b]}/ a6.mos >a7.mos
		sed s/"<LATI>"/${CELL1_latitude[$b]}/ a7.mos >a8.mos
		sed s/"<LONGI>"/${CELL1_longitude[$b]}/ a8.mos >a9.mos 
		sed s/"<DLATT>"/${DLATTENU[$b]}/ a9.mos >a11.mos 
		sed s/"<ULATT>"/${ULATTENU[$b]}/ a11.mos >a12.mos
		sed s/"<DDELAY>"/${DLDELAY[$b]}/ a12.mos >a13.mos
		sed s/"<CELL1_RACH_ROOT_SEQ>"/${CELL1_RACH_ROOT_SEQ[$b]}/ a13.mos >a14.mos
		sed s/"<UDELAY>"/${ULDELAY[$b]}/ a14.mos >a15.mos
		sed s/"<BANDWIDTH>"/${bandwidth}/ a15.mos >a16.mos
		sed s/"<CELLRANGE>"/${CELLRANGE[$b]}/ a16.mos >102_${SITE}_CELL_${c}.mos

		sed s/"<CELLID>"/${c}/g L13_TMA_TEMP_V9.mos >tma1.mos
		sed s/"<RFPORT>"/${sector_RU[$c]}/g tma1.mos > tma2.mos
		sed s/"<TMA_DELAY_DL>"/${tma_delay_DL}/g tma2.mos > tma3.mos
		sed s/"<TMA_DELAY_UL>"/${tma_delay_UL}/g tma3.mos > tma4.mos
		sed s/"<TMA_ATT>"/${tma_atten}/g tma4.mos > 104_${SITE}_TMA_${c}.mos
		
		sed s/"<EUTRANCELL1>"/${CELL1_NAME[$b]}/g L13_CELL_REL_TEMP_V9.mos > b1.mos
		sed s/"<EARFCNDL>"/${CELL1_earfndl[$b]}/g b1.mos >b2.mos
		sed s/"<allowedMeasBandwidth>"/${allowedMeasBandwidth}/g b2.mos >b3.mos
		sed s/"<cellReselectionPriority>"/${cellReselectionPriority}/g b3.mos >b4.mos
		sed s/"<connectedModeMobilityPrio>"/${connectedModeMobilityPrio}/g b4.mos >b5.mos
		sed s/"<presenceAntennaPort1>"/${presenceAntennaPort1}/g b5.mos >b6.mos
		sed s/"<qOffsetFreq>"/${qOffsetFreq}/g b6.mos >b7.mos
		sed s/"<qQualMin>"/${qQualMin}/g b7.mos >b8.mos
		sed s/"<qRxLevMin>"/${qRxLevMin}/g b8.mos >b9.mos
		sed s/"<threshXHigh>"/${threshXHigh}/g b9.mos >b10.mos
		sed s/"<threshXLow>"/${threshXLow}/g b10.mos >b11.mos
		sed s/"<tReselectionEutra>"/${tReselectionEutra}/g b11.mos >b12.mos
		sed s/"<tReselectionEutraSfHigh>"/${tReselectionEutraSfHigh}/g b12.mos >b13.mos
		sed s/"<tReselectionEutraSfMedium>"/${tReselectionEutraSfMedium}/g b13.mos >b14_${c}.mos

		((c++))
	done 
rm a*
cat 102_${SITE}_CELL_* > ${SITE}/02_${SITE}_CELL.mos
cat b14* > b15.mos

echo 'cr EUtraNetwork=1,EUtranFrequency='${CELL1_earfndl[1]} >> ${SITE}/02_${SITE}_CELL.mos
echo ${CELL1_earfndl[1]}  >> ${SITE}/02_${SITE}_CELL.mos
cat b15.mos >> ${SITE}/02_${SITE}_CELL.mos

echo 'confb-' >> ${SITE}/02_${SITE}_CELL.mos
echo 'gs-' >> ${SITE}/02_${SITE}_CELL.mos
echo ' ' >> ${SITE}/02_${SITE}_CELL.mos

cat 104_${SITE}_TMA_*.mos >> ${SITE}/04_${SITE}_TMA.mos

echo 'confb-' >> ${SITE}/04_${SITE}_TMA.mos
echo 'gs-' >> ${SITE}/04_${SITE}_TMA.mos
echo ' ' >> ${SITE}/04_${SITE}_TMA.mos
echo
echo
echo confb+ > ${SITE}/${SITE}_paramset_only.mos
echo gs+ >> ${SITE}/${SITE}_paramset_only.mos
echo lt all >> ${SITE}/${SITE}_paramset_only.mos
cat L13_PARAM_only_TEMP_V9.mos >> ${SITE}/${SITE}_paramset_only.mos
rm tma*
rm 102*
rm 104*
rm result*
rm b*

cd ${SITE} 
cat 01_* | grep "lset IpSystem=1" >> ${SITE}_paramset_only.mos
cat 01_* | grep "lset TransportNetwork" >> ${SITE}_paramset_only.mos
cat 01_* | grep "lset TransportNetwork" >> ${SITE}_paramset_only.mos
cat 01_* | grep "lset ENodeBFunction" >> ${SITE}_paramset_only.mos

cat 02_* | grep -i set >> ${SITE}_paramset_only.mos
cat 03_* | grep -i set >> ${SITE}_paramset_only.mos
echo bl sector >> ${SITE}_paramset_only.mos
echo deb sector >> ${SITE}_paramset_only.mos
echo 'acc NodeManagementFunction=1,SystemConstants=1$ writeSystConst' >> ${SITE}_paramset_only.mos
echo 915 >> ${SITE}_paramset_only.mos
echo 14 >> ${SITE}_paramset_only.mos
echo confb- >> ${SITE}_paramset_only.mos
echo gs- >> ${SITE}_paramset_only.mos

echo "Script creation is finished"
echo 'Here you are your scripts:'
pwd
ls -l
echo
echo '"Jules: Vincent! We happy?"'
echo '"Vincent: Yeah, we happy."'
echo '-=Pulp Fiction=-'

