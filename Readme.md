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

nervad and nerva-wallet-rpc are both run with the `--detach` option. This means their output is not going to be visible in the CLI. There are a few options for checking on the status of your nodes. First is the API. Each docker container also has a self contained API which points to your running node and wallet. The API can be found at `http://localhost:17500/api/`.  

This also allows for simplified automation and monitoring via host side scripting.  

Nervad will also accept the same commands as a running node. You can run `nervad status` for example directly into the docker prompt to check on the status of a node. For a full list of available commands, run `nervad help` in the docker prompt.

## Web UI

The docker container also hosts it's own web based UI for node monitoring and wallet functions, with mining controls in development. UI's can be located on port 17500 of localhost.  
You can access the built in explorer at `http://localhost:17500/explorer` and the wallet at `http://localhost:17500/wallet`  

