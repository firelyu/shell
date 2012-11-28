#!/bin/sh
# Remove the temp dir under /tmp.
# Exclude some specified dir.

TOP_DIR='/tmp'

for dir in `find $TOP_DIR -mindepth 1 -maxdepth 1 -type d -printf "%f\n"`; do
    if [ "$dir" == "keyring-Murv0q" ]; then
            echo "Don't rm $dir"
            continue
    else
        echo "rm the $dir"
        rm -rf $dir
    fi
done
