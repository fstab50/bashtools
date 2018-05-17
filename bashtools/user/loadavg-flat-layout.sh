#!/usr/bin/env bash

pkg=$(basename $0)          # pkg reported in logs will be the basename of the caller
pkg_path=$(cd $(dirname $0); pwd -P)
host=$(hostname)
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
tabs='\t '
ta='  '

# output
if [ "$(grep -i VERSION /etc/os-release | head -n1 | grep "16.04")" ]; then
    echo -e "$tabs ${bd}LOAD AVERAGES${reset}" | indent25
    echo -e "$tabs _________________________________________\n" | indent25
    printf "$tabs 1-min: $ONE_MIN | 5-min$: $FIVE_MIN | 15-min: $FIF_MIN\n\n" | indent25
elif [ "$host" = "mint18-1" ]; then
    echo -e "$tabs _________________________________________\n" | indent25
    echo -e "$tabs\t   ${bd}LOAD AVERAGES${reset}: $(printf "1-min: $ONE_MIN | 5-min$: $FIVE_MIN | 15-min: $FIF_MIN")\n"
else
    echo -e "$tabs ${bd}LOAD AVERAGES${reset}" | indent25
    echo -e "$tabs _________________________________________\n" | indent25
    printf "$tabs 1-min: $ONE_MIN | 5-min: $FIVE_MIN | 15-min: $FIF_MIN\n\n" | indent25
fi

exit 0
