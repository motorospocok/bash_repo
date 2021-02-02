 #!/bin/bash
		  if [ -z "$1" ]; then
			  echo " "
			  echo usage: ueCAP.sh "<log_file_name> <outputfile>"
			  echo ' '
			  echo The output file is optional - when no outputfile defined 
			  echo then cap string will be added to the original filename for output
			  echo e.g "excample.log -> cap_example.log"
			  echo " "
			  exit
		  fi
		  utvonal=`pwd`		  
		  filenev=$1
		  if [ -z "$2" ]; then
			outPutFile="cap_"$filenev
		  else
			  outPutFile=$2
		  fi
		  echo 'Starting decoding the log file'
		  /home/ETHTOJA/bin/perl_scripts/UE_cap/uecap.ig $1 > $outPutFile
		  echo 'Capability decoding finished'
		  
		  echo 'Operation completed, check your files in: '$outPutFile