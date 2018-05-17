#!/usr/bin/env bash

searchname="$1"
searchdir="$2"
target_dir="$2"

mkdir -p $target_dir

for file in "$(find $searchdir -type f -name $searchname)"; do
    dir="$(cat $f | awk -F '/' '{print $2}')"
    echo "Copying $file to $target_dir/$dir-$file"
    #cp "$file" "$target_dir/$dir-$file"
done

exit 0
