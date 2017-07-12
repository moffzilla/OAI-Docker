# OAI-Docker
Open Air Interface EPC's HSS ( Including MySQL )

OpenAirInterface is an implementation of the 3GPP specifications concerning the Evolved Packet Core Networks, that means it contains the implementation of the following network elements: MME, HSS, S-GW, P-GW. 
[More information about Open Air Interface](https://gitlab.eurecom.fr/oai/openair-cn)

This project is aimed to run OpenAirInterface  in Docker Containers

## Minimum Requirements

- Running on Xenial (Cores=2 Mem=8G Root-Disk=30G)
- Ubuntu Xenial(16.04) amd64/ Kernel 4.7.2 Low Latency | Cores=2 Mem=8G Root-disk=30G

## Install Requirements

The enviroment installation:

- Install Xenial(16.04) 
- Install Linux 4.7.2 low latency Kernel (4.7.1 is also supported)
- Install the latest "docker-ce" release 


1) Install Docker CE

1.1) Update Repositories
 `sudo apt-get update`

1.2) Install default tools
 `sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
software-properties-common`

2) Install Docker
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

 `sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"`

 `sudo apt-get update`

 `sudo apt-get install docker-ce -y`

4) Add user to Docker group
 `sudo usermod -aG docker $USER`
 `exit`

4.1) Check that Docker is installed properly

 `docker ps -a`
` docker version`

## Basic Execution

Instructions:
1) Pull the latest image
`docker pull moffzilla/oai-epc:v02`

2) Execute as follows:
`docker run --expose=1-9000 -p 3868:3868 -it -h=hss --privileged=true --name oai-hss --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules moffzilla/oai-epc:v02`

3) Attach to the running container
`docker exec -it oai-testing /bin/bash`

4) Verify all EPC services are started

`docker exec -it oai-testing /bin/bash`

Verify sockets are listening:

tcp        0      0 0.0.0.0:3868            0.0.0.0:*               LISTEN    (HSS)



