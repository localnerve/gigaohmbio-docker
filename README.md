# gigaohmbio-docker

> A docker solution to download, transcribe videos for gigaohmbiological

## Download
The download docker container gets the latest video url from twitch, downloads it, transcodes it, and writes it to an output volume.

Commands to run isolated (from project directory):
```
# build the image
export UID=`id -u`
export GID=`id -g`
docker build -t 'gigaohmbio-download' -f Dockerfile-download --build-arg UID=$UID --build-arg GID=$GID .

# run the image in a tmp container
docker run --rm -v ./data:/home/pn/app/data 'gigaohmbio-download'

# output is in ./data
```

Build and download script exists at ./scripts/build-run-download.sh

## Transcribe
The transcription docker container reads an input audio file, runs whisper, and writes the output to an output volume.
Uses the [go-whisper](https://github.com/appleboy/go-whisper) implementation.


Commands to run isolated (from project directory):
```
# build the image
docker build -t 'gigaohmbio-transcribe' -f Dockerfile-transcribe .

# run the image in a tmp container
export INPUT_MODEL=small
export INPUT_AUDIO_PATH=./data/my-latest-audio-file.m4a
export INPUT_OUTPUT_FOLDER=./data
export INPUT_OUTPUT_FORMAT=txt
docker run --rm -v ./models:/app/models -e INPUT_MODEL -e INPUT_AUDIO_PATH -e INPUT_OUTPUT_FOLDER -e INPUT_OUTPUT_FORMAT 'gigaohmbio-transcribe'
```

Build and download script exists at ./scripts/build-run-transcribe.sh

All go-whisper variables are listed at the [repo](https://github.com/appleboy/go-whisper/blob/main/README.md)
