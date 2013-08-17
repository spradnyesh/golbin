#! /bin/bash

# */30 * * * * curl http://www.golb.in/ > $HOME/golbin/logs/golb.in.html 2> /dev/null
# * * * * * $HOME/golbin/scripts/ping.sh > $HOME/golbin/logs/golb.in.article.html 2> /dev/null

r=$RANDOM
j=$(( r %= 1000 ))
curl --connect-timeout 5 "www.golb.in/title-of-$j.html"
