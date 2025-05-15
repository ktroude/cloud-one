#!/bin/bash

set -euo pipefail
source ./project-config.sh

echo "Creating remote directory..."
ssh "$REMOTE_USER@$REMOTE_HOST" "mkdir -p $DEPLOY_DIR"

echo "Copying files..."

echo "Launching docker-compose..."
ssh "$REMOTE_USER@$REMOTE_HOST" "cd $DEPLOY_DIR && "

echo "Deployment complete."
