#!/bin/bash

TTYTTER="watcher/ttytter";
TTYTTER_LIB="watcher/twitter-contest.pl";
if [ -z $TWUSER ]; then
	TWUSER="-anonymous"
fi
LIB_ARG="-exts"
#DAEMON_MODE="-daemon -silent";
DAEMON_MODE="-daemon";

LOG_FILE="ttytter.log"

echo "starting twitter watcher (${TTYTTER} ${TWUSER} ${DAEMON_MODE} ${LIB_ARG}=${TTYTTER_LIB})"
${TTYTTER} ${TWUSER} ${DAEMON_MODE} ${LIB_ARG}=${TTYTTER_LIB} 2>&1 >> ${LOG_FILE}
#${TTYTTER} ${TWUSER} ${DAEMON_MODE} ${LIB_ARG}=${TTYTTER_LIB}
