#!/bin/bash

function new_version_message()
{
    echo "You currently have an existing Nerva runtime environment."
    echo "This needs to be removed and regenerated with the latest version."
    echo "If you have made modifications to the runtime environment, you should quit now and make a backup before proceeding."
    echo "Would you like to regenerate the runtime environment now? Y/n"
}

# Create host directories
mkdir -p ${HOME}/.nerva-docker
mkdir -p ${HOME}/.nerva-docker/wallets
mkdir -p ${HOME}/.nerva-docker/blockchain

docker pull nerva/node

if [ ! -f "${HOME}/.nerva-docker/quicksync.raw" ]; then
    echo Downloading quicksync file
    wget -O ${HOME}/.nerva-docker/quicksync.raw https://bitbucket.org/nerva-project/nerva/downloads/quicksync.raw
fi

echo "Checking for an existing runtime environment"
if [ "$(docker ps -aq -f name=nerva)" ]; then
    echo "Found"
    echo "Checking if runtime environment is using latest image"
    img_hash=$(docker inspect --format='{{.Id}}' nerva/node)
    container_img_hash=$(docker inspect --format='{{.Image}}' nerva)
    echo "Img: ${img_hash}"
    echo "Env: ${container_img_hash}"
    if [ "${img_hash}" != "${container_img_hash}" ]; then
        # Versions differ. We need to delete this image to update
        new_version_message
        read answer
        if [[ $answer == "N" || $answer == "n" ]]; then
            echo "Aborted!"
            exit 0
        else
            echo "Stopping..."
            docker stop nerva
            echo "Removing..."
            docker rm nerva
            echo "Regenerating..."
            docker run -v ${HOME}/.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" \
            --publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 19566:19566 -t nerva/node:latest /bin/bash
        fi
    else
        echo "The Nerva runtime environment is up to date. Starting..."
        docker start nerva
        docker exec -it nerva /bin/bash
    fi
    
else
    echo "No Nerva runtime environment found. Generating now..."
    docker run -v ${HOME}/.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" \
    --publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 19566:19566 -t nerva/node:latest /bin/bash
fi