#!/bin/bash

IMG_NAME="nerva/node:latest"
docker build -t ${IMG_NAME} -f ./Dockerfile .
docker push ${IMG_NAME}
