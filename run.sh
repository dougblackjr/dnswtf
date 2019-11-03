#!/bin/bash
DOMAINLIST="$(pwd)/domains.list"
MAIL="/usr/bin/mail"
EMAILS="$(pwd)/emails.list"

OLDLOG="$(pwd)/monitordns.OLD"
NEWLOG="$(pwd)/monitordns.CURRENT"
TEMPLOG="$(pwd)/monitordns.$$"

echo 	> $OLDLOG
mv $NEWLOG $OLDLOG

while read line
do

echo "Checking $line:" | tee -a $NEWLOG

dig $line A +short | tee -a $NEWLOG

echo "" | tee -a $NEWLOG

done < $DOMAINLIST

echo "-------------------------------------------------------------"

diff -y --suppress-common-lines $OLDLOG $NEWLOG > $TEMPLOG

if [ -s $TEMPLOG ] ; then

  for EMAIL in $EMAILS

  do

    $MAIL -s "DNS status update" $EMAIL < $TEMPLOG

  done < $EMAILS

fi

rm -f $TEMPLOG