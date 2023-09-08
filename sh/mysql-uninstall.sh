#!/bin/bash
# This is a sh script for mysql 8.x un-install
echo "starting un-install your mysql 8.x version"
echo
echo

# 停止mysql服务
echo "starting stop mysql service"
systemctl stop mysqld

# find all mysql rpm install package
mysql_install_packages=$(rpm -qa | grep mysql)
echo "remove rpm package...."
echo $mysql_install_packages
if [ -z "$mysql_install_packages" ]; then
    echo "no one rpm package fund in your machine.... and prepare cleaning mysql conf file...."
else 
    echo "starting remove rpm package...."
    for package in $mysql_install_packages; do
        # echo $package
        rpm -e --nodeps $package
    done
    echo "rpm package has all removed"
fi

# 删除mysql的数据文件
read -p "delete mysql data file? y(yes) or n(no)" input
if [[ $input = "yes" || $input = "y" ]]; then
    # 寻找所有mysql数据文件进行删除
    # 重新设置分隔符
    IFS=$' '
    mysql_data_file_paths=$(find / -name mysql)
    # echo $mysql_data_file_paths
    for file_path in mysql_data_file_paths; do
        echo $file_path
        rm -rf $file_path
    done
    echo "all the mysql data file has been removed"
fi

# 删除mysql的配置文件
read -p "delete mysql config file? y(yes) or n(no)" input
if [[ $input = "yes" || $input = "y" ]]; then
    # 寻找mysql的配置文件进行删除
    # echo "mysql config file is deleted!"
    rm -rf /etc/my.cnf
fi

echo
echo
echo
echo "mysql 8.x has been removed from your machine! "
exit