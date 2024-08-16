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
if [[ $critical -le $warning ]]; then
  echo "Error: Critical threshold must be greater than warning threshold."
fi
if [[ -z "$email" || -z "$critical" || -z "$warning" ]]; then
  echo "Usage: $0 -c <critical threshold> -w <warning threshold> -e <email address>"
  exit 
fi

echo This is the critical value $critical%
echo This is the critical value $warning%
echo Sending this email to $email

printf "\n"
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }')
echo "Total Memory: "$TOTAL_MEMORY
USED_MEMORY=$( free | grep Mem: | awk '{ print $3 }')
echo "Used Memory: "$USED_MEMORY
USED_PERCENTM=$(( 100 * USED_MEMORY/TOTAL_MEMORY))
echo "Used Percentage Memory: "$USED_PERCENTM%

if [[ $USED_PERCENTM -ge $critical ]]; then
  echo "2"

  exit 2
fi

if [[ $USED_PERCENTM -ge $warning && $USED_PERCENTM -lt $critical ]]; then
  echo "1"
  exit 1
fi

if [[ $USED_PERCENTM -lt $warning ]]; then
  echo "0"
  exit 0
fi
