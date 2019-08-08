#!/bin/bash
#Script to generate PCI results and save file to Desktop.
#Writeen by: Daniel D. Sleinsky
# date: Aug 7th, 2019 for Mojave 10.14.6

RESULTS="/Users/aa507426/Desktop/PCI_Results"
RESULTS="${PWD}/out.txt"


AWK_Args="'FNR <=2'"

touch $RESULTS

echo "Below are the PCI findings." >> $RESULTS

echo "*** CURRENT ACTIVE PROCESSES ****" >> $RESULTS

ps aux >> $RESULTS

echo "**** STARTUP FOLDER ITEMS ****" >> $RESULTS

ls /System/Library/StartupItems  >> $RESULTS

echo "**** ACTIVE PORTS ****" >> $RESULTS

netstat -a | grep ESTABLISHED  >> $RESULTS

echo "**** INSTALLED APPLICATIONS WITH VESION ****" >> $RESULTS

find / -iname *.app >> $RESULTS

echo "**** SECURITY UPDATES ****" >> $RESULTS

sw_vers -productVersion >> $RESULTS

echo "**** OS VERSION ****" >> $RESULTS

sw_vers >> $RESULTS

echo "**** FIREWALL RULES ****" >> $RESULTS

/usr/libexec/ApplicationFirewall/socketfilterfw --listapps >> $RESULTS

echo "**** AUTOLOGIN SETTINGS ****" >> $RESULTS

defaults read /Library/Preferences/com.apple.loginwindow >> $RESULTS

echo "**** SCREEN SAVER SETTINGS ****" >> $RESULTS

osascript -e 'tell application "System Events" to tell security preferences to get require password to wake'  >> $RESULTS

echo "**** NTP SETTING ****" >> $RESULTS

cat /etc/ntp.conf  >> $RESULTS

echo "**** LAST LOGIN DATE AND USER ****" >> $RESULTS

last | awk 'FNR <=2' >> $RESULTS

echo "**** HOSTNAME ****" >> $RESULTS

scutil --get LocalHostName >> $RESULTS

echo "**** NETWORK INTERFACE WITH IPS ****" >> $RESULTS

ifconfig >> $RESULTS

echo "**** LOCAL USER ACCOUNTS ****" >> $RESULTS

dscl . list /Users | grep -v ‘_’ >> $RESULTS

