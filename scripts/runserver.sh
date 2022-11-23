#!/bin/bash

/data/pzserver/start-server.sh -adminpassword ${PZ_ADMIN_PASS} -password ${SERVER_PASSWORD} -servername ${PZ_SV_NAME} -port ${PZ_PORT} -udpport ${PZ_PORT_2} -steamport1 ${STEAM_PORT} -Xmx ${PZ_RAM} 