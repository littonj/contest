#!/bin/sh

cd /home/ubuntu
sleep 30
APP_ENV=production /usr/bin/ruby /home/ubuntu/app.rb >> app.log 2>&1
