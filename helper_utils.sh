#!/bin/sh

get_systemd_file(){
    SERVICE="$1"

    if [ -f "/etc/systemd/system/$SERVICE" ]; then
      echo "/etc/systemd/system/$SERVICE"
    elif systemctl show -p FragmentPath "$SERVICE" 2> /dev/null 1>&2; then
      systemctl show -p FragmentPath "$SERVICE" | sed 's/.*=//'
    else
      echo "/usr/lib/systemd/system/$SERVICE"
    fi
}


# Compares versions of software of the format X.Y.Z
do_version_check() {
    [ "$1" = "$2" ] && return 10

    ver1front=$(printf "%s" "$1" | cut -d "." -f -1)
    ver1back=$(printf "%s" "$1" | cut -d "." -f 2-)
    ver2front=$(printf "%s" "$2" | cut -d "." -f -1)
    ver2back=$(printf "%s" "$2" | cut -d "." -f 2-)

    if [ "$ver1front" != "$1" ] || [ "$ver2front" != "$2" ]; then
        [ "$ver1front" -gt "$ver2front" ] && return 11
        [ "$ver1front" -lt "$ver2front" ] && return 9

        [ "$ver1front" = "$1" ] || [ -z "$ver1back" ] && ver1back=0
        [ "$ver2front" = "$2" ] || [ -z "$ver2back" ] && ver2back=0
        do_version_check "$ver1back" "$ver2back"
        return $?
    else
        [ "$1" -gt "$2" ] && return 11 || return 9
    fi
}

