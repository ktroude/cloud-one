#!/bin/bash

source ./project-config.sh

ssh "$REMOTE_USER@$REMOTE_HOST" "bash -s" <<'ENDSSH'
  set -e

  rm -rf ~/*

  sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo apt autoremove -y

  sudo apt purge -y ufw
  sudo apt autoremove -y

  sudo rm -rf /etc/apt/keyrings/docker.gpg
  sudo rm -f /etc/apt/sources.list.d/docker.list

ENDSSH
