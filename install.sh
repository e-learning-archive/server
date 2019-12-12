#!/bin/bash

echo -e '\033[34mChecking requirements\033[39m'

# check preconditions: an .env file
if ! [ -f '.env' ]; then
  echo -e '\033[31m\xE2\x9C\x98 The .env file does not exist!\n\033[39m'
  echo "Create one by copying the .env.example file and adjusting the values."
  echo "Exiting."
  exit 1
fi

printf "\033[32m\xE2\x9C\x94 .env file is present\n\033[39m"


# check if docker is running
docker info >/dev/null 2>&1
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo -e '\033[31m\xE2\x9C\x98 Docker not running!\n\033[39m'
  echo "You need to have a working Docker installation to run this script."
  echo "You can validate if you have setup Docker correctly by running 'docker info'."
  echo "Exiting."
  exit 2
fi
printf "\033[32m\xE2\x9C\x94 Docker is installed\n\033[39m"

# check if docker-compose is available
docker-compose version >/dev/null 2>&1
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo -e '\033[31m\xE2\x9C\x98 Docker Compose not available!\n\033[39m'
  echo "You need to have a working Docker Compose installation to run this script."
  echo "You can validate if you have setup Docker Compose correctly by running 'docker-compose version'."
  echo "Exiting."
  exit 2
fi
printf "\033[32m\xE2\x9C\x94 Docker Compose is installed\n\n\n\033[39m"

# we checkout all the required software
download() {
  repo=$1
  dir=$2
  desc=$3
  echo -e "\033[34m- ${desc}\033[39m"

  if ! [ -d "$dir" ]; then
    git clone "$repo" "$dir" || true
  else
    echo -e "  ⤏ fetching latest version"
    pwd=$(pwd)
    cd "$dir"
    git pull
    cd "$pwd"
  fi
}

echo -e '\033[32mGetting all source code\033[39m'
download https://github.com/e-learning-archive/AVideo.git src/streamer "video streamer"
download https://github.com/e-learning-archive/AVideo-Encoder.git src/encoder "video encoder"
download https://github.com/e-learning-archive/coursera-dl.git src/coursera-dl "coursera downloader"
download https://github.com/e-learning-archive/edx-dl.git src/edx-dl "edX downloader"

# if the 'gsed' command exists, use that - otherwise, default to 'sed'
if [ -x "$(command -v gsed)" ]; then
  SED=$(which gsed)
else
  SED=$(which sed)
fi

set -a
source .env

# Start database
echo -e "\033[32mInstalling database\033[39m"
docker-compose up --no-start db
docker-compose start db
echo -e "\033[34m- Waiting for database to come online\033[39m"
sleep 20

# load databases
echo -e "\033[34m- Creating users & loading database dumps\033[39m"
cat config/streamer.sql | $SED s%STREAMER_URL%${STREAMER_URL}%g | $SED s%ENCODER_URL%${ENCODER_URL}%g | docker exec -i $(docker-compose ps -q db) /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
cat config/encoder.sql | $SED s%STREAMER_URL%${STREAMER_URL}%g | $SED s%ENCODER_URL%${ENCODER_URL}%g | docker exec -i $(docker-compose ps -q db) /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
docker exec -i $(docker-compose ps -q db) /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON video.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"
docker exec -i $(docker-compose ps -q db) /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON encoder.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"

# create docker volumes and copy in their respective configuration files. Make sure to use
# the configuration values from the .env file
echo -e "\033[32mBuilding ${STREAMER_HOSTNAME} streaming site\033[39m"

# Try to install the AVideo software

# The images don't build if we use PHP 7.4 (which is what is installed
# if we do 'FROM php:7-apache'), so we manually downgrade to PHP 7.3
$SED -i 's/FROM php:7-apache/FROM php:7.3-apache/g' src/streamer/Dockerfile

# Adjustments to make the 'download' button work correctly
$SED -i 's/apt-get install -y/apt-get install -y libapache2-mod-xsendfile/g' src/streamer/Dockerfile
$SED -i 's/a2enmod rewrite/a2enmod rewrite xsendfile/g' src/streamer/Dockerfile
docker-compose up --no-start streamer
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/streamer/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/streamer/configuration.php
$SED -i s%STREAMER_HOSTNAME%${STREAMER_URL}%g config/streamer/configuration.php
docker run --rm -v $PWD:/source -v gulu_streamer_videos:/dest -w /source alpine cp config/streamer/configuration.php /dest
git checkout -- config/streamer/configuration.php

echo -e "\033[32mBuilding ${ENCODER_HOSTNAME} video encoder site\033[39m"
$SED -i 's/FROM php:7-apache/FROM php:7.3-apache/g' src/encoder/Dockerfile
docker-compose up --no-start encoder
$SED -i s/MYSQL_USER/${MYSQL_USER}/g config/encoder/configuration.php
$SED -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/encoder/configuration.php
$SED -i s%ENCODER_HOSTNAME%${ENCODER_URL}%g config/encoder/configuration.php
docker run --rm -v $PWD:/source -v gulu_encoder_videos:/dest -w /source alpine cp config/encoder/configuration.php /dest
git checkout -- config/encoder/configuration.php


# get the coursera downloader
# -> use the repository that has a fix for https://github.com/coursera-dl/coursera-dl/issues/702
echo -e "\033[32mInstalling Coursera downloader\033[39m"

# Change the Dockerfile so that it installs the version from the cloned repository
$SED -i '/^ARG VERSION/i ADD . \/app' src/coursera-dl/Dockerfile
$SED -i 's/RUN pip install coursera-dl==\$VERSION/RUN pip install app -r app\/requirements.txt/g' src/coursera-dl/Dockerfile
$SED -i 's/ENTRYPOINT \["coursera-dl"\]/ENTRYPOINT \["\/app\/coursera-dl"\]/g' src/coursera-dl/Dockerfile
docker-compose up --no-start coursera

# get the edX downloader
echo -e "\033[32mInstalling edX downloader\033[39m"
docker-compose up --no-start edx

# build proxy
echo -e "\033[32mBuild proxy\033[39m"
docker-compose up --no-start nginx-proxy

# finally, bring everything online
echo -e "\033[32mStarting services\033[39m"
docker-compose up -d
