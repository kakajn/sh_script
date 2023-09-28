#!/bin/bash
echo " Now we will give user two instance to show how to use this sh command to recover a database:
       -w meaning use internet to download .xb file, if you use this way get .xb file you needn't download .xb file to local
       -t meaning the recovered file put where you want, in linux it's a relative file path or absolute path
       -l meaning you down load .xb file to local file system, and if you use this way to recover you database, you can't use -w option anymore
          cause it will occur conflict, we can't guess witch way to get the .xb file

       Two example blow:
       use -w option: database_recover -w "www.tencent.com" -t /data/mysql_back_up
       use -l option: database_recover -l /data/mysql-backup.xb -t /data/mysql_back_up

       Due to this script must get root authority to execute, and we will create a directory to mysql, and make it get all permission to the
       file that we made, so you had better run it with root account
     "

echo "现在举一个例子来说明如何使用这个命令, 如果你想恢复一个数据库文件可以使用一下的命令:
      * -w 表示一个这个xb文件在网络中的位置(file urlPath in webSite), 使用这种方式你就可以不必再把.xb 下载到本地在执行这个命令
      * -t 表示恢复的数据库文件所存放的位置(target output file path)
      * -l 表示你把xb文件下载到了本地, 需要使用这种方式进行恢复, 如果-w 参数和-o 参数都不填写, 那么程序退出, 因为无法判断你要恢复的是哪一个文件

      下面有两个例子可以参考:
      这个命令是一个使用网络下载的例子: database_recover -w www.tencent.com -t /data/mysql_back_up
      这个命令是一个使用本地文件的例子: database_recover -l /data/mysql-backup.xb -t /data/mysql_back_up

      由于脚本本身需要root权限进行执行, 并且要给创建的文件进行授权, 所以最好保证创在root权限下进行执行这个脚本
      "

# 如果有 -w 选项就是w模式
w_mode=""

# 如果有 -o 就是-o模式
l_mode=""

#数据库备份文件的位置
xb_file_path=""

#解压文件的输出位置
unpress_file_path=""

#定义恢复仓库的文件夹名字
recovered_backup_repository_name="recovered_backup_repository"

# 定义参数数组
args=("$@")

