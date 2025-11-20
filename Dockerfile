FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    jq \
    unzip \
    lz4 \
    pv \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install Stable binary
RUN wget https://stable-testnet-data.s3.us-east-1.amazonaws.com/stabled-latest-linux-amd64-testnet.tar.gz -O /tmp/stable.tar.gz \
    && tar -xzf /tmp/stable.tar.gz -C /tmp \
    && mv /tmp/stabled /usr/local/bin/stabled \
    && chmod +x /usr/local/bin/stabled \
    && rm /tmp/stable.tar.gz

# Create necessary directories
RUN mkdir -p /root/.stabled/config /root/.stabled/data

# Set working directory
WORKDIR /root/.stabled
COPY genesis.json /root/.stabled/config/genesis.json
COPY config.toml /root/.stabled/config/config.toml
COPY app.toml /root/.stabled/config/app.toml

# Copy initialization and startup scripts
COPY start-node.sh /usr/local/bin/start-node.sh
RUN chmod +x /usr/local/bin/start-node.sh

# Expose ports
# 26656: P2P
# 26657: RPC
# 8545: JSON-RPC
# 8546: JSON-RPC WebSocket
EXPOSE 26656 26657 8545 8546

# Use start script as entrypoint
ENTRYPOINT ["/usr/local/bin/start-node.sh"]
