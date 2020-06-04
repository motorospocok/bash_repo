 #!/bin/bash
          if [ -z "$1" ]; then
              echo usage: lte_dec.sh "<log_file_name>"
			  echo ltetools should be installed to "~/ltetools"
			  echo decoded files are stored under "~/decoded"
              exit
          fi
		  utvonal=`pwd`		  
          filenev=$1
		  celfiled="decoded_"$filenev
		  echo 'starting decoding the log file'
		  cat $utvonal/$filenev | ~/ltng/bin/ltng-decoder -s > ~/decoded/$celfiled
		  echo 'decoding finished'
		  echo 'starting lteflowfox'
		  #~/ltetools/flowfox -f ~/decoded/$celfiled
		  ~/ltng/bin/ltng-flow -f $utvonal/$filenev --html ~/decoded/$celfiled.html 
		  ~/ltng/bin/ltng-flow -f $utvonal/$filenev > ~/decoded/$celfiled.flow
		  echo 'flowfox finished'
		  echo 'Packing files...'
		  zip -j $filenev.zip $filenev
		  zip -j $filenev.zip ~/decoded/decoded_$filenev*
		  echo 'Operation completed, check your files in: '$filenev.zip