FROM steamcmd/ubuntu-20

ENTRYPOINT ["/bin/sh"]

WORKDIR /data

RUN sudo dpkg --add-architecture i386; sudo apt update; sudo apt install curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 openjdk-17-jre-headless ;sudo apt upgrade 

ENV  SERVER_PASSWORD=""  PZ_PORT=16261 PZ_PORT_2=16262 PZ_ADMIN_PASS="admin123" PZ_SV_NAME="PzServer" UID=1000 GID=1000 STEAMCMD_DIR=/data/steamcmd UMASK=770 STEAM_USER="" DATA_DIR=/data PZ_SERVER_DIR=/data/pzserver SCRIPTS_DIR=/data/scripts

# Steam Ports
EXPOSE 8766/udp 8767/udp 27015/tcp
# Pz Ports
EXPOSE ${PZ_PORT_2}/TCP ${PZ_PORT}/TCP  ${PZ_PORT_2}/UDP ${PZ_PORT}/UDP  






