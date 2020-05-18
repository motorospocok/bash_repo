#!/bin/bash
if [[ $# -ne 3 ]] ; then
        echo "Hiba! Parameterek szama nem 3 darab!"
        echo "Helyes hasznalat:
 ./vago_istvan.sh <selection_filename> <hany darabos cuccot akarok> <kimeneti_file_nev>"
exit 1
fi

re='^[1-9]+[0-9]*$'
if ! [[ $2 =~ $re ]] ; then
        echo "Masodik parameter nem szam!"
        echo "Helyes hasznalat:
 ./vago_istvan.sh <selection_filename> <hany darabos cuccot akarok> <kimeneti_file_nev>"
exit 1
fi

filenev=$1
vonal=$2
ujfile=$3
sort -t, -k3 $filenev > alma

split -l $vonal -a 1 alma
for i in x*;do mv "$i" "${i/x/$ujfile}";done
for i in $ujfile*;do mv "$i" "${i/a/_1}";done
for i in $ujfile*;do mv "$i" "${i/b/_2}";done
for i in $ujfile*;do mv "$i" "${i/c/_3}";done
for i in $ujfile*;do mv "$i" "${i/d/_4}";done
for i in $ujfile*;do mv "$i" "${i/e/_5}";done
for i in $ujfile*;do mv "$i" "${i/f/_6}";done
for i in $ujfile*;do mv "$i" "${i/g/_7}";done
for i in $ujfile*;do mv "$i" "${i/h/_8}";done
for i in $ujfile*;do mv "$i" "${i/i/_9}";done
for i in $ujfile*;do mv "$i" "${i/j/_10}";done
for i in $ujfile*;do mv "$i" "$i.sel"; done
rm alma
