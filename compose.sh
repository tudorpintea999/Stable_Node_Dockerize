#!/usr/bin/env bash

set -e

# Choose latest version automatically
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
    | grep tag_name \
    | cut -d '"' -f 4)

echo "📦 Latest Docker Compose version: $COMPOSE_VERSION"

echo "[1/3] Downloading Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

echo "[2/3] Making it executable..."
sudo chmod +x /usr/local/bin/docker-compose

echo "[3/3] Verifying installation..."
docker-compose --version

echo
echo "🚀 Docker Compose installed successfully!"
echo
