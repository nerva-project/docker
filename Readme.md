# Nerva Web UI

This repo will run an instance of Nerva in a docker container and provide a web based UI for  
mining, wallet, explorer and api functions. The only dependency to run this is docker itself

## Install

First you need docker. [Windows](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) | 
[OSX](https://download.docker.com/mac/stable/Docker.dmg)  

Linux depends on your distro, but for debian/ubuntu and friends it is `apt install docker.io`

There are 2 included scripts to get started with a minimum of effort. You can choose to either create the image from this repo, or pull it from docker hub.  

### Getting started

After installing docker, simply download and run the `run` script in this repo

## Local Data

This image and resulting container is known as an application container. It contains the applications you need to run, but does not store data inside the container  
The deployment scripts will create a directory at `$HOME/.nerva-docker` which contains blockchain and cli wallet data. This means you can destroy the containers  
and images without loss of data.

### Quick Sync

Since the blockchain data is held on the host system, you can migrate data from native applications to docker with ease. Simply copy existing blockchain files to `<HOME>/.nerva-docker/blockchain`  

Additionally, you can use a quick sync file by simply downloading it from the website to `<HOME>/.nerva-docker`. it will be found and used automatically.

## The docker prompt

When you deploy your container, it will initialise and start required programs in the background and you will be presented with a prompt, similar to a linux terminal prompt.  
From here you have full headless access to the docker container.

### Monitoring via the CLI

nervad and nerva-wallet-rpc are both run in screen sessions. This means their output is not going to be visible in the CLI. There are a few options for checking on the status of your nodes. First is the API. Each docker container also has a self contained API which points to your running node and wallet. The API can be found at `http://localhost:17500/api/`.  

This also allows for simplified automation and monitoring via host side scripting.  

You can also see the CLI output by attaching to one of the available screen sessions. Type `screen -r` at the prompt to see the screens available. Then type `screen -f <session>` to restore it.  
For example `screen -r nervad` to attach to the running daemon instance and view it's output.

## Web UI

The docker container also hosts it's own web based UI for node monitoring and wallet functions, with mining controls in development. UI's can be located on port 17500 of localhost.  
Explorer: `http://localhost:17500/explorer`  
Wallet: `http://localhost:17500/wallet`  
Miner: `http://localhost:17500/miner` 
API: `http://localhost:17500/api`
