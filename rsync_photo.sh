#!/bin/sh

SRC_ROOT='Photography'
DEST_ROOT='/Volumes/PHOTOGRAPHY'

SLEEP_SEC=45

for subdir in $(find $SRC_ROOT -mindepth 2 -maxdepth 2 -type d); do
    src_dir="$subdir/"
    dest_dir="$DEST_ROOT/$subdir"

    if [ -d "$dest_dir" ]; then
        echo "rsync the existed dir"

        echo "/usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store \"$src_dir\" \"$dest_dir\""
        /usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store "$src_dir" "$dest_dir"

    else
        echo "copy to the new dir"
        
        echo "mkdir -p $dest_dir"
        mkdir -p "$dest_dir"
        
        echo "cp -r \"$src_dir\" \"$dest_dir\""
        cp -R "$src_dir" "$dest_dir"
        
    fi
    
    sleep $SLEEP_SEC

done

