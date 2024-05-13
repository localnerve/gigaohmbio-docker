#!/bin/sh

set -eu

OUTPUT_FORMAT=m4a
CHROME_LAUNCHARGS=$(cat <<-EOF
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox"
  ]
EOF

)
PREVIOUS_VIDEO_URL="${1:-"none-n-o-n-e-none"}"

echo "***" >$GIGAOHMBIO_LOG
tail -f $GIGAOHMBIO_LOG &
CONSOLE_LOG_PID=$!
echo "Start download at `date +%Y%m%d-%H%M%S`" >>$GIGAOHMBIO_LOG

exitFunction () {
  kill $CONSOLE_LOG_PID
}

trap exitFunction EXIT

DEBUG=get-attribute npx -y @localnerve/get-attribute \
  --url=https://m.twitch.tv/gigaohmbiological\
  --selector='a[href^="/videos"]'\
  --attribute=href\
  --useprop=true\
  --launchargs="{$CHROME_LAUNCHARGS}" >$GIGAOHMBIO_URL 2>>$GIGAOHMBIO_LOG

LATEST_VIDEO_URL="`cat $GIGAOHMBIO_URL`"
if [ $? -eq 0 -a `echo $LATEST_VIDEO_URL | wc -c` -gt 0 ]; then
  if [ $LATEST_VIDEO_URL = $PREVIOUS_VIDEO_URL ]; then
    echo "Latest video url matches previous video url, stopping..." >>$GIGAOHMBIO_LOG
    echo "DOWNLOAD_DUPLICATE" >>$GIGAOHMBIO_LOG
    exit 0
  fi

  twitch-dl download --format $OUTPUT_FORMAT --overwrite --quality audio_only --output {title_slug}.{format} $LATEST_VIDEO_URL >$GIGAOHMBIO_DL 2>>$GIGAOHMBIO_LOG
else
  echo "Failed to get latest video url" >>$GIGAOHMBIO_LOG
  exit 4121
fi

if [ $? -eq 0 ]; then
  DOWNLOAD_RESULT=`tail -1 $GIGAOHMBIO_DL`
  AUDIO_FILE=`echo $DOWNLOAD_RESULT | awk '{print $2}'`

  cp `pwd`/$AUDIO_FILE $BINDMOUNT_VOL >>$GIGAOHMBIO_LOG 2>&1
  if [ $? -eq 0 -a -f "$BINDMOUNT_VOL/$AUDIO_FILE" ]; then
    echo "$AUDIO_FILE" >>$GIGAOHMBIO_LOG
    echo "DOWNLOAD_OK" >>$GIGAOHMBIO_LOG
  else
    echo "DOWNLOAD_FAILED" >>$GIGAOHMBIO_LOG
    exit 4123
  fi
else
  echo "Failed to download video" >>$GIGAOHMBIO_LOG
  exit 4122
fi
