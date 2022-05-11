FROM ubuntu:20.04
WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
MAINTAINER @frozen12
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt -y update && \
    apt install -y software-properties-common \
    python3 python3-pip libssl-dev libc-ares-dev \
    tzdata p7zip-full xz-utils curl pv jq \
    locales git libsodium-dev  rtmpdump libmagic-dev p7zip-rar \
    wget ffmpeg libcrypto++-dev unzip libcurl4-openssl-dev \
    libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev && \
    locale-gen en_US.UTF-8

COPY . .
# Requirements Mirror Bot
RUN pip3 install --no-cache-dir -r required.txt

RUN wget -q -O megasdkrest 'https://raw.githubusercontent.com/Frozen12/TGMirrorBot/master/storage/megasdkrest-amd64' -P /usr/local/bin/ && chmod +x /usr/local/bin/megasdkrest \
       && apt-get -y update && apt-get -y upgrade && apt-get -y install aria2 && apt-get -y autoremove-get && apt-get -y autoclean

COPY . .
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/pextract && chmod +x /usr/local/bin/extract
RUN wget -q 'https://github.com/P3TERX/aria2.conf/raw/master/dht.dat' -O /usr/src/app/dht.dat && \
wget -q 'https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat' -O /usr/src/app/dht6.dat
RUN chmod +x aria.sh

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
CMD ["bash","start.sh"]
