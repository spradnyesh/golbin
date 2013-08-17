#!/bin/bash

cd /home/pradyus/golbin
ga data/db/prod
git commit -am "s db frd @ `date +%F--%T`" 2>&1 >> /home/pradyus/gc.log
