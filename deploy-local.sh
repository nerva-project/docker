#!/bin/bash

IMG_NAME="nerva/node-local"

# Create host directories
mkdir -p ${HOME}/.nerva-docker
mkdir -p ${HOME}/.nerva-docker/wallets
mkdir -p ${HOME}/.nerva-docker/blockchain

# Create the image
docker build -t ${IMG_NAME}:latest -f ./Dockerfile .

if [ ! -f "${HOME}/.nerva-docker/quicksync.raw" ]; then
    echo Downloading quicksync file
    wget -O ${HOME}/.nerva-docker/quicksync.raw https://bitbucket.org/nerva-project/nerva/downloads/quicksync.raw
fi

# Run it
docker run --rm -v ${HOME}/.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" \
--publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 19566:19566 -t ${IMG_NAME}:latest /bin/bash
