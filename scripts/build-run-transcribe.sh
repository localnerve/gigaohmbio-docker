#!/bin/sh
#
# Build and run the gigaohmbio transcribe standalone, locally
# Run after build-run-download.sh
#
# Depends on:
#   docker
#   bourne shell
#
# Positional arguments:
#   1. audio filename in this repository's data directory
#   2. path to the output folder
#
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)
MODELS_DIR=`readlink -f $SCRIPT_DIR/../models`
DATA_DIR=`readlink -f $SCRIPT_DIR/../data`

INPUT_AUDIOFILE="${1:-"no-file-exists-9999"}"

readlink -f "$DATA_DIR/$INPUT_AUDIOFILE" >/dev/null
if [ $? -ne 0 ]; then
  echo "first argument must contain the audio filename in this repository's data directory"
  exit 1
fi

readlink -f "$2" >/dev/null
if [ $? -ne 0 -o ! -d "$2" ]; then
  echo "second argument must contain a valid path to an output folder"
  exit 2
fi

# set arguments
export INPUT_MODEL=small
INPUT_OUTPUT_FORMAT=txt
INPUT_AUDIO_PATH="/app/testdata/$INPUT_AUDIOFILE"
INPUT_OUTPUT_FOLDER=`readlink -f "$2"`
INPUT_PRINT_PROGRESS=true

echo "building gigaohmbio-transcribe..."
docker build -t 'gigaohmbio-transcribe' -f Dockerfile-transcribe .
if [ $? -eq 0 ]; then
  echo "running gigaohmbio-transcribe..."
  docker run --rm \
    -v $MODELS_DIR:/app/models \
    -v $DATA_DIR:/app/testdata \
    'gigaohmbio-transcribe' \
    --audio-path $INPUT_AUDIO_PATH \
    --output-folder $INPUT_OUTPUT_FOLDER \
    --output-format $INPUT_OUTPUT_FORMAT \
    --print-progress $INPUT_PRINT_PROGRESS
fi