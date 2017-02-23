#!/bin/sh

MYSQLDUMP='/usr/bin/mysqldump'
GZIP='/bin/gzip'

DB_USER='root'
DB_PASSWORD='thangga2015'

BACKUP_DB_LIST='xuexiao qiche mysql demo'
BACKUP_DB_DIR='/var/mysql_backup'
BACKUP_DB_SUFFIX='sql.gz'

LOG_FILE="${BACKUP_DB_DIR}/backup_mysql.log"

function log() {
    tag="$1"
    msg="$2"
    echo "$(date +"%F %H:%M:%S") [${tag}] $msg" >> ${LOG_FILE}
}

function usage() {
    echo "$0 [backup|clean]"
}

function backup_one_db() {
    dbName="$1"
    
    subDir=`date +"%Y%m%d"`
    subDir="${BACKUP_DB_DIR}/${subDir}"
    if [ ! -d "${subDir}" ]; then
        mkdir ${subDir}
    fi
    
    timestamp=`date +"%Y%m%d_%H%M%S"`
    backupDbName="${dbName}_${timestamp}.${BACKUP_DB_SUFFIX}"
    backupDbName="${subDir}/${backupDbName}"

    cmd="${MYSQLDUMP} --opt --user=${DB_USER} --password=${DB_PASSWORD} --default-character-set=utf8 ${dbName} | ${GZIP} > ${backupDbName}"
    log "INFO" "$cmd"
    ${MYSQLDUMP} --opt --user=${DB_USER} --password=${DB_PASSWORD} --default-character-set=utf8 ${dbName} | ${GZIP} > ${backupDbName} 

    rc=$?
    if [ $rc -eq 0 ]; then
        log "INFO" "Backup ${dbName} to ${backupDbName} successful."
        return 0
    else
        log "ERROR" "Fail to backup ${dbName} to ${backupDbName}."
        return 1
    fi
}

function rm_one_old_db() {
    dbName="$1"
    
    year=$(date +%Y)

    currentMonth=$(date +%m)
    lastMonth=$((currentMonth - 1))
    if [ ${#lastMonth} -eq 1 ]; then
        lastMonth="0$lastMonth"
    fi
    
    for dir in `find ${BACKUP_DB_DIR} -type d -name "${year}${lastMonth}[0-9][0-9]"`; do
        cmd="rm -f $dir/${dbName}_*.${BACKUP_DB_SUFFIX}"
        log "INFO" "$cmd"       
        rm -f $dir/${dbName}_*.${BACKUP_DB_SUFFIX}
        if [ "$(ls -A $dir)" = "" ]; then
            cmd="rm -rf $dir"
            log "INFO" "$cmd"
            rm -rf $dir
        fi
    done

}

# main
operation=$1

if [ "${operation}" = "backup" ]; then
    for db in $BACKUP_DB_LIST; do
        backup_one_db ${db}
    done
elif [ "${operation}" = "clean" ]; then
    for db in $BACKUP_DB_LIST; do
        rm_one_old_db ${db}
    done
else
    usage
fi
