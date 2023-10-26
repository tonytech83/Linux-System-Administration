#!/bin/bash

param=$1

if [ $# -ne 1 ]; then
  echo "error"
  exit 1
fi

for (( i=0; i<$param; i++ )); do
  echo -n "*"
done
