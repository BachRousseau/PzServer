#!/bin/bash
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

su ${DIST_USER} -c "/data/scripts/install.sh" 