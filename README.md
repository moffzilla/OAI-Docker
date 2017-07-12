# OAI-Docker
Open Air Interface EPC's MME, HSS, PWG &amp; SGW

OpenAirInterface is an implementation of the 3GPP specifications concerning the Evolved Packet Core Networks, that means it contains the implementation of the following network elements: MME, HSS, S-GW, P-GW. 
[More information about Open Air Interface](https://gitlab.eurecom.fr/oai/openair-cn)

This project is aimed to run OpenAirInterface  in Docker Containers

## Minimum Requirements

- Host running Docker engine requires Linux 4.7.2-040702-lowlatency Kernel
- Running on Xenial (Cores=2 Mem=8G Root-Disk=30G)
- Ubuntu Xenial(16.04) amd64/ Kernel 4.7.2 Low Latency | Cores=2 Mem=8G Root-disk=30G

## Install Requirements

The enviroment installation:

- Install Xenial(16.04) 
- Install Linux 4.7.2 low latency Kernel (4.7.1 is also supported)
- Install the latest "docker-ce" release 

The following instructions are for reference:

1) Log in to Ubuntu host machine
2) Install KERNEL 4.7.x on your host machine, currently 4.7.1 and 4.7.2 is supported.

Please note that AWS may not like the here referenced low latency Kernel, in MS Azure and Baremetal/VMs it works fine

Download Kernel

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-headers-4.7.2-040702_4.7.2-040702.201608201334_all.deb`

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-headers-4.7.2-040702-lowlatency_4.7.2-040702.201608201334_amd64.deb`

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-image-4.7.2-040702-lowlatency_4.7.2-040702.201608201334_amd64.deb`

2.1) Install Kernel
 `sudo dpkg -i *.deb`

2.2) Restart your host machine
 `sudo shutdown -r now`

After reboot, login again and check Kernel

2.3) Verify your kernel
 `uname -r`

For other architectures:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/

3) Install Docker CE

3.1) Update Repositories
 `sudo apt-get update`

3.2) Install default tools
 `sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
software-properties-common`

4) Install Docker
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

 `sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"`

 `sudo apt-get update`

 `sudo apt-get install docker-ce -y`

4.1) Add user to Docker group
 `sudo usermod -aG docker $USER`
 `exit`

4.2) Check that Docker is installed properly

 `docker ps -a`
` docker version`

## Basic Execution

Instructions:
1) Pull the latest image
`docker pull moffzilla/oai-epc:v02`

2) Execute as follows:
`docker run --expose=1-9000 -p 3868:3868 -p 2152:2152 -p 2123:2123 -it -h=epc --privileged=true --name oai-testing --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules moffzilla/oai-epc:v02`

3) Attach to the running container
`docker exec -it oai-testing /bin/bash`

4) Verify all EPC services are started

`docker exec -it oai-testing /bin/bash`

Verify sockets are listening:

udp        0      0 192.171.11.1:2123       0.0.0.0:*                        LISTEN   (MME_PORT_FOR_S11_MME)

tcp        0      0 0.0.0.0:3868            0.0.0.0:*               LISTEN    (HSS)

tcp        0      0 127.0.0.1:3868          127.0.0.1:39554         ESTABLISHED  ( S6A HSS <--> MME )

tcp        0      0 127.0.0.1:39554         127.0.0.1:3868          ESTABLISHED  ( S6A MME <--> HSS )

udp        0      0 0.0.0.0:2152            0.0.0.0:*  (SGW_IPV4_PORT_FOR_S1U_S12_S4_UP)


