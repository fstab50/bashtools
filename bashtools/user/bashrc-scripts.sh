#!/usr/bin/env bash

#
#   Bash User Scripts
#
#   Source:  Linux Journal
#            https://www.linuxjournal.com/content/developing-console-applications-bash
#
CONFIG_DIR="$HOME/.config/bash"
source "$CONFIG_DIR/colors.sh"

getfilecontent() {
    if [ -f $1 ]; then
        cat $1
    else
        echo "usage: getfilecontent <filename>"
    fi
}

LOADAVG="$(cat /proc/loadavg)"

alias searchdate='grep "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"'

LOAD_AVG=$(awk "{ printf("1-minute: ${title}%s${reset}\n5-minute: %s\n15-minute: %s\n",$1,$2,$3); }" /proc/loadavg)

# Usage:  echo -e $LOADAVG_NOW
LOAD="$(sed "s/^\([0-9]\+\.[0-9]\+\) \([0-9]\+\.[0-9]\+\) \([0-9]\+\.[0-9]\+\).*$/1-minute:${title}\1${reset}\n 5-minute: ${title}\2${reset}\n15-minute: ${title}\3${reset}\n/g" /proc/loadavg)"
LOADAVG_NOW=$(printf "${LOAD}")

pow() {
    if [ -z "$1" ]; then
        echo "usage: pow <base> <exponent>"
    else
        echo "$1^$2" | bc
    fi
}


foldersize() {
    if [ -d $1 ]; then
        ls -alRF $1/ | grep '^-' | awk 'BEGIN {tot=0} {
         ↪tot=tot+$5 } END { print tot }'
    else
        echo "$1: folder does not exist"
    fi
    }


pow2() {
    if [ -z "$1" ]; then
        echo "usage: pow <base> <exponent>"
    else
        echo "$[$1**$2]"
    fi
}

## ---   Cryptography    --------------------------------------------------------------------------

$1.enc
   else
       echo "usage: bf-enc <file> <password>"
   fi
}


bf-dec() {
    if [ -f $1 ] && [ -n "$2" ]; then
        cat $1 | openssl enc -d -blowfish -pass pass:$2 >
         ↪${1%%.enc}
    else
        echo "usage: bf-dec <file> <password>"
    fi
}

md5hash() {
    if [ -z "$1" ]; then
        echo "usage: md5hash <string>"
    else
        echo "$1" | openssl dgst -md5 | sed 's/^.*= //g'
    fi
}

basicauth() {
    if [ -z "$1" ]; then
        echo "usage: basicauth <username>"
    else
        echo "$1:$(read -s -p "Enter password: " pass ;
         ↪echo $pass)" | openssl enc -base64
    fi
}


## ---  Database  ---------------------------------------------------------------------------------

#
SQLITE_BIN=$(ls /usr/bin/sqlite* | grep 'sqlite[0-9]*$' | head -n1)

# create new sqlite database
SQLITE_DATABASE=$(ls /usr/bin/sqlite* | grep 'sqlite[0-9]*$' | head -n1) test.db "CREATE TABLE people(fname text, lname text, age int)"
