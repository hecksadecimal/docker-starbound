FROM ubuntu:16.04

MAINTAINER morgyn

ENV LC_ALL en_US.UTF-8 
RUN locale-gen en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LANG en_US.UTF-8  

ARG NODE_VERSION=18

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y

RUN apt-get install -y \
    ca-certificates \
    software-properties-common \
    python-software-properties \
    lib32gcc1 \
    libstdc++6 \
    curl \
    git \
    wget \
    bsdtar \
    build-essential

RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y nodejs

USER root

RUN mkdir -p /steamcmd
RUN mkdir -p /starbound
VOLUME ["/starbound"]
RUN cd /steamcmd \
	&& wget -o /tmp/steamcmd.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
	&& tar zxvf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz \
        && chmod +x ./steamcmd.sh

RUN [[ -d "/starbound/discord" ]] || git clone https://github.com/MyristicaFragrans/CrossBound.git /starbound/discord

ADD start.sh /start.sh

ADD update.sh /update.sh

# Add initial require update flag
ADD .update /.update

WORKDIR /

EXPOSE 28015
EXPOSE 28016

ENV STEAM_LOGIN FALSE

ENV DEBIAN_FRONTEND newt

ENTRYPOINT ["./start.sh"]
