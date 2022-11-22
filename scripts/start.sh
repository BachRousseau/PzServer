#!/bin/bash

adduser ${DIST_USER} --disabled-password
 
echo "---Ensuring UID: ${UID} matches DIST_USER---"
usermod -u ${UID} ${DIST_USER}
echo "---Ensuring GID: ${GID} matches DIST_USER---"
groupmod -g ${GID} ${DIST_USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${DIST_USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}


echo "---Taking ownership of data...---"
chown -R root:${GID} /data
chmod -R 750 /data
chown -R ${UID}:${GID} /data

echo "---Starting...---"


if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR}/ -xvzf ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${STEAM_USER}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${STEAM_USER} ${PASSWRD} \
    +quit
fi

echo "---Update Server---"
if [ "${STEAM_USER}" == "" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${PZ_SERVER_DIR}/ \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
else
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${PZ_SERVER_DIR}/ \
        +login ${STEAM_USER} ${PASSWRD} \
        +app_update ${GAME_ID} validate \
        +quit
fi

echo "---Prepare Server---"
echo "---Setting up Environment---"
# export PATH="${PZ_SERVER_DIR}/jre64/bin:$PATH"
# export LD_LIBRARY_PATH="${PZ_SERVER_DIR}/linux64:${PZ_SERVER_DIR}/natives:${PZ_SERVER_DIR}:${PZ_SERVER_DIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
# export JSIG="libjsig.so"
# export JARPATH="java/:java/lwjgl.jar:java/lwjgl_util.jar:java/sqlite-jdbc-3.8.10.1.jar:java/uncommons-maths-1.2.3.jar"
echo "---Looking for server configuration file---"
if [ ! -d ${PZ_SERVER_DIR}/Zomboid ]; then
	echo "---No server configruation found, downloading template---"
	wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/BachRousseau/PzServer/raw/e298e663c54ccbd55f1938c9ed20d0b23ffe054b/Server/serverconfig.zip
    mv -fv serverconfig.zip ${PZ_SERVER_DIR}/ 
	unzip -o ${PZ_SERVER_DIR}/serverconfig.zip
	rm ${PZ_SERVER_DIR}/serverconfig.zip
else
	echo "---Server configuration files found!---"
fi

chmod -R 770 ${DATA_DIR}
echo "---Server ready---"
echo "---Symbolic links---"
ln -s /data/gamefiles/start-server.sh "project-zomboid start"
echo "---Start Server---"
