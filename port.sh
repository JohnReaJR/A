#!/bin/bash
cd /root
cd tcp; screen -dmS tcp ./tcp-linux-amd64 -addr :443 dstAddr 127.0.0.1:22 && cd
exit 1
