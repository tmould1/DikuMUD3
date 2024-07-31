#!/bin/bash

done=0

function signals()
{
  if [ $done -eq 0 ]; then
    kill $(pgrep vme)
    kill $(pgrep mplex)
  fi
  done=1
}

trap signals INT TERM EXIT HUP

service nginx restart
cd /dikumud3/vme/bin
rm -f vme.log mplex.log
tail -F vme.log mplex.log &
./vme &
./mplex -w -p 4280 &
./mplex -p 4242 &

while [ $done -eq 0 ]
do
  sleep 1
done

echo -e "\n\nFinished\n"