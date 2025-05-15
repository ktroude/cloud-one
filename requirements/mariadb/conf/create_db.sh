#!/bin/sh

# Stop script on error
set -e

# Ensure correct ownership
chown -R mysql:mysql /var/lib/mysql

# If MySQL system database doesn't exist, initialize it
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Initializing MySQL system database..."
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
fi

# If target database doesn't exist, create it and the user
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "[INFO] Creating initial database and user..."

    # Create SQL file dynamically with expanded variables
    cat <<EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run the SQL script using the existing mysqld (in bootstrap mode)
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/init.sql

    # Clean up
    rm -f /tmp/init.sql
fi
