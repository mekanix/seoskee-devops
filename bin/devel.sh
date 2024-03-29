#!/bin/sh


export BIN_DIR=`dirname $0`
export PROJECT_ROOT="${BIN_DIR}/.."
export OFFLINE="${OFFLINE:=no}"


if [ -f /usr/local/bin/cbsd ]; then
  backend_hostname=$(sudo cbsd jexec user=devel jname=seoskeeback hostname)
  sudo cbsd jexec user=devel jname=seoskeeback env OFFLINE=${OFFLINE} /usr/src/bin/init.sh
  sudo tmux new-session -s "seoskee" -d "cbsd jexec user=devel jname=seoskeeback env OFFLINE=${OFFLINE} /usr/src/bin/devel.sh"
  sudo tmux split-window -h -p 50 -t 0 "cbsd jexec user=devel jname=seoskeefront env OFFLINE=${OFFLINE} BACKEND_URL=\"http://${backend_hostname}:5000\" /usr/src/bin/devel.sh"
  sudo tmux a -t "seoskee"
else
  backend_hostname='localhost:5000'
  "${BIN_DIR}/download_repos.sh"
  env OFFLINE=${OFFLINE} "${PROJECT_ROOT}/services/backend/bin/init.sh"
  tmux new-session -s "seoskee" -d "env OFFLINE=${OFFLINE} ${PROJECT_ROOT}/services/backend/bin/devel.sh"
  tmux split-window -h -p 50 -t 0 "env OFFLINE=${OFFLINE} BACKEND_URL=\"http://${backend_hostname}:5000\" ${PROJECT_ROOT}/services/frontend/bin/devel.sh"
  tmux a -t "seoskee"
fi
