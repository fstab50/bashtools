#!/usr/bin/env bash


function get_regions(){
    ##
    ##
    ##
    local i="0"
    local location
    local profilename="$1"
    local regioncode="$2"
    local tmp='/tmp'

    declare -a arr_regions

    if [ -z "$(type jq 2>/dev/null)" ] || [ -z "$(type aws 2>/dev/null)" ]; then
        printf -- 'DependencyFail\n'
        return 1

    elif [ $regioncode ]; then
        arr_regions=( "$regioncode" )

    else
        # collect list of all current AWS Regions globally:
        aws ec2 describe-regions --profile $profilename --output json > $tmp/.regions.json
        arr_regions=( "$(jq -r .Regions[].RegionName $tmp/.regions.json)" )
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
    echo "$region : $location"
    return 0
    #
    # << --- end function get_regions --->>
}

get_regions "$1"
