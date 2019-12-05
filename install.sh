#!/bin/bash
echo -e "\e[32mGetting YouPHPTube source code\e[39m"
git clone https://github.com/DanielnetoDotCom/YouPHPTube.git streamer || true
git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git encoder || true

# The images don't build if we use PHP 7.4 (which is what is installed
# if we do 'FROM php:7-apache'), so we manually downgrade to PHP 7.3
sed -i "s/FROM php:7-apache/FROM php:7.3-apache/g" streamer/Dockerfile
sed -i "s/FROM php:7-apache/FROM php:7.3-apache/g" encoder/Dockerfile

# Adjustments to make the 'download' button work correctly
sed -i "s/apt-get install -y/apt-get install -y libapache2-mod-xsendfile/g" streamer/Dockerfile
sed -i "s/a2enmod rewrite/a2enmod rewrite xsendfile/g" streamer/Dockerfile

set -a
source .env

# Start database
echo -e "\e[32mInstalling database\e[39m"
docker-compose up --no-start db
docker-compose start db
sleep 10

# load databases
echo -e "\e[32mCreating users & loading database dumps\e[39m"
cat config/streamer.sql | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
cat config/encoder.sql | docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD}
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON video.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"
docker exec -i `docker-compose ps -q db` /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON encoder.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"

# create docker volumes and copy in their respective configuration files. Make sure to use
# the configuration values from the .env file
echo -e "\e[32mBuilding ${STREAMER_HOSTNAME} streaming site\e[39m"
docker-compose up --no-start streamer
sed -i s/MYSQL_USER/${MYSQL_USER}/g config/streamer/configuration.php
sed -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/streamer/configuration.php
sed -i s/STREAMER_HOSTNAME/${STREAMER_HOSTNAME}/g config/streamer/configuration.php
docker run --rm -v $PWD:/source -v gulu_streamer_videos:/dest -w /source alpine cp config/streamer/configuration.php /dest
git checkout -- config/streamer/configuration.php

echo -e "\e[32mBuilding ${ENCODER_HOSTNAME} video encoder site\e[39m"
docker-compose up --no-start encoder
sed -i s/MYSQL_USER/${MYSQL_USER}/g config/encoder/configuration.php
sed -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g config/encoder/configuration.php
sed -i s/ENCODER_HOSTNAME/${ENCODER_HOSTNAME}/g config/encoder/configuration.php
docker run --rm -v $PWD:/source -v gulu_encoder_videos:/dest -w /source alpine cp config/encoder/configuration.php /dest
git checkout -- config/encoder/configuration.php

# finally, bring everything online
echo -e "\e[32mStarting services\e[39m"
docker-compose up
