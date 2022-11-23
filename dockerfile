FROM ubuntu:22.04

ENTRYPOINT ["/bin/bash -c"]

WORKDIR /data

RUN  dpkg --add-architecture i386;

RUN apt-get update -y; \
    apt install -y curl wget file tar bzip2 gzip unzip lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 openjdk-17-jre-headless; \
    apt-get upgrade -y;

ENV  SERVER_PASSWORD="" PZ_PORT=16261 PZ_PORT_2=16262 PZ_ADMIN_PASS="admin123" PZ_SV_NAME="PzServer" UID=1000 GID=1000 STEAMCMD_DIR=steamcmd STEAM_USER="" STEAM_PASSWD="" PZ_SERVER_DIR=pzserver SCRIPTS_DIR=scripts DIST_USER="steam" GAME_ID=380870 STEAM_PORT=27015 PZ_RAM=3GB

# Steam Ports && PZ PORTS
EXPOSE 8766/tcp 8767/tcp ${STEAM_PORT}/tcp ${PZ_PORT_2}/tcp ${PZ_PORT}/tcp 4380/tcp 8766/udp 8767/udp ${STEAM_PORT}/udp ${PZ_PORT_2}/udp ${PZ_PORT}/udp 4380/udp

RUN mkdir ${PZ_SERVER_DIR} ${STEAMCMD_DIR} ${SCRIPTS_DIR}

ADD https://transfer.sh/95MEIS/install.sh /data/scripts

ADD https://transfer.sh/Ir1hbB/runserver.sh /data/scripts

RUN chmod +770 /data/scripts/* && adduser ${DIST_USER} --disabled-password

RUN /data/scripts/install.sh


CMD ["/data/scripts/runserver.sh"]




