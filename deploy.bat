set IMG_NAME="nerva/node"

REM Create host directories
mkdir %USERPROFILE%\.nerva-docker
mkdir %USERPROFILE%\.nerva-docker/wallets
mkdir %USERPROFILE%\.nerva-docker/blockchain

REM Pull the latest image
docker pull %IMG_NAME%

REM Run it
docker run --rm -v %USERPROFILE%\.nerva-docker:/nerva -i --privileged --user 1000:1000 --name "nerva" ^
--publish 17500:80 --publish 17565:17565 --publish 17566:17566 --publish 19566:19566 -t %IMG_NAME%:latest /bin/bash
