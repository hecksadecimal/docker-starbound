FROM node:18

MAINTAINER morgyn

ARG NODE_VERSION=18

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN mkdir -p /steamcmd
RUN mkdir -p /starbound
VOLUME ["/starbound"]
RUN cd /steamcmd \
	&& wget -o /tmp/steamcmd.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
	&& tar zxvf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz \
        && chmod +x ./steamcmd.sh

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
