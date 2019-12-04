#!/bin/sh

git clone https://github.com/DanielnetoDotCom/YouPHPTube.git streamer || true
git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git encoder || true

# The images don't build if we use PHP 7.4 (which is what is installed
# if we do 'FROM php:7-apache'), so we manually downgrade to PHP 7.3
sed -i "s/FROM php:7-apache/FROM php:7.3-apache/g" streamer/Dockerfile
sed -i "s/FROM php:7-apache/FROM php:7.3-apache/g" encoder/Dockerfile

set -a
source .env
docker-compose up
