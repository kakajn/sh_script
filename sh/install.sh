#!/bin/bash
echo "

      This sh program is for installing serial software and if you has installed those, this sh programing will ignore
      install the software that you has installed. Those software will be installed on your machine:

          * Xtrabackup : for recovering your data file from mysql.
          * Wget: cause some resource we want to use network to download, and need not download it manually.
          * Qpress: a excellent unzip util, cause xtrabackup default unzip util is Qpress, so we must install.
          * Mysql 8.x: this data cover util is base on mysql 8.x, so we will install mysql 8.x for checking whether covered successfully.

     "

# checking whether user installed wget
has_install_wget=$(echo $(ls /bin | grep wget | head -n 1))
has_install_xtrabackup=$(echo $(ls /bin | grep xtrabackup | head -n 1))
has_install_qpress=$(echo $( ls /usr/local/bin/ | grep qpress | head -n 1))
has_install_mysql=$(echo $(ls /bin | grep mysql | head -n 1))

# 脚本运行的绝对路径
# 获取绝对路径
original_absulute_path=$(pwd)
excute_script_path=$(dirname $original_absulute_path)

echo $has_install_wget
echo $has_install_xtrabackup
echo $has_install_qpress
echo $has_install_mysql

# mysql
echo
echo
echo "<============================== checking for wget install ============================================> "
if [ -z $has_install_wget ]; then
      # 安装wget
      echo "wget did not install, we will install wget!"
      rpm -ivh $excute_script_path/component/wget-1.14-18.el7_6.1.x86_64.rpm
else
      echo "you has has installed weget! so we will not help you install wget!"
fi

echo
echo
echo "<============================== checking for xtrabackup install ======================================> "
# checking whether user installed xtrabackup
if [ -z $has_install_xtrabackup ]; then
      # 安装wget
      echo "xtrabackup did not install, we will install xtrabackup!"
      rpm -ivh $excute_script_path/component/percona-xtrabackup-80-8.0.33-28.1.el7.x86_64.rpm
else
      echo "you has has installed xtrabackup! so we will not help you install xtrabackup!"
fi

echo
echo
echo "<============================== checking for qpress install ==========================================> "
# checking whether user installed qpress
if [ -z $has_install_qpress ]; then
      # 安装wget
      echo "qpress did not install, we will install qpress!"
      tar -xf $excute_script_path/component/qpress-11-linux-x64.tar -C /usr/local/bin
      source /etc/profile
else
      echo "you has has installed qpress! so we will not help you install qpress!"
fi

echo
echo
echo "<============================== checking for msyql 8.x install =======================================> "

# checking whether user installed mysql
if [ -z $has_install_mysql ]; then
        # 安装wget
        echo "mysql did not install, we will install mysql 8.x for you!"
        # 这里是安装mysql 8.0 的程序
        rpm -ivh $excute_script_path/component/qpress.rpm
else
      echo "you has has installed mysql! so we will not help you install mysql!"
      # 并提示如果你安装的不是 mysql 8.0 版本, 那么程序跑不起来, 因为很多依赖是mysql 8.x 的新特性
      echo -e "\033[35mWARNING: we detected that you has installed mysql, but we don't make sure the version is right.
                       we can detected what mysql version you installed. but if it version is below 8.x, we think
                       all the data that stored in your database is very important and  we can't drop your database
                       and help you install mysql 8.x . So please make sure that your mysql version is greater than 8.0
                \033[0m"
fi

exit

