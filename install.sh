#!/bin/bash

if ! [ -f '.env' ]; then
  echo -e '\033[32mThe .env file does not exist!!\033[39m'
  echo "Create one by copying the .env.example file and adjusting the values."
  echo "Exiting."
  exit 1
fi

# we checkout all the required software
echo -e '\033[32mGetting source code\033[39m'
git clone https://github.com/e-learning-archive/AVideo.git streamer || true
git clone https://github.com/e-learning-archive/AVideo-Encoder.git encoder || true
git clone https://github.com/e-learning-archive/coursera-dl.git || true
git clone https://github.com/e-learning-archive/edx-dl.git || true


# if the 'gsed' command exists, use that - otherwise, default to 'sed'
if [ -x "$(command -v gsed)" ]; then
  SED=`which gsed`
else
  SED=`which sed`
fi

set -a
source .env

# Start database
echo -e "\033[32mInstalling database\033[39m"
docker-compose up --no-start db
docker-compose start db
sleep 10

# load databases
echo -e "\033[32mCreating users & loading database dumps\033[39m"
cat config/streamer.sql | $SED s/STREAMER_URL/${STREAMER_URL}/g | $SED s/ENCODER_URL/${ENCODER_URL}/g | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
cat config/encoder.sql | $SED s/STREAMER_URL/${STREAMER_URL}/g | $SED s/ENCODER_URL/${ENCODER_URL}/g | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON video.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON encoder.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"

# create docker volumes and copy in their respective configuration files. Make sure to use
# the configuration values from the .env file
echo -e "\033[32mBuilding ${STREAMER_HOSTNAME} streaming site\033[39m"

# Try to install the AVideo software

# The images don't build if we use PHP 7.4 (which is what is installed
# if we do 'FROM php:7-apache'), so we manually downgrade to PHP 7.3
$SED -i 's/FROM php:7-apache/FROM php:7.3-apache/g' streamer/Dockerfile

# Adjustments to make the 'download' button work correctly
$SED -i 's/apt-get install -y/apt-get install -y libapache2-mod-xsendfile/g' streamer/Dockerfile
$SED -i 's/a2enmod rewrite/a2enmod rewrite xsendfile/g' streamer/Dockerfile
docker-compose up --no-start streamer
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/streamer/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/streamer/configuration.php
$SED -i s/STREAMER_HOSTNAME/${STREAMER_HOSTNAME}/g config/streamer/configuration.php
docker run --rm -v $PWD:/source -v gulu_streamer_videos:/dest -w /source alpine cp config/streamer/configuration.php /dest
git checkout -- config/streamer/configuration.php

echo -e "\033[32mBuilding ${ENCODER_HOSTNAME} video encoder site\033[39m"
$SED -i 's/FROM php:7-apache/FROM php:7.3-apache/g' encoder/Dockerfile
docker-compose up --no-start encoder
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/encoder/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/encoder/configuration.php
$SED -i s/ENCODER_HOSTNAME/${ENCODER_HOSTNAME}/g config/encoder/configuration.php
docker run --rm -v $PWD:/source -v gulu_encoder_videos:/dest -w /source alpine cp config/encoder/configuration.php /dest
git checkout -- config/encoder/configuration.php


# get the coursera downloader
# -> use the repository that has a fix for https://github.com/coursera-dl/coursera-dl/issues/702
echo -e "\033[32mInstalling Coursera downloader\033[39m"

# Change the Dockerfile so that it installs the version from the cloned repository
$SED -i '/^ARG VERSION/i ADD . \/app' coursera-dl/Dockerfile
$SED -i 's/RUN pip install coursera-dl==\$VERSION/RUN pip install app -r app\/requirements.txt/g' coursera-dl/Dockerfile
$SED -i 's/ENTRYPOINT \["coursera-dl"\]/ENTRYPOINT \["\/app\/coursera-dl"\]/g' coursera-dl/Dockerfile
docker-compose up --no-start coursera

# get the edX downloader
echo -e "\033[32mInstalling edX downloader\033[39m"
docker-compose up --no-start edx


# finally, bring everything online
echo -e "\033[32mStarting services\033[39m"
docker-compose up -d
