#!/bin/sh

JPG='JPG'
RAW='CR2'

PHOTO_BASE="$HOME/Pictures/Photo"
RAW_BASE="$HOME/Pictures/RAW"

TARGET_DIR='2013/20131012/九寨沟'
#TARGET_DIR='test'

TARGET_PHOTO_DIR="$PHOTO_BASE/$TARGET_DIR"
TARGET_RAW_DIR="$RAW_BASE/$TARGET_DIR"

for jpg in `find $TARGET_PHOTO_DIR -type f -iname "*.$JPG"`
do
    #echo "JPG:"
    dir=$(dirname $jpg)
    file=$(basename $jpg)
    #echo $dir
    #echo $file
    
    #echo "RAW:"
    target_raw_dir=$(echo $dir | sed 's/Photo/RAW/')
    #echo $raw_dir
    target_raw_file=$(echo $file | sed "s/$JPG/$RAW/")
    #echo $raw_file
    
    target_raw=$(find $TARGET_RAW_DIR -type f -name $target_raw_file)
    
    if [ "$target_raw" == "" ]; then
        continue
    fi
    
    current_raw_dir=$(dirname $target_raw)
    if [ "$current_raw_dir" != "$target_raw_dir" ]; then
        if [ ! -d "$target_raw_dir" ]; then
            echo "mkdir -p $target_raw_dir"
            mkdir -p $target_raw_dir
        fi
        echo "mv $target_raw $target_raw_dir/$target_raw_file"
        mv $target_raw $target_raw_dir/$target_raw_file
    fi
    
done