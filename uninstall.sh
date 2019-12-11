#!/bin/sh

docker-compose down
yes | docker system prune -a
yes | docker volume prune
rm -rf encoder/
rm -rf streamer/
rm -rf coursera-dl/
rm -rf edx-dl/

