#!/bin/bash
echo 'Setting up environment'
sudo service postgresql restart
sudo service redis-server restart
memcached -d
export REDIS_URL=redis://127.0.0.1:6379
export APP_SUPER_UNAME=testuser
export APP_SUPER_PASSWD=testpassword
export MEMCACHIER_SERVERS=localhost:11211
export MEMCACHIER_NAMESPACE=wulfusa