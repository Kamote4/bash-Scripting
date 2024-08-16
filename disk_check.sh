#!/bin/bash
OPTSTRING=":c:w:e:"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    #c) echo "Option -c was triggered, Critical Threshold: ${OPTARG}%" ;;
    c) critical=$OPTARG;;
    w) warning=$OPTARG;;
    e) email=$OPTARG;;
    :) echo "Option -${OPTARG} requires an argument." ;;
    #?) echo "Invalid option: ${OPTARG}." ;;
    ?) echo "Invalid option: $OPTARG";
    exit ;;
  esac 
done 

if [[ -z $critical ]]; then
  echo "Error: Missing required parameter -c (Critical Threshold)"
fi
if [[ -z $warning ]]; then
  echo "Error: Missing required parameter -w (Warning Threshold)"
fi
if [[ -z $email ]]; then
  echo "Error: Missing required parameter -e (Email Address)"
fi
if [[ -z "$email" || -z "$critical" || -z "$warning" ]]; then
  echo "Usage: $0 -c <critical threshold> -w <warning threshold> -e <email address>"
  exit 
fi
if [[ $critical -le $warning ]]; then
  echo "Error: Critical threshold must be greater than warning threshold."
  exit
fi

echo This is the critical value $critical%
echo This is the warning value $warning%
echo Sending this email to $email

printf "\n"
#df -h
#DISK_PARTITION=$( df -P | awk '0+$5 >= $thresholds {print}')
#echo $DISK_PARTITION
df --output=size --output=used
printf "\n"
disk_total=$(df --output=size --total | awk 'END {print $1}')
echo Total disk: $disk_total
disk_used=$(df --output=used --total | awk 'END {print $1}')
echo Total disk used: $disk_used
disk_usedP=$(( 100 * disk_used/disk_total))
echo Used Percentage Memory: $disk_usedP%
#totalsomething=$ //total of disk space
#something2=$((100 * usesomething/totalsomething))
#echo $something2

if [[ $disk_usedP -ge $critical ]]; then
  echo "2"
  exit 2
fi

if [[ $disk_usedP -ge $warning && $disk_usedP -lt $critical ]]; then
  echo "1"
  exit 1
fi

if [[ $disk_usedP -lt $warning ]]; then
  echo "0"
  exit 0
fi
