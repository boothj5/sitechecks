#!/bin/bash

. $1

echo
read -s -p "Enter password: " PASS
export SSHPASS=$PASS

echo
echo
echo Removing previous contents...

rm -rf $folder
mkdir $folder

echo
echo Downloading contents...
sshpass -e scp -r $user@$server:/public_html $folder/.

echo
echo Looking for php files...
find $folder/public_html -name \*.php

echo
echo Downloading access log...
mkdir $folder/logfiles
sshpass -e scp $user@$server:/logfiles/$year-$month-*.log $folder/logfiles/.

echo
echo Scanning for POST requests...
grep POST $folder/logfiles/* > $folder/posts.log
POST_COUNT=$(wc -l $folder/posts.log | cut -d' ' -f1)
if [ $POST_COUNT -gt 0 ]; then
    echo !! Found POST requests, see $folder/posts.log !!
else
    echo No POST requests found
fi
