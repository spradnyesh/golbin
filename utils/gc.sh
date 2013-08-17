#!/bin/bash

# */10 * * * * /home/hawksbill/golbin/scripts/gc.sh 2>&1 >> /home/hawksbill/golbin/gc.log

cd /home/hawksbill/golbin
git add data/db/prod
git commit -am "s db frd @ `date +%F--%T`"
