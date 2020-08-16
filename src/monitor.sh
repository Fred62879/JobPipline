#!/bin/bash

trap "kill 0" SIGINT    # kill all background processes upon C-c

time=$1

echo monitor running in $$

# ./worker1.sh & ./worker2.sh & ./worker3.sh & ./worker4.sh & ./worker5.sh
./worker.sh $time ./thread1 &
./worker.sh $time ./thread2 &
./worker.sh $time ./thread3 &
./worker.sh $time ./thread4 &
./worker.sh $time ./thread5 & wait

echo monitor done $$

exit 0
