#!/bin/bash

cd /home/hawksbill/golbin
ga data/db/prod
git commit -am "s db frd @ `date +%F--%T`"
