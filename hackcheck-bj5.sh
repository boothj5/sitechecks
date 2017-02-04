#!/bin/bash

echo
read -s -p "Enter password: " PASS
export SSHPASS=$PASS

echo
echo
echo Removing previous contents...
rm -rf public_html
rm -rf logfiles
rm -f posts.log

echo
echo Downloading contents...
sshpass -e scp -r ftp@boothj5.com@94.136.40.103:/public_html .

echo
echo Looking for php files...
find public_html -name \*.php

echo
echo Downloading access log...
mkdir logfiles
sshpass -e scp ftp@boothj5.com@94.136.40.103:/logfiles/*-$1-*.log logfiles/.

echo
echo Scanning for POST requests...
ack-grep POST logfiles > posts.log
POST_COUNT=$(wc -l posts.log | cut -d' ' -f1)
if [ $POST_COUNT -gt 0 ]; then
    echo !! Found POST requests, see posts.log
else
    echo No POST requests found
fi
