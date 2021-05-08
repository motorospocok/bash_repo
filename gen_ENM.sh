#!/bin/bash
#This script creates ENM files from a list file and batch files
#Written for support Telekom ENM gempa

site_name=($(cat $1 | awk 'BEGIN {FS=";"}{print $1}'))
context=($(cat $1 | awk 'BEGIN {FS=";"}{print $2}'))
ip_address=($(cat $1 | awk 'BEGIN {FS=";"}{print $4}'))
number=${#site_name[@]}
((number--))
echo ${site[1]} ${site[2]}
echo '<Entities xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="EntitiesSchema.xsd">' >> EP.xml
for ((b=0;b<=$number;b++))
	do 
		echo 'cmedit create NetworkElement='${site_name[$b]}' networkElementId='${site_name[$b]}', neType=RadioNode, ossPrefix="'${context[$b]}'" -ns=OSS_NE_DEF -v=2.0.0' >> ENM_def.txt
		echo 'cmedit create NetworkElement='${site_name[$b]}', ComConnectivityInformation=1 ComConnectivityInformationId=1, transportProtocol=TLS, ipAddress="'${ip_address[$b]}'", port=6513 -ns=COM_MED -v=1.1.0' >> ENM_def.txt
		echo 'secadm credentials create -sn rbs -sp "rbs" -n '${site_name[$b]} >> ENM_def.txt
		echo 'cmedit set '${site_name[$b]}' CmNodeHeartbeatSupervision active=true' >> switch_on.txt
		echo 'cmedit set '${site_name[$b]}' PmFunction pmEnabled=true' >> switch_on.txt
		echo 'cmedit set '${site_name[$b]}' InventorySupervision active=true' >> switch_on.txt
		echo 'alarm enable '${site_name[$b]} >> switch_on.txt
		echo '  <Entity>' >> EP.xml
		echo '    <PublishCertificatetoTDPS>true</PublishCertificatetoTDPS>' >> EP.xml
		echo '    <EntityProfile Name="DUSGen2OAM_CHAIN_EP"/>' >> EP.xml
		echo '    <KeyGenerationAlgorithm>' >> EP.xml
		echo '      <Name>RSA</Name>' >> EP.xml
		echo '      <KeySize>2048</KeySize>' >> EP.xml
		echo '    </KeyGenerationAlgorithm>' >> EP.xml
		echo '    <Category>' >> EP.xml
		echo '      <Modifiable>true</Modifiable>' >> EP.xml
		echo '      <Name>NODE-OAM</Name>' >> EP.xml
		echo '    </Category>' >> EP.xml
		echo '    <EntityInfo>' >> EP.xml
		echo '      <Name>'${site_name[$b]}'-oam</Name>' >> EP.xml
		echo '      <Subject>' >> EP.xml
		echo '        <SubjectField>' >> EP.xml
		echo '          <Type>ORGANIZATION</Type>' >> EP.xml
		echo '          <Value>DT</Value>' >> EP.xml
		echo '        </SubjectField>' >> EP.xml
		echo '        <SubjectField>' >> EP.xml
		echo '          <Type>ORGANIZATION_UNIT</Type>' >> EP.xml
		echo '          <Value>SSC</Value>' >> EP.xml
		echo '        </SubjectField>' >> EP.xml
		echo '        <SubjectField>' >> EP.xml
		echo '          <Type>COUNTRY_NAME</Type>' >> EP.xml
		echo '          <Value>HU</Value>' >> EP.xml
		echo '        </SubjectField>' >> EP.xml
		echo '        <SubjectField>' >> EP.xml
		echo '          <Type>COMMON_NAME</Type>' >> EP.xml
		echo '          <Value>'${site_name[$b]}'-oam</Value>' >> EP.xml
		echo '        </SubjectField>' >> EP.xml
		echo '      </Subject>' >> EP.xml
		echo '    </EntityInfo>' >> EP.xml
		echo '  </Entity>' >> EP.xml
	done

echo '</Entities>' >> EP.xml
