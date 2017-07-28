# OAI-Kubernetes
Open Air Interface EPC's MME, HSS, PWG &amp; SGW deployed at Kubernetes

OpenAirInterface is an implementation of the 3GPP specifications concerning the Evolved Packet Core Networks, that means it contains the implementation of the following network elements: MME, HSS, S-GW, P-GW.
[More information about Open Air Interface](https://gitlab.eurecom.fr/oai/openair-cn)

This project is aimed to run OpenAirInterface  in Docker Containers on a Kubernetes infrastructure

## Install Requirements
Please note that this procedure uses Juju 2.X and Ubuntu Xenial for deploying and performing configuration changes at K8 but any other K8 methodologies are supported


The enviroment installation:

- Install Kubernetes 1.7 
    You can execute  `vpc-ckd-flannel.sh` the script
            The script performs the following:
            
                1) Creates a VPC
                2) Bootstrap Juju Controller
                3) Creates a model and deploys a 2 node K8 with Flannel
                4) Generates a script to remove the VPC
                4.1) To remove the AWS Juju controller run:
                    `juju destroy-controller ericsson-aws --destroy-all-models -y` 
            * Please note that you need to generate your own Juju credentials for AWS and name it `aws-ericsson` you can add manually your credentials following this information: https://jujucharms.com/docs/stable/help-aws

- Download kubectl configuration and binary

   1) Create the kubectl config directory at your home directory.
    `mkdir -p ~/.kube`

   2) Copy the kubeconfig file to the default location.
    `juju scp kubernetes-master/0:config ~/.kube/config` 
   
   3) Fetch a binary for the architecture you have deployed. 
   If your client is adifferent architecture you will need to get the appropriate kubectl binary through other means.
    `snap install kubectl --classic`
    

   4) Query the cluster and make sure K8 is healthy.
    `kubectl cluster-info`
    You can also access the GUI, to find out the default admin password issue command:
     `kubectl config view`
    

- Install Linux 4.7.2 low latency Kernel (4.7.1 is also supported) at all the K8-Workers and master (Perform this step if you are using MS Azure, VMs or other infrastructure provider rather than AWS)

Please note that AWS may not like the here referenced low latency Kernel, in MS Azure and Baremetal/VMs it works fine

Download Kernel

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-headers-4.7.2-040702_4.7.2-040702.201608201334_all.deb`

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-headers-4.7.2-040702-lowlatency_4.7.2-040702.201608201334_amd64.deb`

 `wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/linux-image-4.7.2-040702-lowlatency_4.7.2-040702.201608201334_amd64.deb`

  1) Install Kernel
 ` sudo dpkg -i *.deb`

  2) Restart your host machine
 ` sudo shutdown -r now`

After reboot, login again and check Kernel

   3) Verify your kernel
   `uname -r`

For other architectures:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7.2/

3) Query the cluster and make sure K8 is healthy.
    `kubectl cluster-info`
    
- Enable support for running Privileged Containers at the K8-master (optional if juju yaml bundle has it included)

    `juju ssh kubernetes-master/0`
    `sudo vim /var/snap/kube-apiserver/current/args`
    
    Replace
    
        `--allow-privileged=false` for `--allow-privileged=true`
   
   Save and restary kube-apiserver
    
`sudo systemctl restart snap.kube-apiserver.daemon.service`

Check status

`sudo systemctl status snap.kube-apiserver.daemon.service`


- Enable support for running Privileged Containers at all the K8-Workers

    `juju ssh kubernetes-worker/0`

    `sudo vim /var/snap/kubelet/current/args`

 Replace
        `--allow-privileged=false` for `--allow-privileged=true`
    Save and restary kubelet

`sudo systemctl restart snap.kubelet.daemon.service`

Check status

 `sudo systemctl status snap.kubelet.daemon.service`
    
  Query the cluster and make sure K8 is healthy.
    `kubectl cluster-info`

## Deploy Containers

Create your pods and Service
    `kubectl create -f ./oai-epc-all-k8.yaml`

First deployment takes some time since the container is download

`watch -d -c --color kubectl get pods,services,endpoints,ingress,secrets`


