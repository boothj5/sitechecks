#!/bin/bash

# first argument is properties file with the following properties.
# If password is not specified, the script prompts to enter one
#
# FTP properties
#   user=ftp@myserver.com
#   server=192.168.0.0.10
#   password=mypassword
#
# Local folder to store downloaded contents
#   folder=myserver
#
# Access logs to check
#   year=2017
#   month=Feb

RED='\033[0;31m'
GREEN='\033[0;32m'
DEF='\033[0m'

. $1

if [ "x$password" = "x" ]; then
    echo
    read -s -p "Enter password: " PASS
    export SSHPASS=$PASS
    echo
else
    export SSHPASS=$password
fi

rm -rf $folder
mkdir $folder

echo
echo Downloading access log...
mkdir $folder/logfiles
sshpass -e scp $user@$server:/logfiles/$year-$month-*.log $folder/logfiles/.

echo Scanning for POST requests...
grep POST $folder/logfiles/* > $folder/posts.log
POST_COUNT=$(wc -l $folder/posts.log | cut -d' ' -f1)
if [ $POST_COUNT -gt 0 ]; then
    if [ $POST_COUNT -eq 1 ]; then
        echo -e ${RED}Found 1 POST request, see $folder/posts.log${DEF}
    else
        echo -e ${RED}Found $POST_COUNT POST requests, see $folder/posts.log${DEF}
    fi
else
    echo -e ${GREEN}No POST requests found${DEF}
fi

echo
echo Downloading contents...
sshpass -e scp -r $user@$server:/public_html $folder/.

echo Looking for PHP files...
find $folder/public_html -name \*.php > $folder/phpfiles.log
PHP_COUNT=$(wc -l $folder/phpfiles.log | cut -d' ' -f1)
if [ $PHP_COUNT -gt 0 ]; then
    if [ $PHP_COUNT -eq 1 ]; then
        echo -e ${RED}Found 1 PHP file, see $folder/phpfiles.log${DEF}
    else
        echo -e ${RED}Found $PHP_COUNT PHP files, see $folder/phpfiles.log${DEF}
    fi
else
    echo -e ${GREEN}No PHP files found${DEF}
fi
echo
