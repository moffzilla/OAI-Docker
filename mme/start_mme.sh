#!/bin/sh
echo "Starting OAI MME Role"
# Start up MME in background
nohup ./run_mme & > /tmp/nohup.out
# workaround for keeping HSS Container running
tail -50f > /openair-cn/SCRIPTS/nohup.out
#bash
