#!/bin/bash

deldir=$1
drainto=80
oldestday=365

if [[ ! -d "${deldir}" ]] || [[ -z "${deldir}" ]] ;then
   echo "(${deldir}) is empty or not a directory"
   echo "This script requires a directory to eat within"
   echo "for example: /data/"
   exit 1
fi
 
dfused=$(df -P ${deldir} |awk '{print $5}' |sed 's/[^0-9]//g' |tr --delete '\n')
if [[ ${dfused} -le ${drainto} ]]; then
   echo "Nothing to do, dfused(${dfused}%) is <= drainto(${drainto}%)"
   exit 0
fi
while [[ ${dfused} -gt ${drainto} ]] ;do
   echo -e "\n${deldir} is currently using ${dfused}% disk space."
   echo "Press enter to drain to ${drainto}% or ctrl-c to cancel"
   read -p "Files ${oldestday} days or newer will not be deleted"
   find $deldir -type f -mtime +${oldestday} -ls -delete
   ((oldestday -= 1))
   dfused=$(df -P ${deldir} |awk '{print $5}' |egrep -o "[[:digit:]][[:digit:]]")
   if [[ $oldestday -le 1 ]] ;then
     echo "ran out of days, oldestday is $oldestday"
     exit 1
   fi
done
