#!/bin/bash
for d in ./*/; do
  cd "$d"
  pwd
  sed '/^#/d' time.log > ./timenohash.txt
  cd ../
done
