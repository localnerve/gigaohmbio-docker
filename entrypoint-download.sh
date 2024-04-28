#!/bin/sh

set -eu

echo "@@@ DEBUG 1"

OUTPUT_FORMAT=m4a
CHROME_LAUNCHARGS=$(cat <<-EOF
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox"
  ]
EOF

)

DEBUG=cli,get-attribute npx -y @localnerve/get-attribute \
  --url=https://m.twitch.tv/gigaohmbiological\
  --selector='a[href^="/videos"]'\
  --attribute=href\
  --useprop=true\
  --launchargs="{$CHROME_LAUNCHARGS}"

exit 0

echo "@@@ DEBUG 2"

if [ $? -eq 0 -a `cat $GIGAOHMBIO_URL | wc -c` -gt 0 ]; then
  twitch-dl download --format $OUTPUT_FORMAT --overwrite --quality audio_only --output {title_slug}.{format} `cat $GIGAOHMBIO_URL` >$GIGAOHMBIO_DL 2>>$GIGAOHMBIO_LOG
else
  echo "@@@ DEBUG 7"
  echo "Failed to get latest video url" >>$GIGAOHMBIO_LOG
  exit 4121
fi

echo "@@@ DEBUG 3"

if [ $? -eq 0 ]; then
  DOWNLOAD_RESULT=`tail -1 $GIGAOHMBIO_DL`
  AUDIO_FILE=`echo $DOWNLOAD_RESULT | awk '{print $2}'`

  echo "@@@ DEBUG 4"
  cp `pwd`/$AUDIO_FILE $BINDMOUNT_VOL >>$GIGAOHMBIO_LOG 2>&1
  if [ $? -eq 0 -a -f "$BINDMOUNT_VOL/$AUDIO_FILE" ]; then
    echo "@@@ DEBUG 5"
    echo "DOWNLOAD_OK" >>$GIGAOHMBIO_LOG
  else
    echo "@@@ DEBUG 6"
    echo "DOWNLOAD_FAILED" >>$GIGAOHMBIO_LOG
    exit 4123
  fi
else
  echo "@@@ DEBUG 8"
  echo "Failed to download video" >>$GIGAOHMBIO_LOG
  exit 4122
fi
