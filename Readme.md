# Nerva Web UI

This repo will run an instance of Nerva in a docker container and provide a web based UI for  
mining, wallet, explorer and api functions. The only dependency to run this is docker itself

## Install

There are 2 included scripts to get started with a minimum of effort. You can choose to either create the image from this repo, or pull it from docker hub.  

### Build locally

Clone this repo and run the script `deploy-local` for your OS
`git clone https://bitbucket.org/nerva-project/web-ui`
`./deploy-local.sh`

### Pull from docker hub

Simply download and run the `deploy` script in this repo

Functionally, the two approaches are the same. The only difference being that the `deploy` script will download a pre-built image from docker hub,  
where as the `deploy-local` script will build the image on your system.

## Local Data

This image and resulting container is known as an application container. It contains the applications you need to run, but does not store data inside the container  
The deployment scripts will create a directory at `$HOME/.nerva-docker` which contains blockchain and wallet data. This means you can destroy the containers and images without  
loss of data.

### Quick Sync

Since the blockchain data is held on the host system, you can migrate data from native applications to docker with ease. Simply copy existing blockchain files to  
`$HOME/.nerva-docker/blockchain` and existing wallet files to `$HOME/.nerva-docker/wallets` and they will be seen within the container on startup.  

Additionally, you can use a quick sync file by simply downloading it from the website to `$HOME/.nerva-docker`. it will be found and used automatically.

## The docker prompt

When you deploy your container, it will initialise and start required programs in the background and you will be presented with a prompt, similar to a linux terminal prompt.  
From here you have full headless access to the docker container.

### Monitoring via the CLI

The docker container will start nervad and nerva-wallet-rpc in screen sessions. Screen enables you to run programs in virtual terminals, effectively running them in the background  
to be called up later. To see the attached screens for these programs, run the command `screen -r`. You will see output similar to  
```
nerva@e16e53e576b0:/$ screen -r
There are several suitable screens on:
        49.nerva-wallet-rpc     (10/05/19 06:51:12)     (Detached)
        45.nervad       (10/05/19 06:51:11)     (Detached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
```
To access a screen, you simply run the command `screen -r nervad` or `screen -r nerva-wallet-rpc`
