#!/bin/bash

# 脚本运行的绝对路径
# 获取绝对路径
original_absulute_path=$(pwd)
excute_script_path=$(dirname $original_absulute_path)


#卸载qpress
read -p "是否要卸载qpress? y(yes) n(no):  " input
if [[ $input = "yes" || $input = "y" ]]; then
    $original_absulute_path/component/qpress/qpress-uninstall.sh
fi

#卸载wget
read -p "是否要卸载wget? y(yes) n(no):  " input
if [[ $input = "yes" || $input = "y" ]]; then
    $original_absulute_path/component/wget/wget-uninstall.sh
fi

#卸载xtrabackup
read -p "是否要卸载xtrabackup? y(yes) n(no):  " input
if [[ $input = "yes" || $input = "y" ]]; then
    $original_absulute_path/component/xtrabackup/xtrabackup-uninstall.sh
fi

#是否要卸载mysql
read -p "是否要卸载Mysql 8.X ? y(yes) n(no):  " input
if [[ $input = "yes" || $input = "y" ]]; then
    $original_absulute_path/component/mysql/mysql-uninstall.sh
fi