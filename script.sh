#!/bin/bash
#Script to generate PCI results and save file to Desktop.
#Writeen by: Daniel D. Sleinsky
# date: Aug 7th, 2019 for Mojave 10.14.6

RESULTS_PATH="/Users/aa507426/Desktop/PCI_Results"
RESULTS="${RESULTS_PATH}/PCI_Results"
KERNEL="$(uname)"

function active_processes() {
  echo "*** CURRENT ACTIVE PROCESSES ****" 
  ps aux 
}

function startup_items() {
  echo "**** STARTUP ITEMS ****" 
  if [ "$KERNEL" == "Linux" ]; then 
    # There's no great way to do this, so we will just rely on systemd
    systemctl list-units --type service 
  elif [ "$KERNEL" == "Darwin" ]; then 
    ls /System/Library/StartupItems  
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi
}

function active_ports() {
  echo "**** ACTIVE PORTS ****" 
  netstat -a | grep ESTABLISHED  
}

function installed_software() {
  echo "**** INSTALLED APPLICATIONS WITH VESION ****" 
  if [ "$KERNEL" == "Darwin" ]; then 
    # Rather than look through the entire system (which takes a long long time and is IO intensive, 
    # let's look in the most common places:
    find /Applications -iname '*.app' -type d 
    find /Users -iname '*.app' -type d 
  elif [ "$KERNEL" == "Linux" ] ; then
    if [ -e "/etc/redhat-release" ] ; then 
      # On a RedHat machine, we use yum
      yum list installed
    else 
      # if not redhat, assume debian family
      apt list --installed 
    fi
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi   
}

function security_updates() {
  # This really just prints the version of the OS, not all of the sec updates
  echo "**** SECURITY UPDATES ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
    if [ -e "/etc/redhat-release" ] ; then 
      cat /etc/redhat-release
    else
      cat /etc/issue
    fi
  elif [ "$KERNEL" == "Darwin" ] ; then 
    sw_vers -productVersion 
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi   
}

function product_version() {
  echo "**** OS UPDATES ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
    uname -a
    if [ -e "/etc/redhat-release" ] ; then 
      cat /etc/redhat-release
    else
      cat /etc/issue
    fi
  elif [ "$KERNEL" == "Darwin" ] ; then 
    sw_vers
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi   
}

function firewall_rules() {
  echo "**** FIREWALL RULES ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
     iptables -S
  elif [ "$KERNEL" == "Darwin" ] ; then 
    /usr/libexec/ApplicationFirewall/socketfilterfw --listapps 
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi   
}

function autologin_settings() {
  echo "**** AUTOLOGIN SETTINGS ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
    echo "Skipping check on linux"
  elif [ "$KERNEL" == "Darwin" ] ; then 
    defaults read /Library/Preferences/com.apple.loginwindow 
  else 
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi
}

function screensaver_settings() {
  echo "**** SCREEN SAVER SETTINGS ****"
  if [ "$KERNEL" == "Linux" ] ; then 
    echo "Skipping check on linux"
  elif [ "$KERNEL" == "Darwin" ] ; then 
    osascript -e 'tell application "System Events" to tell security preferences to get require password to wake'
  else 
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi
}

function ntp_settings() {
echo "**** NTP SETTING ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
    systemctl status ntpd
    cat /etc/ntp.conf
  elif [ "$KERNEL" == "Darwin" ] ; then 
    cat /etc/ntp.conf
  else 
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi
}

function last_logins() { 
  echo "**** LAST LOGIN DATE AND USER ****" 
  last | head -n 2
}

function get_hostname() {
  echo "**** HOSTNAME ****" 
  hostname
}

function network_interfaces() {
  echo "**** NETWORK INTERFACE WITH IPS ****" 
  ifconfig 
}

function local_users() {
  echo "**** LOCAL USER ACCOUNTS ****" 
  if [ "$KERNEL" == "Linux" ] ; then 
    cat /etc/passwd | awk -F: '{print $1}' 
  elif [ "$KERNEL" == "Darwin" ] ; then 
    dscl . list /Users | grep -v '_'
  else
    echo "### ERROR - unsupported platform: ${KERNEL} ###" 
  fi
}

RESULTS="${PWD}/out.txt"
touch $RESULTS
echo "Below are the PCI findings." >> $RESULTS

active_processes >> $RESULTS
startup_items >> $RESULTS
active_ports >> $RESULTS
installed_software >> $RESULTS
security_updates >> $RESULTS
product_version >> $RESULTS
firewall_rules >> $RESULTS
autologin_settings >> $RESULTS
screensaver_settings >> $RESULTS 
ntp_settings >> $RESULTS
last_logins >> $RESULTS 
get_hostname >> $RESULTS
network_interfaces >> $RESULTS 
local_users >> $RESULTS

