#!/bin/bash

IMG_NAME="nerva/node"

# Create host directories
mkdir -p ${HOME}/.nerva-docker
mkdir -p ${HOME}/.nerva-docker/wallets
mkdir -p ${HOME}/.nerva-docker/blockchain

# Pull the latest image
docker pull ${IMG_NAME}

# Run it
docker run --rm -v ${HOME}/.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" \
--publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 19566:19566 -t ${IMG_NAME}:latest /bin/bash
