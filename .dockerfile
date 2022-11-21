FROM ubuntu:22.04

ENTRYPOINT ["/bin/bash -c"]

WORKDIR /data

RUN apt update && apt upgrade;
  
ENV  SERVER_PASSWORD=""  PZ_PORT=16261 PZ_PORT_2=16262 PZ_ADMIN_PASS="admin123" PZ_SV_NAME="PzServer" UID=1000 GID=1000 STEAMCMD_DIR=/data/steamcmd UMASK=770 STEAM_USER="" STEAM_PASSWD="" DATA_DIR=/data PZ_SERVER_DIR=/data/pzserver SCRIPTS_DIR=/data/scripts DIST_USER="steam" GAME_ID=380870

# Steam Ports
EXPOSE 8766/udp 8767/udp 27015/tcp
# Pz Ports
EXPOSE ${PZ_PORT_2}/TCP ${PZ_PORT}/TCP  ${PZ_PORT_2}/UDP ${PZ_PORT}/UDP

RUN mkdir /data/{scripts,steamcmd,pzserver}

ADD /scripts/start.sh /data/scripts




