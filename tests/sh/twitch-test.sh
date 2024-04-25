#!/bin/sh

set -eu

AUDIO_FILE=
GIGAOHMBIO_DL=tmp-gigaohmbio-dl.txt
GIGAOHMBIO_URL=tmp-gigaohmbio-url.txt
OUTPUT_FORMAT=m4a

DEBUG=get-attribute npx -y @localnerve/get-attribute --url=https://www.twitch.tv/gigaohmbiological/home --selector='a[href^="/videos"]' --attribute=href --useprop=true >$GIGAOHMBIO_URL

if [ $? -eq 0 -a `cat $GIGAOHMBIO_URL | wc -c` -gt 0 ]; then
  twitch-dl download --format $OUTPUT_FORMAT --overwrite --quality audio_only --output {title_slug}.{format} `cat $GIGAOHMBIO_URL` >$GIGAOHMBIO_DL
else
  echo "Failed to get latest video url"
  exit 1
fi

if [ $? -eq 0 ]; then
  DOWNLOAD_RESULT=`tail -1 $GIGAOHMBIO_DL`
  AUDIO_FILE=`echo $DOWNLOAD_RESULT | awk '{print $2}'`
else
  echo "Failed to download video"
  cat $GIGAOHMBIO_DL
  exit 2
fi

echo `pwd`/$AUDIO_FILE