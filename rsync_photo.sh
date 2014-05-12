#!/bin/sh

SRC_ROOT='/Users/yliao/Pictures/Photography'
SRC_ROOT='Photography'
DEST_ROOT='/Volumes/PHOTOGRAPHY'

SLEEP_SEC=120

for subdir in $(find $SRC_ROOT -mindepth 3 -maxdepth 3 -type d); do
    src_dir="$subdir/"
    dest_dir="$DEST_ROOT/$subdir"
    
    if [ ! -d "$dest_dir" ]; then
       echo "mkdir -p $dest_dir"
       mkdir -p $dest_dir

        echo "/usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store $src_dir $dest_dir"
        /usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store $src_dir $dest_dir
        sleep $SLEEP_SEC
    fi

done

