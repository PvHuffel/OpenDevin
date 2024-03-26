#!/bin/bash
set -eo pipefail

rm -rf `pwd`/workspace
mkdir -p `pwd`/workspace

pushd agenthub/langchains_agent
docker build -t control-loop .
popd
docker run \
    -e DEBUG=$DEBUG \
    -e DOCKER_HOST="unix:/var/run/docker.sock" \
    -u `id -u`:`id -g` \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v `pwd`/workspace:/workspace \
    -v `pwd`:/app:ro \
    -e PYTHONPATH=/app \
    control-loop \
    python /app/opendevin/main.py -m "llama2" -d /workspace -t "${1}" 

