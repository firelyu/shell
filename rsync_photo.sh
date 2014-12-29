#!/bin/sh

SRC_ROOT='Photography'
#SRC_ROOT='百度云同步盘'
DEST_ROOT='/Volumes/PHOTOGRAPHY'

SLEEP_SEC=45

for subdir in $(find $SRC_ROOT -mindepth 2 -maxdepth 2 -type d); do
    # Skip the . dir
#    echo "$subdir" | grep -e "$SRC_ROOT/\." > /dev/null
#    if [ $? -eq 0 ]; then
    if [[ "$subdir" =~ "$SRC_ROOT/." ]]; then
        echo "Skip the $subdir"
        continue
    fi

    src_dir="$subdir/"
    dest_dir="$DEST_ROOT/$subdir"

    if [ -d "$dest_dir" ]; then
        echo "$dest_dir : existed"

        echo "/usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store \"$src_dir\" \"$dest_dir\""
        /usr/local/bin/rsync -r -v -t --iconv utf8,utf-8 --delete --exclude=.DS_Store "$src_dir" "$dest_dir"

    else
        echo "copy to the new dir"
        
        echo "mkdir -p $dest_dir"
        mkdir -p "$dest_dir"
        
        echo "cp -r \"$src_dir\" \"$dest_dir\""
        cp -R "$src_dir" "$dest_dir"
    
        sleep $SLEEP_SEC
        
    fi

done

