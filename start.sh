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

# check if the server has been installed
serverNotInstalled() {
  echo -e '\033[32mServer not installed yet!\033[39m'
  echo "You first need to install the server."
  if ! [ -z "$1" ]; then
    echo "- Service '${1}' not configured"
  fi
  echo "Run './install.sh' to get started."
  echo "Exiting."
  exit 3
}

if ! [ -d 'src/streamer' ] || ! [ -d 'src/encoder' ] || ! [ -d 'src/coursera-dl' ] || ! [ -d 'src/edx-dl' ]; then
  serverNotInstalled
fi

checkService() {
  service=$1
  printf " - Checking service '${service}'..."
  docker-compose ps -q "$service" >/dev/null

  exitCode=$?
  if [ $exitCode -ne 0 ]; then
    serverNotInstalled "$service"
  fi
  echo -e '\033[32m installed\033[39m'
}

echo -e '\033[34mChecking if installation was completed\033[39m'
checkService 'db'
checkService 'streamer'
checkService 'encoder'
checkService 'nginx-proxy'
checkService 'coursera'
checkService 'edx'
printf "\033[32m\xE2\x9C\x94 all services installed\n\n\n\033[39m"

# make sure everything in 'downloads' folder is writeable by processes inside Docker
find downloads -type d -exec chmod 777 {} \;
find downloads -type f -exec chmod 666 {} \;

echo -e '\033[34mStarting services\033[39m'
docker-compose up -d

# make sure we can use docker from within the 'encoder' container
docker-compose exec --user root -d encoder chown root:docker /var/run/docker.sock
