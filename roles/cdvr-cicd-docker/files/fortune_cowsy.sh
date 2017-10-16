#!/bin/bash
# Ron Compos, 08-11-2017
# Randomly run cowsay or cowthink at login

motd=/etc/profile.d/motd.sh

if [[ `grep CentOS /etc/redhat-release` ]]; then
  lpath='/usr/bin'
elif [ `grep "CentOS.*release 7\." /etc/redhat-release` ]; then
  lpath='/bin'
elif [ `grep Red\ Hat /etc/redhat-release` ]; then
  lpath='/bin'
else
  echo "Unsupported OS: "
  cat /etc/redhat-release
  exit 1
fi

if [ ! -f $motd ]; then
  echo "if [ \$RANDOM -lt 16383 ]; then ${lpath}/fortune | ${lpath}/cowsay; else ${lpath}/fortune | ${lpath}/cowthink; fi" > $motd
  #if [ $RANDOM -lt 16383 ]; then echo up; else echo down; fi
  #echo "File exists: $motd"
fi
