#! /bin/bash

r=$RANDOM
j=$(( r %= 1000 ))
curl "www.golb.in/title-of-$j.html"
