FROM ubuntu:19.10

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt upgrade --yes \
&&  apt install --no-install-recommends --yes \
    sudo apt-utils nano screen wget curl apache2 php php-curl php-bcmath \
    git ca-certificates build-essential pkg-config libzmq3-dev libunbound-dev libboost-all-dev \
    libssl-dev libsodium-dev libcurl4-openssl-dev libminiupnpc-dev libunwind8-dev liblzma-dev \
    libreadline6-dev libldns-dev libexpat1-dev cmake \
&&  curl -o- https://deb.nodesource.com/setup_13.x | bash \
&&  export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends --yes nodejs \
&&  mkdir -p /src \
&&  git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/explorer /src/explorer \
&&  git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/dig /src/miner \
&&  git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/web-wallet /src/wallet \
&&  git clone --recursive --depth 1 https://bitbucket.org/nerva-project/nerva /src/nerva \
&&  git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/nerva.rpc.php /var/www/html/api \
&&  cd /src/explorer && npm install && npm run build-with-path && mv /src/explorer/dist /var/www/html/explorer \
&&  cd /src/miner && npm install && npm run build-with-path && mv /src/miner/dist /var/www/html/miner \
&&  cd /src/wallet && npm install && npm run build-with-path && mv /src/wallet/dist /var/www/html/wallet \
&&  cd /src/nerva/builder && ./build-docker \
&&  mv /src/nerva/builder/output/docker/release-aes/bin/nervad /usr/bin/nervad-aes-bin \
&&  mv /src/nerva/builder/output/docker/release-noaes/bin/nervad /usr/bin/nervad-noaes-bin \
&&  mv /src/nerva/builder/output/docker/release-aes/bin/nerva-wallet-cli /usr/bin/nerva-wallet-cli-bin \
&&  mv /src/nerva/builder/output/docker/release-aes/bin/nerva-wallet-rpc /usr/bin/nerva-wallet-rpc-bin \
&&  cd /src/nerva/builder && make check_aesni && mv /src/nerva/builder/check_aesni /usr/bin/check_aesni \
&&  rm -rf /src \
&&  groupadd -g 1000 nerva \
&&  useradd -g 1000 -u 1000 -m -s /bin/bash nerva \
&&  usermod -aG sudo nerva && echo "nerva ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nerva \
&&  echo "ServerName localhost" >> /etc/apache2/apache2.conf \
&&  a2enmod rewrite && /var/www/html/api/docgen \
&&  export DEBIAN_FRONTEND=noninteractive && apt purge -y git ca-certificates build-essential pkg-config cmake nodejs \
&&  apt autoremove -y && apt clean

COPY /apache/ /etc/apache2/
COPY /htaccess/ /var/www/html/
COPY /startup/ /usr/bin/

EXPOSE 17500 17565 17566 19566
ENTRYPOINT ["init-container"]
