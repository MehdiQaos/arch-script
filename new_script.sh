#!/bin/sh

userName="mehdi"
hostName="archmehdi"
userPassword="miq"
rootPassword="miq"
timeZone=""

echo -e "$userName $userPassword $rootPassword $hostName $timeZone" > ./confidentials

echo -e "\nStarting NTP Daemon...\n"

timedatectl set-ntp true

echo -e "\nDone.\n\n"
