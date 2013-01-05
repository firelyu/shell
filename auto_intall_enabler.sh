#!/usr/bin

NAVISECCLI=""
ENABLER_PATH=""
ENA_LIST=""
SPA=""
SPB=""
USER=""
PASSWORD=""
SCOPE=""

function install_one_enabler {
    local ena="$1"
    # Check the enabler installed.

    # Install the enabler.
    $NAVISECCLI -user $USER -password $PASSWORD -scope $SCOPE -h $SPA ndu -install $ena
    if [ $? -ne 0 ]; then
        echo "Fail to install $ena"
        return 1
    fi

    # Waiting for the installation complete.
    local waiting_time=600  # 10min
    local interval=`expr $waiting_time  / 2`
    local passing_time=0
    local complete=1
    while [ $complete -ne 0 && $passing_time -lt $waiting_time ]; do
        sleep $interval
        let "passing_time += $interval"

        $NAVISECCLI -user $USER -password $PASSWORD -scope $SCOPE -h $SPA ndu -status | grep -q -e "Is Completed: \+YES"
        if [ $? -eq 0 ]; then
            complete=0
        else
            interval=`expr $interval / 2`
            if [ $interval -eq 0 ]; then
                interval=1
            fi
        fi
    done

    if [ $complete -ne 0 ]; then
        echo "Waiting for $waiting_time seconds, but the ndu of $ena don't complete."
        return 1
    fi

    return 0
}

function main {
    for one_ena in `echo $ENA_LIST | tr ',' '\n'`; do
        install_one_enabler "$ENABLER_PATH/$one_ena" || return 1
    done

    return 0
}

main 
