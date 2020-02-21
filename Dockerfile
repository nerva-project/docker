FROM ubuntu:19.10

RUN apt update && apt upgrade --yes && export DEBIAN_FRONTEND=noninteractive && \
    apt install --no-install-recommends --yes \
    sudo git nano screen wget curl apache2 php php-curl php-bcmath && apt clean

RUN mkdir -p /src && \
    git clone --recursive --depth 1 https://bitbucket.org/nerva-project/nerva /src/nerva && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/explorer /src/explorer && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/dig /src/miner && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/web-wallet /src/wallet && \

RUN export DEBIAN_FRONTEND=noninteractive && apt install --no-install-recommends --yes \
    git build-essential boost-dev-all ca-certificates libzmq3-dev libunbound-dev libboost-all-dev \
    libssl-dev libsodium-dev libcurl4-openssl-dev libminiupnpc-dev libunwind8-dev liblzma-dev \
    libreadline6-dev libldns-dev libexpat1-dev

COPY /binaries/check_aesni /usr/bin/check_aesni
    
COPY /binaries/explorer /var/www/html/explorer
COPY /binaries/wallet /var/www/html/wallet
COPY /api /var/www/html/api
COPY /binaries/nerva /binaries


COPY /startup/nervad /usr/bin/nervad
COPY /startup/nerva-wallet-rpc /usr/bin/nerva-wallet-rpc
COPY /startup/nerva-wallet-cli /usr/bin/nerva-wallet-cli

COPY /apache/sa.000-default.conf /etc/apache2/sites-available/000-default.conf
COPY /apache/se.000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY /apache/explorer.htaccess /var/www/html/explorer/.htaccess
COPY /apache/wallet.htaccess /var/www/html/wallet/.htaccess

COPY /init-container /usr/bin/init-container

RUN groupadd --gid 1000 nerva && \
    useradd --uid 1000 --gid 1000 --no-create-home --home-dir / nerva && \
    usermod -aG sudo nerva && echo "nerva ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nerva && \
    chown -R nerva:nerva /binaries && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && /var/www/html/api/docgen

EXPOSE 17500 17565 17566 19566

ENTRYPOINT ["init-container"]
