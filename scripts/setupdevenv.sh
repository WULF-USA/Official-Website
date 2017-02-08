#!/bin/bash
echo 'Setting up environment'
sudo service postgresql restart
sudo service redis-server restart
export REDIS_URL=redis://127.0.0.1:6379
export APP_SUPER_UNAME=testuser
export APP_SUPER_PASSWD=testpassword