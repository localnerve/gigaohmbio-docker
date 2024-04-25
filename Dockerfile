FROM nikolaik/python-nodejs:latest

ENV GIGAOHMBIO_URL=gigaohmbio-latest-video.txt
ENV GIGAOHMBIO_DL=gigaohmbio-dl-output.txt

USER root
WORKDIR /app
# install system prerequisites
RUN <<EOF
apt-get update
apt-get install pipx ffmpeg ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils -y
EOF

USER pn
WORKDIR /home/pn/app
COPY --chmod=755 entrypoint.sh .
# install twitch-dl for pn, test access
ENV PATH="/home/pn/.local/bin:$PATH"
RUN <<EOF
pipx install twitch-dl
pipx ensurepath
# check twitch-dl
twitch-dl --version
# check ffmpeg, too
ffmpeg -h
EOF

ENTRYPOINT ["/home/pn/app/entrypoint.sh"]