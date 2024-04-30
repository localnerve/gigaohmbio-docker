# gigaohmbio-docker

> A cross-platform solution to automate download and transcription of videos for gigaohmbiological

## Prerequisites
* Docker Engine or Docker Desktop
* Bourne shell

## Summary

This repository contains:
* Standalone bourne shell scripts to run download and transcribe scripts
* Github Action for automating download and transcription of videos on Github

This serves as a prototype and example of support automation for gigaohmbiological.

## Download

The download docker container gets the latest video url from twitch, downloads it, transcodes it, and writes it to an output volume.

> Build and download script exists at ./scripts/build-run-download.sh

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

## Transcribe

The transcription docker container reads an input audio file, runs whisper, and writes the output to an output volume.
Uses the [go-whisper](https://github.com/appleboy/go-whisper) implementation.

> Build and download script exists at ./scripts/build-run-transcribe.sh

Commands to run isolated (from project directory):
```
# build the image
docker build -t 'gigaohmbio-transcribe' -f Dockerfile-transcribe .

# run the image in a tmp container (params as env vars)
# INPUT_MODEL always has to be passed by environment, unless you have the full path to downloaded model
# model keywords: small, medium, large, large-v1, large-v2
export INPUT_MODEL=small
docker run --rm -v ./data:/app/testdata -v ./models:/app/models \
  'gigaohmbio-transcribe' \
  --input-audio /app/testdata/my-latest-audio-file-in-data-dir.m4a \
  --output-format txt \
  --print-progress true
```

All go-whisper variables are listed at the source [repo](https://github.com/appleboy/go-whisper/blob/main/README.md)

## Further Automation Notes/Ideas

* The outputs of this project can be further redirected or sent on to other services
* The Github Action can be run on a cron schedule, managed by Github Actions
* The download script:  
  * Can be changed to read multiple videos at once, enabling less frequent processing (cost purposes)
  * Can be changed to transcribe to multiple formats (audio, video)
  * Can be changed to source from other services, not just twitch
  * Hosts full chrome/puppeteer and ffmpeg, so can be scripted to perform the download/transcribe itself instead of relying on dependencies (like twitch-dl)
