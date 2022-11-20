FROM steamcmd/ubuntu-20

ENTRYPOINT ["/bin/sh"]

WORKDIR /data

RUN apt-get update && apt-get upgrade



ENV SERVER_NAME="PzServer" SERVER_PASSWORD="" SERVER_ADMIN_PASSWORD="Admin123" PZ_PORT=16261 PZ_PORT_UDP=16262/udp PZ_ADMIN_PASS="admin123" PZ_SV_NAME="PzServer" UID=1000 GID=1000 STEAMCMD_DIR=/data/steamcmd UMASK=777 STEAM_USER=""

# Steam Ports
EXPOSE 8766/udp 8767/udp 27015/tcp
# Pz Ports
EXPOSE ${PZ_PORT_UDP} ${PZ_PORT}  



CMD ["STEAMCMD","+login anonymous"]



