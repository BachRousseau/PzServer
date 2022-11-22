#!/bin/bash
echo "---Instalando dependencias---"
 dpkg --add-architecture i386; apt update;  apt install -y curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 openjdk-17-jre-headless ;  apt upgrade 

adduser ${DIST_USER}

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
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
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
        +force_install_dir ${PZ_SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
else
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${PZ_SERVER_DIR} \
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
	cd ${PZ_SERVER_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/BachRousseau/PzServer/raw/e298e663c54ccbd55f1938c9ed20d0b23ffe054b/Server/serverconfig.zip ; then
		echo "---Sucessfully downloaded server configuration file---"
	else
		echo "---Something went wrong, can't download server configuration file, putting server in sleep mode---"
		sleep infinity
	fi
	unzip -o ${PZ_SERVER_DIR}/cfg.zip
	rm ${PZ_SERVER_DIR}/cfg.zip
else
	echo "---Server configuration files found!---"
fi

echo "---Checking for old logs---"
find ${PZ_SERVER_DIR} -name "masterLog.0" -exec rm -f {} \; > /dev/null 2>&1
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"
echo "---Symbolic links---"
cd ${DATA_DIR}
ln -s /data/gamefiles/start-server.sh "project-zomboid start"

echo "---Start Server---"
