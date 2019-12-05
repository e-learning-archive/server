#!/bin/sh

docker-compose down
cd streamer && git pull origin master && cd ..
cd encoder && git pull origin master && cd ..
docker-compose up
