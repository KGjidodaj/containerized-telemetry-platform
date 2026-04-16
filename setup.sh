#!/usr/bin/env bash

# sudo privilages
if command -v sudo ;then
	sudo_cmd="sudo"
else
	sudo_cmd=""
fi


echo "Setting up privilages for all the files"

$sudo_cmd chmod +x system_audit.sh cleanup.sh >/dev/null 2>&1

cd data_seeder

$sudo_cmd chmod +x account_creation.sh password_generator.py username_generator.py >/dev/null 2>&1

echo "setting up .html and .sql files"

./account_creation.sh

#going back to the .yaml file
cd ..

echo "This might take some time"
sleep 1

# calling the composer (docker-compose)
$sudo_cmd docker compose up -d --build

echo "docker compose finished"

$sudo_cmd docker exec -it sentinel_node bash
