#!/bin/bash

date=$(date '+%Y-%m-%d %H-%M-%S')
processes=$(ps -e | wc -l)

echo "$date -> $processes" >> /tmp/processes.log
