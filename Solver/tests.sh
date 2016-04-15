#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: tests.sh <executable> <dir_tests>"
    exit 1
fi
if [ ! -d $2 ]; then
    echo "Error: $2 is not a directory"
    exit 1
fi
if [ ! -x $1 ]; then
    echo "Error: $1 is not an executable"
    exit 1
fi

echo -n > res.txt
echo -n > log.txt

i=1
count=$( ls $2*.cnf | wc -l )
for f in $2*.cnf ; do 
    echo "$i of $count"    
    echo -e -n "$(basename $f)\n==============================\n" 1>> log.txt
    echo -e -n "$(basename $f)\n==============================\n" 1>> res.txt

    $1 < $f 1>> res.txt 2>> log.txt
    echo 1>> res.txt
    echo 1>> log.txt
    ((++i))
done
