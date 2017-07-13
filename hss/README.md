# OAI-HSS-Docker
Open Air Interface EPC's HSS ( Including MySQL )

OpenAirInterface is an implementation of the 3GPP specifications concerning the Evolved Packet Core Networks, that means it contains the implementation of the following network elements: MME, HSS, S-GW, P-GW. 
[More information about Open Air Interface](https://gitlab.eurecom.fr/oai/openair-cn)

This project is aimed to run OpenAirInterface  in Docker Containers

## Minimum Requirements

- Running on Xenial (Cores=2 Mem=8G Root-Disk=30G)
- Ubuntu Xenial(16.04) amd64 | Cores=2 Mem=8G Root-disk=30G

## Install Requirements

The enviroment installation:

- Install Xenial(16.04) 
- Install the latest "docker-ce" release 

Please note that for integrating other EPC Roles, IP end points must be pre-configured
In order to automate this process a Docker bridge is created:
(You can check the bridge has been pre-created with `docker network ls`)

`docker network create --driver=bridge --subnet=172.19.0.0/24 --gateway=172.19.0.1 oainet`

and the following IPs proposed for running the container

- 172.19.0.10 hss.openair4G.eur hss
- 172.19.0.20 epc.openair4G.eur epc
- 172.19.0.30 hss.openair4G.eur spgw

## Basic Execution

Instructions:
1) Pull the latest image
`docker pull moffzilla/oai-hss:v01`

2) Execute as follows:
`docker run --expose=1-9000 -p 3868:3868 --ip=172.19.0.10 --net=oainet --expose=1-9000 -ti --add-host "hss.openair4G.eur hss":172.19.0.10 --add-host "epc.openair4G.eur epc":172.19.0.20 --add-host "spgw.openair4G.eur spgw":172.19.0.30 -h=hss --privileged=true --name="oai_hss"  --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules moffzilla/oai-hss:v01`

3) Attach to the running container
`docker exec -it oai-testing /bin/bash`

4) Verify all EPC services are started

`docker exec -it oai-testing /bin/bash`

Verify sockets are listening:

`netstat -na | grep 3868`

tcp        0      0 0.0.0.0:3868            0.0.0.0:*               LISTEN    (HSS)



