#!/usr/bin/env bash
#_________________________________________________________________________
#
#
#  Author:   Blake Huber
#  Purpose:  bash shell environment scripts
#  Location:
#  Requires: awscli, jq
#
#_________________________________________________________________________

#
# global variables
#
pkg=$(basename $0)
pkg_path=$(cd $(dirname $0); pwd -P)
host=$(hostname)
system=$(uname)
debugMode=""    # change this value to "True" to turn on verbose \
                # log output to aid debugging


# error codes
E_DEPENDENCY=1        # exit code if missing required dependency
E_DIR=2               # exit code if failure to create log dir, log file
E_BADSHELL=3          # exit code if incorrect shell detected
E_AUTHFAIL=5          # exit code if authentication failure
E_BADPROFILE=6        # exit code if profile name/ role not found in local config
E_USER_CANCEL=7       # exit code if user cancel
E_BADARG=8            # exit code if bad input parameter
E_MISC=11             # exit code if miscellaneous (unspecified) error                    # exit code if miscellaneous (unspecified) error

# Formatting
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
green=$(tput setaf 2)
purple=$(tput setaf 5)
red=$(tput setaf 1)
white=$(tput setaf 7)
yellow=$(tput setaf 3)
orange='\033[38;5;95;38;5;214m'
gray=$(tput setaf 008)
lgray='\033[38;5;95;38;5;245m'    # light gray
dgray='\033[38;5;95;38;5;8m'      # dark gray
reset=$(tput sgr0)
#
#
BOLD=`tput bold`
UNBOLD=`tput sgr0`

accent=$(tput setaf 008)
ansi=$(echo -e ${orange})   # use for ansi escape color codes

#
# function declaration  ------------------------------------------------------
#

# indent
indent02() { sed 's/^/  /'; }
indent10() { sed 's/^/          /'; }
indent15() { sed 's/^/               /'; }
indent18() { sed 's/^/                  /'; }

function s3du(){
    local bucket
    local profile
    #
    if [[ ! "$@" ]]; then
        cat <<EOM

 Help Contents :
 -------------

    ${white}${BOLD}Usage${UNBOLD}${reset} : s3du -b ${ansi}<${reset}bucket${ansi}>${reset} -p ${ansi}<${reset}profile${ansi}>${reset}

    ${white}${BOLD}OPTIONS${UNBOLD}${reset} :
        -b  : s3 bucketname
        -p  : iam role profile

    ${BOLD}>>${UNBOLD} For default profile, omit parameter

EOM
    else
        while [ $# -gt 0 ]; do
            case $1 in
                -b) bucket=$2; shift 2 ;;
                -p) profile=$2; shift 2 ;;
            esac
        done
        if [ ! $profile ]; then
            aws s3 ls s3://$bucket --recursive --summarize --human-readable
        else
            aws s3 ls --profile $profile s3://$bucket \
                --recursive --summarize --human-readable
        fi
    fi
}

s3du

#
#<-- end functions ---------------------------------------------------------------
#
