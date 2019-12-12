#!/bin/sh

docker-compose down
yes | docker system prune -a
yes | docker volume prune
rm -rf src/encoder/
rm -rf src/streamer/
rm -rf src/coursera-dl/
rm -rf src/edx-dl/