# 遍历参数数组
for ((i = 0; i < ${#args[@]}; i++)); do
    current_arg="${args[i]}"

    # 获取下一个参数（如果存在）
    if ((i + 1 < ${#args[@]})); then
        next_arg="${args[i + 1]}"
    else
        next_arg=""
    fi

    # 处理当前参数
   case $current_arg in
   "-w")
      w_param=$next_arg
      #设置使用模式
      w_mode="w_mode"
   ;;
   "-l")
      l_param=$next_arg
      l_mode="l_mode"
   ;;
    "-t")
      t_param=$next_arg
      unpress_file_path=$next_arg
   ;;
    *)
      echo "参数校验不合法请填写正确的参数"
      exit
   ;;
   esac
    # 经过这一步之后因为进行了参数值的获取, 所以要 +1
    i=$[$i+1]
done

#打印参数
echo "w_param参数是: $w_param"
echo "l_param参数是: $l_param"
echo "t_param参数是: $t_param"

# 判断当前使用的是什么模式进行获取.xb文件的
 if [[ -n $w_mode && -n $l_mode ]]; then
     echo "不能同时使用 -w模式 和 -l 模式"
     exit
elif [[ -n $w_mode ]]; then
   use_mode="w_mode"
 else
   use_mode="l_mode"
 fi

# 如果模式use_model是 l_mode 那么进行赋值
if [ $use_mode = "l_mode" ]; then
    xb_file_path=$l_param
fi

#echo "使用的模式是: $use_mode"
#read -p "debug暂停:  " input

# 获取脚本运行路径
script_path=$(pwd)

#判断存放恢复之后的本地文件的参数为不为空
if [[ -z $t_param ]]; then
    unpress_file_path="$script_path/$recovered_backup_repository_name"
else
  recovered_backup_repository=$t_param
fi

# 如果是 -w 模式, 判断一下是不是安装了 weget, 并且use_mode是w_mode
if [[ -n $(which wget) ]]; then
  if [ $use_mode = "w_mode" ]; then
          #使用wget命令进行下载.xb 文件
          #使用函数构建.xb文件的名字
          w_xb_file_name=$(date "+%Y_%m_%d_%H%M%S").xb
          # 下载文件
          echo -e "\033[31m开始下载文件, 现在文件的临时文件存放在: $script_path/temp/$w_xb_file_name\033[0m"
      #    wget -c "[$w_param]" -O "$script_path/temp/$w_xb_file_name"
          #赋值给恢复文件的位置
          xb_file_path=$script_path/temp/$w_xb_file_name
  fi
else
    echo -e "\033[31m发现用户并未安装wget插件, 不能使用-w参数, 如果要使用请自行安装wget\033[0m"
fi

#echo "wget暂存的文件位置为: $script_path/temp/$w_xb_file_name"
#read -p "debug暂停:  " input

# mysql通用配置脚本位置
mysql_general_config_file_path=$script_path/component/mysql/

# mysql配置文件的名字
mysql_config_file_name="backup-my.cnf"

#配置错误信息通用提示
install_error="没有安装软件--------------------->"

#告诉用户使用线上数据库的密码通知
tell_user_how_to_login_in_mysql="数据已经被恢复成功, 密码被备份的数据库的密码, 请直接使用备份数据库直接进行登录以检查数据的完整性"

# 进行文件解析
xbstream -x  -C $unpress_file_path < $xb_file_path

# 进行解压缩
xtrabackup --decompress --target-dir=$unpress_file_path

# 进行prepare操作
xtrabackup --prepare  --target-dir=$unpress_file_path

# 把通用mysql配置文件和解压出来的数据库进行替换
# 删除原来的配置文件
rm -rf $unpress_file_path/backup-my.cnf

# 把通用文件复制到这个文件件中
cp "$mysql_general_config_file_path/$mysql_config_file_name" "$unpress_file_path/$mysql_config_file_name"

# mysql的TCP端口
mysql_tcp_port=3306

## 定义临时存储结构
#run_temp_variable=""
#
## 获取现在系统上面所有的TCP端口号, 并检查 3306 端口号是否被占用
#run_temp_variable=$(netstat -tuln | grep $mysql_tcp_port)
#
## 判断这个结果为不为null
## 如果为null说明3306 没有被占用, 直接使用3306
#if [[ -z $run_temp_variable ]]; then
#    mysql_tcp_port=3306
#else
## 那么就生成一个 3306 - 10000 之间的随机数
## 这里让他做一个循环, 如果有端口占有就一直生成
#   while [[ -n $run_temp_variable ]]; do
#          mysql_tcp_port=$(shuf -i 3306-10000 -n 1)
#          run_temp_variable=$(netstat -tuln | grep $mysql_tcp_port)
#   done
#fi
# 这里把配置直接写入 mysql 的配置文件
#echo prot=$mysql_tcp_port >> "$unpress_file_path/$mysql_config_file_name"

#改变文件的所有者
chown -R mysql:mysql "$unpress_file_path"

# 使用mysqld命令启动mysql服务 并指定端口号
#mysqld --defaults-file="/data/725backup/backup-my.cnf " --user=root --datadir="/data/725backup/" --port=5636 &
#关闭mysql的服务, 防止有其他服务在运行
systemctl stop mysqld
mysqld --defaults-file="$unpress_file_path/$mysql_config_file_name" --user=root --datadir="$unpress_file_path" --port=$mysql_tcp_port &

#打开tcp端口, 可以进行访问
sudo firewall-cmd --zone=public --add-port=$mysql_tcp_port/tcp --permanent

#同时重新启动防火墙
sudo firewall-cmd --reload

# 提示用户登录密码为线上数据库密码
echo
echo
echo $tell_user_how_to_login_in_mysql
echo
echo

# 在退出之后删除临时文件如果是以 -w 方式进行获取文件的haul
if [ use_mode = "w_mode" ]; then
    rm -rf '$script_path/temp/$w_xb_file_name'
fi

# 按住任意键进行退出
read -p "数据库恢复已经完成, 按住任意键进行退出..................... " exit_input_content

# 退出命令
exit 
