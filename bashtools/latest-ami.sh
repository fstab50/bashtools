#!/usr/bin/env bash

# globals
pkg=$(basename $0)                                   # pkg (script) full name
pkg_root="$(echo $pkg | awk -F '.' '{print $1}')"    # pkg without file extention
pkg_path=$(cd $(dirname $0); pwd -P)                 # location of pkg
year=$(date +'%Y')
PROFILE="$1"
TYPE="$2"
DBUGMODE="$2"                                       # "true" to produce output when exec from cli;
                                                    # otherwise source this file

declare -A LATEST

source $pkg_path/std_functions.sh
source $pkg_path/colors.sh


function array2json(){
    ## converts associative array to single-level (no nested keys) json file output ##
    #
    #   Caller syntax:
    #       $ array2json config_dict $config_path/configuration_file
    #
    #   where:
    #       $ declare -A config_dict        # config_dict is assoc array, declared in main script
    #
    local -n array_dict=$1      # local assoc array must use -n opt
    local output_file=$2        # location
    local ct                    # counter
    local max_keys              # num keys in array
    #
    echo -e "{" > $output_file
    ct=1
    max_keys=${#array_dict[@]}
    for key in ${!array_dict[@]}; do
        if [ $ct == $max_keys ]; then
            # last key, no comma
            echo "\"${key}\": \"${array_dict[${key}]}\"" | indent04 >> $output_file
        else
            echo "\"${key}\": \"${array_dict[${key}]}\"," | indent04 >> $output_file
        fi
        ct=$(( $ct + 1 ))
    done
    echo -e "}" >> $output_file
    #
    # <-- end function array2json -->
}

function get_regions(){
    local profile="$1"
    declare -a regions
    regions="$(aws --profile $profile ec2 describe-regions --profile gcreds-da-atos | jq -r .Regions[].RegionName)"
    echo "${regions[@]}"
}

function amazonlinux(){
    ## amazonlinux latest AMI ##
    local profile="$1"
    local version="$2"
    local output_file='/tmp/amazon_amis.json'
    #
    if [ ! $profile ]; then
        echo "You must include the aws profilename as the first parameter and name of output file as 2nd parameter."
        exit 1
    elif [ ! $version ]; then
        version="1"
    fi
    # retrieve info from aws
    for region in $(get_regions $profile); do
        if [ "$version" = "1" ]; then
            ami=$(aws ec2 describe-images --profile $profile \
                --owners amazon  \
                --region $region \
                --filters "Name=name,Values=amzn-ami-hvm-????.??.?.$year????-x86_64-gp2" \
                --query 'sort_by(Images, &CreationDate) | [-1].ImageId')
        else
            version="2"
            ami=$(aws ec2 describe-images --profile $profile \
                --owners amazon  \
                --region $region \
                --filters "Name=name,Values=amzn2-ami-hvm-????.??.?.$year????.?-x86_64-gp2,amzn2-ami-hvm-????.??.?.$year????-x86_64-gp2 " \
                --query 'sort_by(Images, &CreationDate) | [-1].ImageId')
        fi
        ami=$(echo $ami | cut -c 2-15 | rev | cut -c 2-15 | rev)
        if [ $DBUGMODE ]; then printf "$region:\t%s\n" $ami; fi
        LATEST[$region]=$ami
    done
    # create json
    if [ -f $output_file ]; then rm $output_file; fi
    array2json LATEST $output_file
    cat $output_file | jq .
    return 0
}

function redhat(){
    local profile="$1"
    local version="$2"
    local output_file='/tmp/redhat_amis.json'
    #
    if [ ! $profile ]; then
        echo "You must include the aws profilename as the first parameter and name of output file as 2nd parameter."
        exit 1
    elif [ ! $version ]; then
        version="7.?"     # provides latest; otherwise, request specific release with "7.4", "7.3" etc
    fi
    # retrieve info from aws
    for region in $(get_regions $profile); do
        #ami=$(aws --profile $profile ec2 describe-images --owners 309956199498 --query 'Images[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-7.?*GA*" --region $region --output json)
        ami=$(aws ec2 describe-images \
            --owners 309956199498 \
            --region $region \
            --profile $profile \
            --filters "Name=name,Values=RHEL-$version*GA*" --query 'sort_by(Images, &CreationDate) | [-1].ImageId')
        ami=$(echo $ami | cut -c 2-15 | rev | cut -c 2-15 | rev)
        if [ $DBUGMODE ]; then printf "$region:\t%s\n" $ami; fi
        LATEST[$region]=$ami
    done
    # create json
    if [ -f $output_file ]; then rm $output_file; fi
    array2json LATEST $output_file
    cat $output_file | jq .
    return 0
}

if [ "$DBUGMODE" = "true" ] && [ "$TYPE" = "AML1" ]; then
    echo -e "\nAmazon Linux v1 - Latest AMI\n"
    amazonlinux $PROFILE "1"
elif [ "$DBUGMODE" = "true" ] && [ "$TYPE" = "AML2" ]; then
    echo -e "\nAmazon Linux v2 - Latest AMI\n"
    amazonlinux $PROFILE "2"
if [ "$DBUGMODE" = "true" ] && [ "$TYPE" = "redhat" ]; then
    echo -e "\nRedhat Enterprise Linux - Latest AMI\n"
    redhat $PROFILE "7.5"
fi
