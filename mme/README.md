# OAI-MME-Docker
Open Air Interface EPC's HSS MME

OpenAirInterface is an implementation of the 3GPP specifications concerning the Evolved Packet Core Networks, that means it contains the implementation of the following network elements: MME, HSS, S-GW, P-GW. 
[More information about Open Air Interface](https://gitlab.eurecom.fr/oai/openair-cn)

This project is aimed to run OpenAirInterface  in Docker Containers

## Minimum Requirements

- Running on Xenial (Cores=2 Mem=8G Root-Disk=30G)
- Ubuntu Xenial(16.04) amd64 | Cores=2 Mem=8G Root-disk=30G

## Install Requirements

The enviroment installation:

- Install Xenial(16.04) 
- Install Linux 4.7.2 low latency Kernel (4.7.1 is also supported)
- Install the latest "docker-ce" release 

Please note that for integrating other EPC Roles, IP end points must be pre-configured
In order to automate this process a Docker bridge is created:

`docker network create --driver=bridge --subnet=172.19.0.0/24 --gateway=172.19.0.1 oainet`

and the following IPs proposed for running the container

- 172.19.0.10 hss.openair4G.eur hss
- 172.19.0.20 epc.openair4G.eur epc
- 172.19.0.30 hss.openair4G.eur spgw

## Basic Execution

Instructions:
1) Pull the latest image
`docker pull moffzilla/oai-hss:v02`

2) Execute as follows:
`docker run --expose=1-9000 -p 2123:2123 --ip=172.19.0.20 --net=oainet -it -h=epc --privileged=true --name oai-mme --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules moffzilla/oai-mme:v01`

3) Attach to the running container
`docker exec -it oai-mme /bin/bash`

4) Verify all EPC services are started

`docker exec -it oai-mme /bin/bash`

Verify sockets are listening:

`netstat -na | grep 2123`

tcp        0      0 0.0.0.0:3868            0.0.0.0:*               LISTEN    (HSS)



