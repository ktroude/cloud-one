#!/bin/bash

set -euo pipefail

ENV_FILE=".env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo ".env file not found."
  exit 1
fi

export $(grep -v '^#' "$ENV_FILE" | xargs)
