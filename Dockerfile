FROM ubuntu:19.10

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt upgrade --yes && \
    apt install --no-install-recommends --yes \
    sudo nano screen wget curl apache2 php php-curl php-bcmath \
    git ca-certificates build-essential libzmq3-dev libunbound-dev libboost-all-dev \
    libssl-dev libsodium-dev libcurl4-openssl-dev libminiupnpc-dev libunwind8-dev liblzma-dev \
    libreadline6-dev libldns-dev libexpat1-dev cmake && \
    curl -o- https://deb.nodesource.com/setup_13.x | bash && \
    apt install --yes nodejs && \
    mkdir -p /src && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/explorer /src/explorer && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/dig /src/miner && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/web-wallet /src/wallet && \
    git clone --recursive --depth 1 https://bitbucket.org/nerva-project/nerva /src/nerva && \
    git clone --recursive --branch web-ui --depth 1 https://bitbucket.org/nerva-project/nerva.rpc.php /var/www/html/api && \
    cd /src/explorer && npm install && npm run build-with-path && mv /src/explorer/dist /var/www/html/explorer && \
    cd /src/miner && npm install && npm run build-with-path && mv /src/miner/dist /var/www/html/miner && \
    cd /src/wallet && npm install && npm run build-with-path && mv /src/wallet/dist /var/www/html/wallet && \
    cd /src/nerva/builder && export THREAD_COUNT=6 && ./build && \
    mv ./output/linux/release/bin/nervad /usr/bin/nervad && \
    mv ./output/linux/release/bin/nerva-wallet-cli /usr/bin/nerva-wallet-cli && \
    mv ./output/linux/release/bin/nerva-wallet-rpc /usr/bin/nerva-wallet-rpc && \
    groupadd --gid 1000 nerva && \
    useradd --uid 1000 --gid 1000 --no-create-home --home-dir / nerva && \
    usermod -aG sudo nerva && echo "nerva ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nerva && \
    chown -R nerva:nerva /src && chown -R nerva:nerva /var/www/html && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && /var/www/html/api/docgen && \
    apt purge -y git ca-certificates build-essential libzmq3-dev libunbound-dev libboost-all-dev \
    libssl-dev libsodium-dev libcurl4-openssl-dev libminiupnpc-dev libunwind8-dev liblzma-dev \
    libreadline6-dev libldns-dev libexpat1-dev cmake nodejs && apt autoremove && apt clean

COPY /apache/sa.000-default.conf /etc/apache2/sites-available/000-default.conf
COPY /apache/se.000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY /apache/explorer.htaccess /var/www/html/explorer/.htaccess
COPY /apache/wallet.htaccess /var/www/html/wallet/.htaccess
COPY /apache/miner.htaccess /var/www/html/miner/.htaccess
COPY /init-container /usr/bin/init-container

EXPOSE 17500 17565 17566 19566

ENTRYPOINT ["init-container"]
