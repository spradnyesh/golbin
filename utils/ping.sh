#! /bin/bash

# */30 * * * * curl http://www.golb.in/ > /home/hawksbill/golbin/heartbeat/golb.in.html 2> /dev/null
# * * * * * /home/hawksbill/golbin/scripts/ping.sh > /home/hawksbill/golbin/heartbeat/golb.in.article.html 2> /dev/null

r=$RANDOM
j=$(( r %= 1000 ))
curl --connect-timeout 5 "www.golb.in/title-of-$j.html"
