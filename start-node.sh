#!/bin/bash
set -e

CHAIN_ID="stabletestnet_2201-1"
CONFIG_DIR="/root/.stabled/config"
DATA_DIR="/root/.stabled/data"

echo "==================================="
echo "Stable Node Startup Script"
echo "==================================="


# Check if snapshot should be used
if [ "$USE_SNAPSHOT" = "true" ] && [ ! -f "$DATA_DIR/.snapshot_restored" ]; then
    echo "Downloading and restoring snapshot for fast sync..."
    # Install lz4 if not present
    apt-get update && apt-get install -y lz4 pv
    # Download pruned snapshot
    cd /tmp
    echo "Downloading snapshot (this may take a few minutes)..."
    wget -c https://stable-snapshot.s3.eu-central-1.amazonaws.com/snapshot.tar.lz4
    # Clear any existing data
    rm -rf "$DATA_DIR"/*
    # Extract snapshot
    echo "Extracting snapshot..."
    pv snapshot.tar.lz4 | tar -I lz4 -xf - -C /root/.stabled/
    # Mark snapshot as restored
    touch "$DATA_DIR/.snapshot_restored"
    # Clean up
    rm snapshot.tar.lz4
    echo "Snapshot restored successfully"
fi

echo "Starting Stable node..."
echo "Moniker: $MONIKER"
echo "Chain ID: $CHAIN_ID"
echo "==================================="

# Start the node
exec stabled start --chain-id "$CHAIN_ID"
