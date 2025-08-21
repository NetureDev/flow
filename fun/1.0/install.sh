#!/bin/bash

read -p "Start Matrix rain? (y/n): " confirm

clear
if [[ $confirm == "y" || $confirm == "Y" ]]; then
  echo -e "\033[32my\033[0m"
  sleep 3
else
  echo -e "\033[31mn\033[0m"
  sleep 3
  exit 0
fi

tput civis
while :; do
  echo -e "\033[32m$(jot -r 1 20 80 | awk '{for(i=0;i<$1;i++) printf " "; printf "%c", 33+int(rand()*94)}')\033[0m"
  sleep 0.0005
done
