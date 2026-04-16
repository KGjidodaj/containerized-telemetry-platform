#!/usr/bin/env bash

if ! command -v python3 >/dev/null 2>&1 ;then
	echo "Python missing install it first"
	exit 1
fi

sleep 0.7
clear
echo "                                                                                [DATABASE INITIALIZATION:]"
# creating the DB with VARCHAR 16 and password 21, as the python files output 15 and 20 (+1 for security reasons)
cat <<DB_CREATION > "init.sql" ## the init.sql will create a different database than mockDB (which is empty)
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(16),
    password VARCHAR(21),
    role VARCHAR(10)
);
DB_CREATION

# Setting up the user as admin once for the init.sql file
user=$(whoami)
# using a different password for root and admin users here and in the docker-compose file with only difference the o and 0 
echo "INSERT INTO employees (username, password, role) VALUES ('$user', 'P@ssw0rd123!', 'admin');" >> "init.sql"

# setting up the html file with some generic colour
cat <<HTML_CREATION > "index.html"
<!DOCTYPE html>
<html>
<head>
    <style>
        body { background-color: #1e1e1e; color: #00ff00; font-family: monospace; padding: 20px; }
        table { border-collapse: collapse; width: 50%; background-color: #2d2d2d; }
        th, td { border: 1px solid #555; padding: 8px; text-align: left; }
        th { background-color: #444; }
    </style>
</head>
<body>
    <h1> Employee Intranet - Accounts Directory</h1>
    <table>
        <tr>
            <th>Username:</th>
            <th>Password:</th>
        </tr>
HTML_CREATION

# Initializing load_percent and bar for a graphical UX experience
load_per=0
bar=""

for ((i=0; i<500; i++))

do
        username=$(./username_generator.py 2> /dev/null)
        password=$(./password_generator.py 2> /dev/null)
	# saving into init.sql
        echo "INSERT INTO employees (username, password, role) VALUES ('$username', '$password', 'user');" >> "init.sql"
	# saving into index.html
        { echo "        <tr>"
        echo "            <td>$username</td>"
        echo "            <td>$password</td>"
        echo "        </tr>"
        } >> "index.html"

        # adding this for the percentage to increase as a (load bar)
        if (( i%5 == 0 ));then
                (( load_per++ ))

                # Halfing the 100 iterations so only 50 equal signs are outputted to avoid char warping
                if (( load_per % 2 == 0 ));then
                        bar="${bar}="
                fi
        fi
        # using -ne and \r so the same line is rewritten with the load bar
        echo -ne "\r[Configuring Database]                                                                                                             ${bar}> (${load_per}%)"
done

echo -e "\n\n                                                                              ---Done SQL&HTML Initialization---"

# Close the file
{ echo "    </table>"
echo "</body>"
echo "</html>"
} >> "index.html"
