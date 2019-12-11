#!/bin/bash

if ! [ -f '.env' ]; then
  echo -e '\033[32mThe .env file does not exist!!\033[39m'
  echo "Create one by copying the .env.example file and adjusting the values."
  echo "Exiting."
  exit 1
fi

# we checkout a 'known good version' of the required software
echo -e '\033[32mGetting AVideo source code\033[39m'
git clone https://github.com/WWBN/AVideo.git streamer || true
cd streamer && git reset --hard 2dae06ebdb9f3c912e86b5a96baf0a32f3d59972 && cd ..
git clone https://github.com/WWBN/AVideo-Encoder.git encoder || true
cd streamer && git reset --hard b5cca3ef906ce9659f3249b7319374e2c74d8217 && cd ..

# if the 'gsed' command exists, use that - otherwise, default to 'sed'
if [ -x "$(command -v gsed)" ]; then
  SED=`which gsed`
else
  SED=`which sed`
fi

# The images don't build if we use PHP 7.4 (which is what is installed
# if we do 'FROM php:7-apache'), so we manually downgrade to PHP 7.3
$SED -i "s/FROM php:7-apache/FROM php:7.3-apache/g" streamer/Dockerfile
$SED -i "s/FROM php:7-apache/FROM php:7.3-apache/g" encoder/Dockerfile

# Adjustments to make the 'download' button work correctly
$SED -i "s/apt-get install -y/apt-get install -y libapache2-mod-xsendfile/g" streamer/Dockerfile
$SED -i "s/a2enmod rewrite/a2enmod rewrite xsendfile/g" streamer/Dockerfile

set -a
source .env

# Start database
echo -e "\033[32mInstalling database\033[39m"
docker-compose up --no-start db
docker-compose start db
sleep 10

# load databases
echo -e "\033[32mCreating users & loading database dumps\033[39m"
cat config/streamer.sql | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
cat config/encoder.sql | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON video.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON encoder.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"

# create docker volumes and copy in their respective configuration files. Make sure to use
# the configuration values from the .env file
echo -e "\033[32mBuilding ${STREAMER_HOSTNAME} streaming site\033[39m"
docker-compose up --no-start streamer
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/streamer/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/streamer/configuration.php
$SED -i s/STREAMER_HOSTNAME/${STREAMER_HOSTNAME}/g config/streamer/configuration.php
docker run --rm -v $PWD:/source -v gulu_streamer_videos:/dest -w /source alpine cp config/streamer/configuration.php /dest
git checkout -- config/streamer/configuration.php

echo -e "\033[32mBuilding ${ENCODER_HOSTNAME} video encoder site\033[39m"
docker-compose up --no-start encoder
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/encoder/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/encoder/configuration.php
$SED -i s/ENCODER_HOSTNAME/${ENCODER_HOSTNAME}/g config/encoder/configuration.php
docker run --rm -v $PWD:/source -v gulu_encoder_videos:/dest -w /source alpine cp config/encoder/configuration.php /dest
git checkout -- config/encoder/configuration.php

# finally, bring everything online
echo -e "\033[32mStarting services\033[39m"
docker-compose up -d
