#!/bin/sh
set -eux

SUBNET_CIDR=172.32.0.0/24

alias aws="aws --output text"

# Pre-deploy: Create a single-subnet VPC
VPC_ID=$(aws ec2 create-vpc --cidr $SUBNET_CIDR | cut -f 7)
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR | cut -f 6)
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch
GATEWAY_ID=$(aws ec2 create-internet-gateway | cut -f 2)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway $GATEWAY_ID
ROUTE_TABLE_ID=$(aws --output text ec2 describe-route-tables | grep $VPC_ID | cut -f 2)
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $GATEWAY_ID
aws ec2 modify-vpc-attribute --vpc-id=$VPC_ID --enable-dns-support

# For convenience, create a cleanup script for this VPC
cat > cleanup-$VPC_ID.sh << EOF
set -ux
aws ec2 detach-internet-gateway --internet-gateway-id $GATEWAY_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $GATEWAY_ID
aws ec2 delete-subnet --subnet-id $SUBNET_ID
aws ec2 delete-vpc --vpc-id $VPC_ID
EOF
chmod +x cleanup-$VPC_ID.sh

# Bootstrap juju controller - Please note aws region "us-east-1" must match default aws region in credentials
juju bootstrap --config vpc-id=$VPC_ID --config enable-os-upgrade=false --config default-series=xenial --credential aws-ericsson aws/us-east-1 ericsson-aws

# Deploy kubernetes with flannel
juju add-model kubernetes-epc
juju deploy k8-snaps-2-nodes.yaml
#juju add-unit -n1 kubernetes-worker

# Disable source-dest-check on all instances
for machine in 0 1; do
#for machine in 0 1 2; do
  until juju status --format yaml $machine | grep instance-id | grep -v pending; do sleep 10; done
  INSTANCE_ID=$(juju status --format yaml $machine | grep instance-id | head -n 1 | cut -d " " -f 6)
  aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --source-dest-check '{"Value": false}'
done
