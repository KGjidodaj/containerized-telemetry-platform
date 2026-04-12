#!/usr/bin/env bash

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
echo "INSERT INTO employees (username, password, role) VALUES ('user', 'P@ssw0rd123!', 'admin');" >> "init.sql"

for ((i=0; i<1000; i++))

do
        username=$(./username_generator.py)
        password=$(./password_generator.py)
        echo "INSERT INTO employees (username, password, role) VALUES ('$username', '$password', 'user');" >> "init.sql"

done

echo "Done SQL Initialization."
