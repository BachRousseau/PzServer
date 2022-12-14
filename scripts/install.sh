#!/bin/bash
echo "---Ensuring UID: ${UID} matches DIST_USER---"
usermod -u ${UID} ${DIST_USER}
echo "---Ensuring GID: ${GID} matches DIST_USER---"
groupmod -g ${GID} ${DIST_USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${DIST_USER}


echo "---Taking ownership of data...---"
chown -R root:${GID} /data/
chmod -R 770 /data/
chown -R ${UID}:${GID} /data/

echo "---Starting...---"
su - steam 

if [ ! -f /data/${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O /data/${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz; 
    tar --directory /data/${STEAMCMD_DIR}/ -xvzf /data/${STEAMCMD_DIR}/steamcmd_linux.tar.gz;
    rm /data/${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

chmod -R 770 /data/${STEAMCMD_DIR}/

echo "---Update Server---"
if [ "${STEAM_USER}" == "" ]; then
    	echo "---Validating installation---"
       /data/${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir /data/${PZ_SERVER_DIR}/ \
        +login anonymous \
        +app_update 380870 validate \
        +quit
else
    	echo "---Validating installation---"
        /data/${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir /data/${PZ_SERVER_DIR}/ \
        +login ${STEAM_USER} ${PASSWRD} \
        +app_update 380870 validate \
        +quit
fi

# echo "---Prepare Server---"
# echo "---Setting up Environment---"
#  export PATH="/${PZ_SERVER_DIR}/jre64/bin:$PATH"
# export LD_LIBRARY_PATH="/${PZ_SERVER_DIR}/linux64:/${PZ_SERVER_DIR}/natives:/${PZ_SERVER_DIR}:/${PZ_SERVER_DIR}/jre64/lib/amd64:/${LD_LIBRARY_PATH}"
# export JSIG="libjsig.so"
# export JARPATH="java/:java/lwjgl.jar:java/lwjgl_util.jar:java/sqlite-jdbc-3.8.10.1.jar:java/uncommons-maths-1.2.3.jar"
# echo "---Looking for server configuration file---"
# if [ ! -d /data/${PZ_SERVER_DIR}/Zomboid ]; then
# 	echo "---No server configruation found, downloading template---"
# 	wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/BachRousseau/PzServer/raw/e298e663c54ccbd55f1938c9ed20d0b23ffe054b/Server/serverconfig.zip
#     mv -fv serverconfig.zip /home/${STEAM_USER}/Zomboid/Server 
# 	unzip -o /home/${STEAM_USER}/Zomboid/Server/serverconfig.zip
# 	rm /home/${STEAM_USER}/Zomboid/Server/serverconfig.zip
# else
# 	echo "---Server configuration files found!---"
# fi

echo "---Server ready---"
# echo "---Start Server---"
