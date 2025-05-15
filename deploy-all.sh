#!/bin/bash

set -e

source ./project-config.sh
scp -r docker-compose.yml .env requirements "$REMOTE_USER@$REMOTE_HOST:~/"

ssh "$REMOTE_USER@$REMOTE_HOST" "bash -s" <<'ENDSSH'
  set -e

  if [[ ! -f "$HOME/.init" ]]; then

		ENV_FILE=".env"

		if [[ ! -f "$ENV_FILE" ]]; then
			echo ".env file not found."
			exit 1
		fi

		export $(grep -v '^#' "$ENV_FILE" | xargs)
		rm -rf .env

		sudo apt update
		sudo apt install -y ca-certificates curl gnupg lsb-release ufw

		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

		echo \
			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
			https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
			sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

		sudo apt update
		sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

		sudo usermod -aG docker $USER

		sudo systemctl enable docker
		sudo systemctl start docker

		sudo ufw allow OpenSSH
		sudo ufw allow 80
		sudo ufw allow 443
		sudo ufw --force enable

		touch ~/.init

	fi

  docker compose up --build -d

ENDSSH
