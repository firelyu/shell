#!/bin/sh

function cprint() {
    msg="$1"
    printf '\033[32m'
    printf "$msg"
    printf '\033[0m'
    printf "\n"
}

# main
args=$@

for a in $args; do
    cprint "$a"
done

COL_RED="$(tput setaf 1)" 
COL_GREEN="$(tput setaf 2)" 
COL_NORM="$(tput setaf 9)"
COL_ORIGIN="$(tput setaf 0)"
echo "It's ${COL_RED}red${COL_NORM}${COL_ORIGIN} and ${COL_GREEN}green${COL_NORM}${COL_ORIGIN} - have you seen?"
