#! /bin/bash

r=$RANDOM
j=$(( r %= 1000 ))
curl --connect-timeout 5 "www.golb.in/title-of-$j.html"
