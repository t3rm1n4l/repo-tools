#!/bin/bash

if [ $# -ne 2 ];
then
    echo "Usage: $0 N"
    exit 1
fi

rewind_no=$1
cmd=$2

head=`git log --oneline | head -1  | awk '{ print $1 }'`

while [ $rewind_no -gt 0 ];
do
    commit="$head~$rewind_no"
    git checkout "$commit" > validation.txt 2>&1
    echo -n "verifying $commit ..."
    $cmd > validation.txt 2>&1
    if [ $? -ne 0 ];
    then
        echo "FAILED"
        exit 2
    fi
    echo "OK"
    let rewind_no--
done

