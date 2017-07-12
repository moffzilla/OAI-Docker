#!/bin/sh
echo "Starting OAI HSS Role"
# Start up HSS and MySQL in background
#cd /openair-cn/SCRIPTS
nohup ./start_service.sh & > /tmp/nohup.out
    sleep 10
nohup ./run_hss & > /tmp/nohup.out
# workaround for keeping HSS Container running
tail -50f > /openair-cn/SCRIPTS/nohup.out
#bash
