#!/bin/bash

IMG_NAME="nerva/node"

# Create host directories
mkdir -p ${HOME}/.nerva-docker
mkdir -p ${HOME}/.nerva-docker/wallets
mkdir -p ${HOME}/.nerva-docker/blockchain

# Create the image
docker build -t ${IMG_NAME}:latest -f ./Dockerfile .

# Run it
docker run --rm -v ${HOME}/.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" \
--publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 3001:3001 -t ${IMG_NAME}:latest /bin/bash
