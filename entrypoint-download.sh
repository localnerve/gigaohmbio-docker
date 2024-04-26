#!/bin/sh

set -eu

OUTPUT_FORMAT=m4a
DEBUG=get-attribute npx -y @localnerve/get-attribute --url=https://m.twitch.tv/gigaohmbiological --selector='a[href^="/videos"]' --attribute=href --useprop=true >$GIGAOHMBIO_URL 2>$GIGAOHMBIO_LOG

if [ $? -eq 0 -a `cat $GIGAOHMBIO_URL | wc -c` -gt 0 ]; then
  twitch-dl download --format $OUTPUT_FORMAT --overwrite --quality audio_only --output {title_slug}.{format} `cat $GIGAOHMBIO_URL` >$GIGAOHMBIO_DL 2>>$GIGAOHMBIO_LOG
else
  echo "Failed to get latest video url" >>$GIGAOHMBIO_LOG
  exit 1
fi

if [ $? -eq 0 ]; then
  DOWNLOAD_RESULT=`tail -1 $GIGAOHMBIO_DL`
  AUDIO_FILE=`echo $DOWNLOAD_RESULT | awk '{print $2}'`
  cp `pwd`/$AUDIO_FILE $BINDMOUNT_VOL >>$GIGAOHMBIO_LOG 2>&1
  if [ $? -eq 0 -a -f "$BINDMOUNT_VOL/$AUDIO_FILE" ]; then
    echo "DOWNLOAD_OK" >>$GIGAOHMBIO_LOG
  else
    echo "DOWNLOAD_FAILED" >>$GIGAOHMBIO_LOG
    exit 3
  fi
else
  echo "Failed to download video" >>$GIGAOHMBIO_LOG
  exit 2
fi
