#!/bin/bash

if [ -z "$1" ];  then
    echo
    echo This script written to merge indenpedent mo script function files into one file
    echo Do not use wildcards in the cmd line
    echo 
    echo usage: build_func.sh "<function_files_filter> <output_file>"
    echo
    echo example: build_func.sh function_file result.mos
    echo all filenames starting with function_file will be collected and merged into result.mos
    echo
    exit
fi
if [ -z "$2" ];  then
    echo
    echo This script written to merge indenpedent mo script function files into one file
    echo Do not use wildcards in the cmd line
    echo 
    echo usage: build_func.sh "<function_files_filter> <output_file>"
    echo
    echo example: build_func.sh function result.mos
    echo all filenames starting with function will be collected and merged into result.mos
    echo
    exit
fi



file_name=$1
out_file=$2
ls -l ${file_name}* | awk 'BEGIN {FS=" "}{print $9}' > temp.list
sed -i s/*// temp.list
file_list=($(cat temp.list))
list_size=${#file_list[@]}
((list_size--))
for ((b=0;b<=$list_size;b++))
    do
        sed -n '/^function/,/^endfunc/p;/^endfunc/q' ${file_list[$b]} > ${file_list[$b]}_functemp
        echo ' ' >> ${file_list[$b]}_functemp
	done
echo '####### Function declaration parts start here ##################' >> ${out_file}
echo ' '  >> ${out_file}
cat *_functemp >> ${out_file}
echo '####### Function declaration parts end ##################' >> ${out_file}
echo ' '  >> ${out_file}
echo '####################### Following FUNCTIONS are declared above #######################'  >> ${out_file}
echo ' '  >> ${out_file}
cat ${out_file} | grep function | awk 'BEGIN {FS=" "}{print "## "$2}' >> ${out_file}
echo ' '  >> ${out_file}
echo '####################### END OF FUNCTION LIST #######################'  >> ${out_file}
rm *_functemp
rm temp.list


