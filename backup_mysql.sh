#!/bin/sh

MYSQLDUMP='/usr/bin/mysqldump'
GZIP='/bin/gzip'

DB_USER='root'
DB_PASSWORD='xxxxxx'

BACKUP_DB_LIST='mysql db1 db2'
BACKUP_DB_DIR='/var/mysql_backup'
BACKUP_DB_SUFFIX='sql.gz'

LOG_FILE="${BACKUP_DB_DIR}/backup_mysql.log"

function log() {
    tag="$1"
    msg="$2"
    echo "[${tag}] $msg" >> ${LOG_FILE}
}

function backup_one_db() {
    dbName="$1"
    
    timestamp=`date +"%Y%m%d_%H%M%S"`
    backupDbName="${dbName}_${timestamp}.${BACKUP_DB_SUFFIX}"
    backupDbName="${BACKUP_DB_DIR}/${backupDbName}"

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

for db in $BACKUP_DB_LIST; do
    backup_one_db ${db}
done

