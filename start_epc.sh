#!/bin/sh
echo "Starting OAI EPC Roles"
# Start up EPC roles in background
#cd /openair-cn/SCRIPTS
nohup ./start_service.sh & > /tmp/nohup.out
    sleep 10
nohup ./run_hss & > /tmp/nohup.out
    sleep 10
nohup ./run_mme -i & > /tmp/nohup.out
    sleep 10
nohup ./run_spgw -i & > /tmp/nohup.out
tail -50f > /openair-cn/SCRIPTS/nohup.out
#bash