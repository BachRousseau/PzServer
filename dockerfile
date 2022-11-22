FROM ubuntu:22.04

ENTRYPOINT ["/bin/bash","-c"]

RUN  dpkg --add-architecture i386;

RUN apt-get update;

RUN apt install -y curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 openjdk-17-jre-headless;

RUN apt-get upgrade;

ENV  SERVER_PASSWORD="" PZ_PORT=16261 PZ_PORT_2=16262 PZ_ADMIN_PASS="admin123" PZ_SV_NAME="PzServer" UID=1000 GID=1000 STEAMCMD_DIR=steamcmd UMASK=770 STEAM_USER="" STEAM_PASSWD="" DATA_DIR=/data PZ_SERVER_DIR=pzserver SCRIPTS_DIR=scripts DIST_USER="steam" GAME_ID=380870

# Steam Ports && PZ PORTS
EXPOSE 8766 8767 27015 ${PZ_PORT_2} ${PZ_PORT} 4380

WORKDIR /${DATA_DIR}

RUN mkdir ${PZ_SERVER_DIR} ${STEAMCMD_DIR} ${SCRIPTS_DIR}

ADD https://transfer.sh/namEmS/start.sh /data/scripts

RUN chmod +770 /data/scripts/start.sh

CMD ["/data/scripts/start.sh" ]




