#!/bin/bash -x

# The standard installation of MySQL includes a prompt for setting the root
# password. To bypass this you need to set the following before starting the
# install
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password password'
apt-get -y install mysql-server-5.6

# Enable remote access for the root user. This will allow them to connect from
# the host, and not just localhost.
# You will get a warning about using the password on the command line, but the
# command will still complete.
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"

# Allow external connections
# Allowing external connections to your MySQL server is normally a bad thing.
# That’s why MySQL has it disabled by default. In order to allow external
# connections, we disable the following lines in /etc/mysql/my.cnf file by
# using sed to comment them out
sed -i "s/skip-external-locking/#skip-external-locking/" /etc/mysql/my.cnf
sed -i "s/bind-address/#bind-address/" /etc/mysql/my.cnf

# Restart mysql
service mysql restart
