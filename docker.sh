#!/usr/bin/env bash

set -e

echo "[1/6] Updating system..."
sudo apt update -y

echo "[2/6] Installing required packages..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg

echo "[3/6] Adding Docker’s official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "[4/6] Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[5/6] Updating package index..."
sudo apt update -y

echo "[6/6] Installing Docker Engine + Docker Compose..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling docker to start on boot..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo
echo "🚀 Docker installation complete!"
echo "➡️ Log out and log back in to use docker without sudo."
echo
docker --version
