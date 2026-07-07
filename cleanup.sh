#!/usr/bin/env bash

# Checking for sudo privilages.
if command -v sudo ;then
        sudo_cmd="sudo"
else
        sudo_cmd=""
fi

# Stopping all running instances.
echo "cleaning up the directory"
$sudo_cmd docker compose down -v

# Removing the instance.
cd ..
$sudo_cmd rm -rf containerized-telemetry-platform
