web: rackup -o $IP -p $PORT
worker: rake resque:work QUEUE=* COUNT=4