#/bin/bash

deldir=$1
drainto=80
oldestday=365

if [[ ! -d "${deldir}" ]] || [[ -z "${deldir}" ]] ;then
   echo "(${deldir}) is empty or not a directory"
   echo "This script requires a directory to eat within"
   echo "for example: /data/"
   exit 1
fi
 
dfused=$(df -P ${deldir} |awk '{print $5}' |egrep -o "[[:digit:]][[:digit:]]")

echo "dfused is ${dfused}"
while [[ ${dfused} -gt ${drainto} ]] ;do
   echo "${dfused}% used is greater then ${drainto}% removing files > $oldestday old"
   find $deldir -mtime +${oldestday} -ls -delete
   ((oldestday -= 1))
   dfused=$(df -P ${deldir} |awk '{print $5}' |egrep -o "[[:digit:]][[:digit:]]")
   if [[ $oldestday -le 1 ]] ;then
     echo "ran out of days, oldestday is $oldestday"
     exit 1
   fi
done

