FROM ubuntu:19.10 as base

# Build base system
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt upgrade --yes

RUN export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends --yes \
    sudo apt-utils nano screen wget curl apache2 php php-curl php-bcmath \
    git ca-certificates build-essential pkg-config libzmq3-dev libunbound-dev libboost-all-dev \
    libssl-dev libsodium-dev libcurl4-openssl-dev libminiupnpc-dev libunwind8-dev liblzma-dev \
    libreadline6-dev libldns-dev libexpat1-dev cmake

RUN curl -o- https://deb.nodesource.com/setup_13.x | bash
RUN export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends --yes nodejs

# Build source
RUN mkdir -p /src
RUN git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/explorer /src/explorer
RUN git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/dig /src/miner
RUN git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/web-wallet /src/wallet
RUN git clone --recursive --depth 1 https://bitbucket.org/nerva-project/nerva /src/nerva
RUN git clone --branch web-ui --depth 1 https://bitbucket.org/nerva-project/nerva.rpc.php /var/www/html/api
RUN cd /src/explorer && npm install && npm run build-with-path && mv /src/explorer/dist /var/www/html/explorer
RUN cd /src/miner && npm install && npm run build-with-path && mv /src/miner/dist /var/www/html/miner
RUN cd /src/wallet && npm install && npm run build-with-path && mv /src/wallet/dist /var/www/html/wallet
RUN cd /src/nerva/builder && ./build-docker
RUN mv /src/nerva/builder/output/docker/release-aes/bin/nervad /usr/bin/nervad-aes-bin
RUN mv /src/nerva/builder/output/docker/release-noaes/bin/nervad /usr/bin/nervad-noaes-bin
RUN mv /src/nerva/builder/output/docker/release-aes/bin/nerva-wallet-cli /usr/bin/nerva-wallet-cli-bin
RUN mv /src/nerva/builder/output/docker/release-aes/bin/nerva-wallet-rpc /usr/bin/nerva-wallet-rpc-bin

COPY /check_aesni.c /src/check_aesni.c
RUN cd /src && make check_aesni && mv /src/check_aesni /usr/bin/check_aesni

RUN rm -rf /src

# Add a nerva user
RUN groupadd -g 1000 nerva
RUN useradd -g 1000 -u 1000 -m -s /bin/bash nerva
RUN usermod -aG sudo nerva && echo "nerva ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nerva

# Apache config
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite && /var/www/html/api/docgen

# Copy launch and config files
COPY /apache/sa.000-default.conf /etc/apache2/sites-available/000-default.conf
COPY /apache/se.000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY /apache/explorer.htaccess /var/www/html/explorer/.htaccess
COPY /apache/wallet.htaccess /var/www/html/wallet/.htaccess
COPY /apache/miner.htaccess /var/www/html/miner/.htaccess

COPY /startup/nervad /usr/bin/nervad
COPY /startup/nerva-wallet-cli /usr/bin/nerva-wallet-cli
COPY /startup/nerva-wallet-rpc /usr/bin/nerva-wallet-rpc

COPY /init-container /usr/bin/init-container

# Remove build toolchains
RUN export DEBIAN_FRONTEND=noninteractive && apt purge -y git ca-certificates build-essential pkg-config cmake nodejs
RUN apt autoremove -y && apt clean

#FROM base
EXPOSE 17500 17565 17566 19566
ENTRYPOINT ["init-container"]
