#!/bin/sh

GIT="$HOME/bin/git"
REPO_LOC="$HOME/workspace/block_dedup"
LOG_FILE="$HOME/workspace/cron_git_pull.log"

function log_msg {
    local msg=$1;

    if [ ! -f $LOG_FILE ]; then
        touch $LOG_FILE
    fi

    local timestamp=`date +"%x %X"`
    echo "$timestamp : $msg" >> $LOG_FILE
}


log_msg "Begin to pull $REPO_LOC"
cd "$REPO_LOC"
if [ $? -ne 0 ]; then
    log_msg "Fail to cd $REPO_LOC"
    exit 1
fi
log_msg "Succeed to cd $REPO_LOC"

$GIT pull >>$LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log_msg "Fail to git pull"
    exit 1
fi
log_msg "Succeed to pull $REPO_LOC"
