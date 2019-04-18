#!/bin/sh

git clone https://github.com/DanielnetoDotCom/YouPHPTube.git streamer || true
git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git encoder || true

set -a
source .env
docker-compose up
