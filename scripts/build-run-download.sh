#!/bin/sh
#
# Build and run gigaohmbio download standalone, locally
# Run prior to build-run-transcribe.sh
#
# Depends on:
#   docker
#   bourne shell
#
# Places output in this repository's data directory
#
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)
DATA_DIR=`readlink -f $SCRIPT_DIR/../data`

echo "building gigaohmbio-download..."
docker build -t 'gigaohmbio-download' -f Dockerfile-download --build-arg UID=`id -u` --build-arg GID=`id -g` .
if [ $? -eq 0 ]; then
  echo "running gigaohmbio-download..."
  docker run --rm -v $DATA_DIR:/home/pn/app/data 'gigaohmbio-download'
fi