#!/bin/sh
echo "Starting OAI S-GW and P-GW Roles"
# Start up MME in background
nohup ./run_spgw -i  & > /tmp/nohup.out
# workaround for keeping SPGW Container running
tail -50f > /openair-cn/SCRIPTS/nohup.out
#bash
