#!/bin/sh

cd /home/ubuntu
sleep 30
sudo docker run -dit --name app --publish 4567:4567 --restart unless-stopped breakathon/breakathon-app
