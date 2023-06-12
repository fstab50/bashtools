#!/usr/bin/env bash

# ansi codes
a_brightblue='\033[38;5;51m'
a_brightcyan='\033[38;5;36m'
a_brightgreen='\033[38;5;95;38;5;46m'
a_brightwhite='\033[38;5;15m'

# formatting
bold='\u001b[1m'
reset=$(tput sgr0)
bbc=$(echo -e ${bold}${a_brightcyan})
bc=$(echo -e ${a_brightcyan})
bbw=$(echo -e ${bold}${a_brightwhite})
bbg=$(echo -e ${a_brightgreen})


function get_regions(){
    ##
    ##
    ##
    local i="0"
    local location
    local profilename="$1"
    local regioncode="$2"
    local tmp='/tmp'

    if [ ! "$1" ]; then profilename='default'; fi

    declare -a arr_regions

    if [ -z "$(type jq 2>/dev/null)" ] || [ -z "$(type aws 2>/dev/null)" ]; then
        printf -- 'DependencyFail\n'
        return 1

    elif [ $regioncode ]; then
        arr_regions=( "$regioncode" )

    else
        # collect list of all current AWS Regions globally:
        aws ec2 describe-regions --profile $profilename --output json > $tmp/.regions.json
        arr_regions=( "$(jq -r .Regions[].RegionName $tmp/.regions.json | sort)" )
    fi

    for region in ${arr_regions[@]}; do
        # set region location description
        case "$region" in
            ap-northeast-1)
                location="Asia Pacific (Tokyo, Japan)"
    	        ;;
    		ap-northeast-2)
    	        location="Asia Pacific (Seoul, Korea)"
                ;;
    	    ap-south-1)
    	        location="Asia Pacific (Mumbai, India)"
    	        ;;
            ap-southeast-1)
                location="Asia Pacific (Singapore)"
                ;;
            ap-southeast-2)
                location="Asia Pacific (Sydney, Austrailia)"
                ;;
            ca-central-1)
                location="Canada (Central)"
                ;;
            eu-west-1)
                location="Europe (Ireland)"
                ;;
            eu-west-2)
                location="Europe (London, UK)"
                ;;
            eu-north-1)
                location="Europe (Stockholm, Sweden)"
                ;;
            eu-west-3)
                location="Europe (Paris, France)"
                ;;
            eu-central-1)
                location="Europe (Frankfurt, Germany)"
                ;;
            sa-east-1)
                location="South America (Sao Paulo, Brazil)"
                ;;
            us-east-1)
                location="United States (N. Virgina)"
                ;;
            us-east-2)
                location="United States (Ohio)"
                ;;
            us-west-1)
                location="United States (N. California)"
                ;;
            us-west-2)
                location="United States (Oregon)"
                ;;
            *)
                location="New Region"
                ;;
        esac

        if [ ! $regioncode ]; then printf -- '%s\t%s\n' "$region" "$location"; fi

        i=$(( i+1 ))
    done
    return 0
    #
    # << --- end function get_regions --->>
}

get_regions "$1"
