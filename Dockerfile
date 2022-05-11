FROM ubuntu:20.04
WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
MAINTAINER @frozen12
ENV LC_ALL en_US.UTF-16
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && \
        apt-get install -y software-properties-common \
    python3 python3-pip aria2 wget ffmpeg \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq \
    locales git unzip rtmpdump libmagic-dev libcurl4-openssl-dev \
    libssl-dev libc-ares-dev libsodium-dev libcrypto++-dev \
    libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev && \
    locale-gen en_US.UTF-8 && \
    curl -L https://github.com/anasty17/megasdkrest/releases/download/latest/megasdkrest-$(cpu=$(uname -m);\
    if [[ "$cpu" == "x86_64" ]]; then echo "amd64"; elif [[ "$cpu" == "x86" ]]; \
    then echo "i386"; elif [[ "$cpu" == "aarch64" ]]; then echo "arm64"; else echo $cpu; fi) \
    -o /usr/local/bin/megasdkrest && chmod +x /usr/local/bin/megasdkrest
        

# Requirements Mirror Bot
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y autoclean

COPY . .
# COPY .netrc /root/.netrc
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract
RUN wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht.dat -O /usr/src/app/dht.dat && \
wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat -O /usr/src/app/dht6.dat
RUN chmod +x aria.sh

RUN locale-gen en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8
CMD ["bash","start.sh"]
