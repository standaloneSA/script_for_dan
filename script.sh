#!/bin/bash
#Script to generate PCI results and save file to Desktop.
#Writeen by: Daniel D. Sleinsky
# date: Aug 7th, 2019 for Mojave 10.14.6

RESULTS="/Users/aa507426/Desktop/PCI_Results"

AWK_Args="'FNR <=2'"

Touch $RESULTS

Echo "Below are the PCI findings." >> $RESULTS

Echo "*** CURRENT ACTIVE PROCESSES ****" >> $RESULTS

ps aux >> $RESULTS

Echo "**** STARTUP FOLDER ITEMS ****" >> $RESULTS

ls /System/Library/StartupItems  >> $RESULTS

Echo "**** ACTIVE PORTS ****" >> $RESULTS

netstat -a | grep ESTABLISHED  >> $RESULTS

Echo "**** INSTALLED APPLICATIONS WITH VESION ****" >> $RESULTS

find / -iname *.app >> $RESULTS

Echo "**** SECURITY UPDATES ****" >> $RESULTS

sw_vers -productVersion >> $RESULTS

 Echo "**** OS VERSION ****" >> $RESULTS

sw_vers >> $RESULTS

Echo "**** FIREWALL RULES ****" >> $RESULTS

 /usr/libexec/ApplicationFirewall/socketfilterfw --listapps >> $RESULTS

Echo "**** AUTOLOGIN SETTINGS ****" >> $RESULTS

defaults read /Library/Preferences/com.apple.loginwindow >> $RESULTS

Echo "**** SCREEN SAVER SETTINGS ****" >> $RESULTS

osascript -e 'tell application "System Events" to tell security preferences to get require password to wake'  >> $RESULTS

Echo "**** NTP SETTING ****" >> $RESULTS

cat /etc/ntp.conf  >> $RESULTS

Echo "**** LAST LOGIN DATE AND USER ****" >> $RESULTS

last | awk 'FNR <=2' >> $RESULTS

Echo "**** HOSTNAME ****" >> $RESULTS

scutil --get LocalHostName >> $RESULTS

Echo "**** NETWORK INTERFACE WITH IPS ****" >> $RESULTS

Ifconfig >> $RESULTS

Echo "**** LOCAL USER ACCOUNTS ****" >> $RESULTS

dscl . list /Users | grep -v ‘_’ >> $RESULTS


