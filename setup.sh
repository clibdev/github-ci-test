#!/bin/bash

if [[ ! $1 =~ ^(build-image|build-app)$ ]]; then
  echo 'Available arguments: build-image, build-app'
  exit 1
fi

if [[ $1 == build-image ]]; then
  docker build -t ninja scripts

  exit 0
fi

if [[ $1 == build-app ]]; then
  docker run --rm -v ./:/app ninja scripts/compile.sh
  sudo chown -R $USER:$USER build

  exit 0
fi
