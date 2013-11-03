#!/bin/sh

JPG='JPG'
RAW='CR2'

PHOTO_ROOT="$HOME/Pictures/Photo"
RAW_ROOT="$HOME/Pictures/RAW"

TARGET_DIR='2013/20131012/九寨沟'
#TARGET_DIR='test'

TARGET_PHOTO_DIR="$PHOTO_ROOT/$TARGET_DIR"
TARGET_RAW_DIR="$RAW_ROOT/$TARGET_DIR"

PHOTO_DB="./photo.db"
RAW_DB="./raw.db"

find $TARGET_PHOTO_DIR -type f -iname "*.$JPG" > $PHOTO_DB
find $TARGET_RAW_DIR -type f -iname "*.$RAW" > $RAW_DB

while read jpg; do
    #echo $jpg
    jpg_dir=$(dirname $jpg)
    jpg_file=$(basename $jpg)
    
    target_raw_dir=$(echo $jpg_dir | sed 's/Photo/RAW/')
    target_raw_file=$(echo $jpg_file | sed "s/$JPG/$RAW/")
    
    #set -x
    target_raw=$(sed -n "/$target_raw_file/p" $RAW_DB)
    #echo $target_raw
    #set +x
    
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
    
done < $PHOTO_DB

