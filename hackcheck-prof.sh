#!/bin/bash

echo
read -s -p "Enter password: " PASS
export SSHPASS=$PASS

echo
echo
echo Removing previous contents...
rm -rf public_html
rm -rf logfiles

echo
echo Downloading contents...
sshpass -e scp -r ftp@profanity.im@94.136.40.103:/public_html .

echo
echo Looking for php files...
find public_html -name \*.php

echo
echo Downloading access log...
mkdir logfiles
sshpass -e scp ftp@profanity.im@94.136.40.103:/logfiles/*-$1-*.log logfiles/.

echo
echo Scanning for POST requests...
ack POST logfiles
