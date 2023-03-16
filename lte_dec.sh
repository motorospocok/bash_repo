 #!/bin/bash
          if [ -z "$1" ]; then
              echo usage: lte_dec.sh "<log_file_name>"
			  echo ltetools should be installed to "~/ltetools"
			  echo decoded files are stored under "~/decoded"
			  echo " "
			  echo also: lte_dec.sh "<log_file_name> c"
			  echo sends the the logfile to the flow cloud
              exit
          fi
		  if [ -z "$2" ]; then
			  utvonal=`pwd`		  
			  filenev=$1
			  celfiled="decoded_"$filenev
			  echo 'starting decoding the log file'
			  cat $utvonal/$filenev | ~/ltng/bin/ltng-decoder -s > ~/decoded/$celfiled
			  echo 'decoding finished'
			  echo 'starting lteflowfox'
			  #~/ltetools/flowfox -f ~/decoded/$celfiled
			  ~/old_ltng/bin/ltng-flow -f $utvonal/$filenev --html ~/decoded/$celfiled.html 
			  ~/ltng/bin/ltng-flow -f $utvonal/$filenev > ~/decoded/$celfiled.flow 
			  echo 'flowfox finished'
			  echo 'Packing files...'
			  zip -j $filenev.zip $filenev
			  zip -j $filenev.zip ~/decoded/decoded_$filenev*
			  echo 'Operation completed, check your files in: '$filenev.zip
		  fi
		  if [ "$2" = "c" ]; then
			  filenev=$1
			  echo 'Cloud operation about to start...'
			  ltng-flow --cloud --file $filenev
		  fi