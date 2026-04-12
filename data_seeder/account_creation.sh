#!/usr/bin/env bash

sleep 0.7
clear
echo "                                                                                [DATABASE INITIALIZATION:]"
# creating the DB with VARCHAR 16 and password 21, as the python files output 15 and 20 (+1 for security reasons)
cat <<DB_CREATION > "init.sql"
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(16),
    password VARCHAR(21),
    role VARCHAR(10)
);
DB_CREATION

# Setting up the user as admin once
user=$(whoami)
echo "INSERT INTO employees (username, password, role) VALUES ('$user', 'P@ssw0rd123!', 'admin');" >> "init.sql"

# Initializing load_percent and bar for a graphical UX experience
load_per=0
bar=""

for ((i=0; i<1000; i++))

do
        username=$(./username_generator.py 2> /dev/null)
        password=$(./password_generator.py 2> /dev/null)
        echo "INSERT INTO employees (username, password, role) VALUES ('$username', '$password', 'user');" >> "init.sql"

        # every 100 iterations the percentage increases
        if (( i%10 == 0 ));then
                (( load_per++ ))

                # Halfing the 100 iterations so only 50 equal signs are outputted to avoid char warping
                if (( load_per % 2 == 0 ));then
                        bar="${bar}="
                fi
        fi
        # using -ne and \r so the same line is rewritten with the load bar
        echo -ne "\r[Configuring Database]                                                                                                                    ${bar}> (${load_per}%)"
done

echo -e "\n\n                                                                              ---Done SQL Initialization---"
