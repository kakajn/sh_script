#!/bin/bash

echo
echo "installing qpress...."
echo
echo
qpress_install_path="/usr/local/bin/"

## 安装到这个目录下面
tar -xf ./component/qpress/qpress-11-linux-x64.tar -C $qpress_install_path
## 重新执行这个脚本加载环境变量
source /etc/profile
echo
echo
echo "qpress has been installed...."
exit