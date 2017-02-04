#!/bin/bash

echo
echo Removing previous contents...
rm -rf public_html

echo
echo Downloading contents...
export SSHPASS=$1
sshpass -e sftp -oBatchMode=no -b - ftp@boothj5.com@94.136.40.103 << !
    cd ..
    get -r public_html
    exit
!

echo
echo Looking for php files...
find public_html -name \*.php

