#!/bin/bash

echo -e '\033[34mChecking requirements\033[39m'

# check if docker is running
docker info >/dev/null 2>&1
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo -e '\033[31m\xE2\x9C\x98 Docker not running!\n\033[39m'
  echo "You need to have a working Docker installation to run this script."
  echo "You can validate if you have setup Docker correctly by running 'docker info'."
  echo "Exiting."
  exit 1
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

echo -e '\033[34mStopping services\033[39m'
docker-compose down
