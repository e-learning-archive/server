#!/bin/bash


# we checkout all the required software
download() {
  repo=$1
  dir=$2
  desc=$3
  branch=$4
  echo -e "\033[32m- ${desc}\033[39m"

  if ! [ -d "$dir" ]; then
    git clone "$repo" "$dir" || true

    if ! [ -z "$branch" ]; then
      pwd=$(pwd)
      cd "$dir"
      git checkout -t "$branch" || true
      cd "$pwd"
    fi
  else
    echo -e "  ⤏ fetching latest version"
    pwd=$(pwd)
    cd "$dir"
    git pull
    cd "$pwd"
  fi
}

echo -e '\033[34mUpdating all software\033[39m'
download https://github.com/e-learning-archive/AVideo.git src/streamer "video streamer"
download https://github.com/e-learning-archive/AVideo-Encoder.git src/encoder "video encoder" "origin/e-learning-archive"
download https://github.com/e-learning-archive/coursera-dl.git src/coursera-dl "coursera downloader"
download https://github.com/e-learning-archive/edx-dl.git src/edx-dl "edX downloader"