#!/bin/bash

# ------------------------------------------------------------------------------
# Docker Bench for Security 0.1
#
# Author: Jagadish Manchala
# Email: manja17@ca.com

# Description: Scripts checks for dozens of common best-practices around deploying Docker containers
# Checks based on common best-practices around deploying Docker containers in production
# Inspired by the CIS Docker Community Edition Benchmark v1.1.0.
# ------------------------------------------------------------------------------

. ./logging_config.sh
. ./helper_utils.sh

`rm ./details.log`

LOG_FILE="`pwd`/creation.log"

logit() 
{
    echo "[${USER}][`date`] - ${*}" >> ${LOG_FILE}
}


# sub routine for getting the relative Path of the current location
abspath() {                                               
    cd "$(dirname "$1")"
    printf "%s/%s\n" "$(pwd)" "$(basename "$1")"
    cd "$OLDPWD"
}

# Setup the paths
this_path=$(abspath "$0")        ## Path of this file including filenamel
myname="`pwd`/details"           ## file name of this script.

export PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin/

# Check for required program(s) necessary to run the script
req_progs='awk docker grep netstat stat'

for p in $req_progs; do
  command -v "$p" >/dev/null 2>&1 || { printf "%s command not found.\n" "$p"; exit 1; }
done


# Ensure we can connect to docker daemon
if ! docker ps -q >/dev/null 2>&1; then
  printf "Error connecting to docker daemon (does docker ps work?)\n"
  exit 1
fi


# Warn if not root
ID=$(id -u)
if [ "x$ID" != "x0" ]; then
    warn "Some tests might require root to run"
    sleep 3
fi

#add the Logger

if [ -z "$logger" ]; then
  logger="${myname}.log"
fi

logit "Initializing $(date)\n"

# Load all the tests from tests/ and run them
main () {

for test in tests/*.sh
  do
     . ./"$test"
  done


infoCount=`cat ${myname}.log | grep INFO | wc -l`
passCount=`cat ${myname}.log | grep PASS | wc -l`
warnCount=`cat ${myname}.log | grep WARN | wc -l`

echo -e "\n"
info "= $infoCount"
pass "= $passCount"
warn "= $warnCount"



}

main "$@"
