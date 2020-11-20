#!/bin/bash
HOME_DIR_PATH="$(dirname $(realpath $0))"

cd ${HOME_DIR_PATH}/..
gatsby build

if [ $? -ne 0 ]
then
	echo "[ERORR] Failed to gatsby build"
	exit 1
fi

sleep 5
