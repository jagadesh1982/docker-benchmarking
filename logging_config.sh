#!/bin/sh

red='\033[1;31m'
grn='\033[1;32m'
blu='\033[1;34m'
ylw='\033[1;33m' # Yellow
txtrst='\033[0m'

logit () {
  printf "%b\n" "$1" | tee -a "$logger"
}

info () {
  printf "%b\n" "${blu}[INFO]${txtrst} $1" | tee -a "$logger"
}

pass () {
  printf "%b\n" "${grn}[PASS]${txtrst} $1" | tee -a "$logger"
}

warn () {
  printf "%b\n" "${red}[WARN]${txtrst} $1" | tee -a "$logger"
}

note () {
  printf "%b\n" "${ylw}[NOTE]${txtrst} $1" | tee -a "$logger"
}

yell () {
  printf "%b\n" "${ylw}$1${txtrst}\n"
}
