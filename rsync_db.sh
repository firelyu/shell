#!/bin/sh
LOCAL_BASE_DIR='/Users/liaoyu/Workspace/hywgj001'

REMOTE_USER='user'
REMOTE_HOST='host'
REMOTE_DIR_LIST='/var/mysql_backup/ /var/log/'

for dir in ${REMOTE_DIR_LIST}; do
    if [ ! -d ${LOCAL_BASE_DIR}${dir} ]; then
        mkdir -p ${LOCAL_BASE_DIR}${dir}
    fi
    rsync -avzr  -oroot ${REMOTE_USER}@${REMOTE_HOST}:${dir} ${LOCAL_BASE_DIR}${dir}
done
