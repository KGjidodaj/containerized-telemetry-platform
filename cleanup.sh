#!/usr/bin/env bash

# sudo privilages
if command -v sudo ;then
        sudo_cmd="sudo"
else
        sudo_cmd=""
fi


echo "cleaning up the directory"

$sudo_cmd docker compose down -v

cd ..

$sudo_cmd rm -rf containerized-telemetry-platform
