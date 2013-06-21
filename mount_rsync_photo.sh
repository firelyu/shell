#!/bin/bash
RSYNC='/usr/local/bin/rsync'
DISKUTIL='/usr/sbin/diskutil'

# Check the uuid of the ntfs disk
# Return
# 0 - The disk uuid equal the input uuid
# 1 - Otherwise
function check_uuid {
    disk="$1"
    target_uuid="$2"

    disk_uuid=`$DISKUTIL info $disk | grep 'Volume UUID' | cut -d':' -f2`
    disk_uuid=`echo $disk_uuid`

    echo "$disk_uuid : $disk"
    echo "$target_uuid : Excepted"

    if [ "$disk_uuid" == "$target_uuid" ]; then
        echo "UUID matched!"
        return 0
    else
        echo "UUID unmatched!!!"
        return 1
    fi
}

# Mount the ntfs disk as rw
# Return
# 0 - Mount the disk as rw
# 1 - Fail
NTFS_FS='ntfs'
NTFS_OPT='nobrowse,rw'
function mount_ntfs {
    disk="$1"
    mp="$2"

    if [ -d "$mp" ]; then
        echo "umount $mp first."
        return 1
    else
        mkdir $mp
    fi
    mount -t $NTFS_FS -o $NTFS_OPT $disk $mp

    return $?
}

# Sync the photos in each dir
# Return
# 0 - Rsync the each sub-directory from src_dir to dst_dir.
# 1 - Fail to rsync in either sub-directory from src_dir to dst_dir.
function rsync_photo {
    src_dir="$1"
    dst_dir="$2"

    for folder in 'Photo' 'RAW' '商业摄影' '婚礼专辑'; do
        src="$src_dir/$folder"
        dst="$dst_dir/$folder"
        $RSYNC -rvt --iconv utf8 --delete "$src/" "$dst/"
        if [ $? -ne 0 ]; then
            echo "Fail to rsync the photoes from $src to $dst."
            return 1
        fi
        echo "Rsync the photoes from $src to $dst."
    done

    return 0
}


# main
disk='disk1'
photo_part="/dev/${disk}s1"
photo_uuid='6E7646E4-7D3C-4259-97BF-819A10C2704A'
check_uuid $photo_part $photo_uuid
[ $? -ne 0 ] && exit 1

root_mp='/Volumes'
photo_mp="$root_mp/Photography"
mount_ntfs $photo_part $photo_mp
[ $? -ne 0 ] && exit 1
echo "Mount the $photo_part on $photo_mp"

while true; do
    echo 'Do you want to continue to rsync the photoes? [Y/N]'
    read chosen
    case $chosen in
    Y|y)
        break
        ;;
    N|n)
        echo "You can do writing operations on the $photo_mp"
        exit 0
        ;;
    "")
        echo "Invalid option."
        ;;
    esac
done

local_photo='/Users/yliao/Pictures'
rsync_photo $local_photo $photo_mp
[ $? -ne 0 ] && exit 1

exit 0
