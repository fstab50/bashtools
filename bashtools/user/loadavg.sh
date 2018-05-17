#!/usr/bin/env bash

pkg=$(basename $0)          # pkg reported in logs will be the basename of the caller
pkg_path=$(cd $(dirname $0); pwd -P)
source $pkg_path/colors.sh

bd=$(echo -e ${bold})
bgn=$(echo -e ${bold}${brightgreen})
gn=$(echo -e ${green})
byl=$(echo -e ${bold}${brightyellow2})
yl=$(echo -e ${yellow})
rd=$(echo -e ${bold}${red})

ONE_MIN=$(cat /proc/loadavg | awk '{print $1}')
FIVE_MIN=$(cat /proc/loadavg | awk '{print $2}')
FIF_MIN=$(cat /proc/loadavg | awk '{print $3}')


# ---  declarations   -----------------------------------------------------------------------------


function set_1min(){
    if (( $(echo "$ONE_MIN < 1.0" | bc -l) )); then
        ONE_MIN="${bgn}$ONE_MIN${reset}"
        ONE_DESC="(${gn}Low)${reset}"
    elif (( $(echo "$ONE_MIN > 1.0" | bc -l) )) && (( $(echo "$ONE_MIN < 2.0" | bc -l) )); then
        ONE_MIN="${byl}$ONE_MIN${reset}"
        ONE_DESC="(${yl}Med${reset})"
    else
        ONE_MIN="${rd}$ONE_MIN${reset}"
        ONE_DESC="${red}(Hi)${reset}"
    fi
}

function set_5min(){
    if (( $(echo "$FIVE_MIN < 1.0" | bc -l) )); then
        FIVE_MIN="${bgn}$FIVE_MIN${reset}"
        FIVE_DESC="(${gn}Low)${reset}"
    elif (( $(echo "$FIVE_MIN > 1.0" | bc -l) )) && (( $(echo "$FIVE_MIN < 2.0" | bc -l) )); then
        FIVE_MIN="${byl}$FIVE_MIN${reset}"
        FIVE_DESC="(${yl}Med${reset})"
    else
        FIVE_MIN="${rd}$FIVE_MIN${reset}"
        FIVE_DESC="${red}(Hi)${reset}"
    fi
}

function set_15min(){
    if (( $(echo "$FIF_MIN < 1.0" | bc -l) )); then
        FIF_MIN="${bgn}$FIF_MIN${reset}"
        FIF_DESC="(${gn}Low)${reset}"
    elif (( $(echo "$FIF_MIN > 1.0" | bc -l) )) && (( $(echo "$FIF_MIN < 2.0" | bc -l) )); then
        FIF_MIN="${byl}$FIF_MIN${reset}"
        FIF_DESC="(${yl}Med${reset})"
    else
        FIF_MIN="${rd}$FIF_MIN${reset}"
        FIF_DESC="${red}(Hi)${reset}"
    fi
}


# ---   main   -----------------------------------------------------------------------------------

# set load average colors per time slice
set_1min
set_5min
set_15min

# formats
tabs='\t\t\t\t'
ta='\t\t      '

# output
echo -e "\t  ${bd}LOAD AVERAGES${reset}:" | indent25
echo -e "\t  _______________________________________\n" | indent25
printf "$tabs  1-minute:$ta $ONE_MIN $ONE_DESC\n$tabs  5-minute:$ta $FIVE_MIN $FIVE_DESC\n$tabs  15-minute:$ta $FIF_MIN $FIF_DESC\n\n"

exit 0
