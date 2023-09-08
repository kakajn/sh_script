#!/bin/bash
# This is a sh script for mysql8.x install
echo
echo
echo
echo "Start installing Mysql 8.x please waiting...."
echo
echo

#warning: ./mysql-community-client-8.0.33-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
#error: Failed dependencies:
#        mysql-community-client-plugins = 8.0.33-1.el7 is needed by mysql-community-client-8.0.33-1.el7.x86_64
#        mysql-community-libs(x86-64) >= 8.0.11 is needed by mysql-community-client-8.0.33-1.el7.x86_64
#warning: ./mysql-community-common-8.0.33-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
#warning: ./mysql-community-libs-8.0.33-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
#error: Failed dependencies:
#        mysql-community-common(x86-64) >= 8.0.11 is needed by mysql-community-libs-8.0.33-1.el7.x86_64
#warning: ./mysql-community-client-8.0.33-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
#error: Failed dependencies:
#        mysql-community-libs(x86-64) >= 8.0.11 is needed by mysql-community-client-8.0.33-1.el7.x86_64
#warning: ./mysql-community-common-8.0.33-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
#error: Failed dependencies:
#        mysql-community-client(x86-64) >= 8.0.11 is needed by mysql-community-server-8.0.33-1.el7.x86_64
#        mysql-community-icu-data-files = 8.0.33-1.el7 is needed by mysql-community-server-8.0.33-1.el7.x86_64
rpm -ivh ./mysql-community-client-plugins-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-common-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-libs-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-libs-compat-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-icu-data-files-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-client-8.0.33-1.el7.x86_64.rpm
rpm -ivh ./mysql-community-server-8.0.33-1.el7.x86_64.rpm

echo
echo
#echo -e "\033[32mmysql 8.0.33-1.e17 has been installed in your machine.....\033[0m"
#echo -e "\033[32muse command => mysql -u[your accountNumber] -p[your password]            to login\033[0m"
echo "trying open your mysql service....please waiting"
systemctl start mysqld
echo
echo "mysql service has been started!"
echo
echo
echo "initializing your mysql ................"
mysqld --initialize --user=mysql
echo
echo
cat /var/log/mysqld.log
exit