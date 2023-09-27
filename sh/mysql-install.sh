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
echo
echo "mysql service has been started!"
echo
echo
echo "initializing your mysql ................"
mysqld --initialize --user=mysql
echo
echo
mysql_temporary_password=$(cat /var/log/mysqld.log | grep "A temporary password is generated for" | cut -d ":" -f 4)
echo "这是你第一次登录mysql, 这个是临时生成的登录密码===================>[$mysql_temporary_password]<========================="
read -p "set mysql auto start when boot ? y(yes) n(no) 是否设置mysql开机自动启动  y(yes) n(no):  " input
if [[ input = "yes" || input = "y" ]]; then
    systemctl enable mysqld
fi
echo "trying open your mysql service....please waiting"
systemctl start mysqld
read -p "Do you need that we help you login mysql automatically? y(yes) n(no) 需要我们自动帮你登录mysql吗?
      If you choose no(n), please use the generated password above manually. 如果你选择no, 那么请使用上面生成的密码手动登录
      notice: the command of login mysql use : mysql -u [userName] -p [password]   提示: 可以使用 mysql -u [用户名] -p [密码] 登录mysql
      and once you login mysql you must modify your password for security, if you not anything you do will occur error. 而且mysql为了安全会强制你修改密码, 不然什么操作都会报错
      You can use mysql command: ===>ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password'; <=== to change your password.
      你可以使用 ===>ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码'; <=== 来修改mysql的登录密码
     " input
exit