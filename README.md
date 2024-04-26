# gigaohmbio-docker

> A docker solution to download, transcribe videos for gigaohmbiological

## Download
The download docker container gets the latest video url from twitch, downloads it, transcodes it, and writes it to an output volume.

Commands to run isolated (from project directory):
```
# build the image
docker build -t 'gigaohmbio-download' -f Dockerfile-download .

# run the image in a container of the same name
docker run --name=gigaohmbio-download -v ./data:/home/pn/app/data 'gigaohmbio-download'
```

## Transcribe
The transcription docker container reads an input audio file, runs whisper, and writes the output to an output volume.

...WIP...