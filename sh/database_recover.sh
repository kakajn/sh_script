#!/bin/bash
echo " Now we will give user two instance to show how to use this sh command to recover a database:
       -w meaning use internet to download .xb file, if you use this way get .xb file you needn't download .xb file to local
       -t meaning the recovered file put where you want, in linux it's a relative file path or absolute path
       -l meaning you down load .xb file to local file system, and if you use this way to recover you database, you can't use -w option anymore
          cause it will occur conflict, we can't guess witch way to get the .xb file

       Two example blow:
       use -w option: database_recover -w www.tencent.com -t /data/mysql_back_up
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
l_model=""

#数据库备份文件的位置
xb_file_path=$1

#解压文件的输出位置
unpress_file_path=$2

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
      w_param=$[$next_arg]
   ;;
   "-l")
      l_param=$[$next_arg]
   ;;
    "-t")
      t_param=$[$next_arg]
   ;;
    *)
      echo "参数校验不合法请填写正确的参数"
      exit
   ;;
   esac
    # 经过这一步之后因为进行了参数值的获取, 所以要 +1
    i=$[$i+1]
done

# 判断当前使用的是什么模式进行获取.xb文件的
 if( -z $w_mode & -z $l_mode ); then
     echo "不能同时使用 -w模式 和 -l 模式"
     exit
 elif( -z $w_mode ); then
   use_mode="w_model"
 else
   use_model="l_model"
 fi

# 获取脚本运行路径
cd $0
script_path=$(pwd)
# 如果是 -w 模式, 判断一下是不是安装了 weget
if(-z $(ls /bin | grep wget)); then
    #使用wget命令进行下载安装 .xb 文件
    #使用函数构建.xb文件的名字
    w_xb_file_name=$(date "+%Y_%m_%d_%H%M%S").xb
    # 下载文件
    wget -c '$w_param' -O '$script_path/temp/$w_xb_file_name'
fi

# mysql通用配置脚本位置
mysql_general_config_file_path=$script_path/component/mysql/

# mysql配置文件的名字
mysql_config_file_name="backup-my.cnf"

#配置错误信息通用提示
install_error="没有安装软件--------------------->"

#告诉用户使用线上数据库的密码通知
tell_user_how_to_login_in_mysql="数据已经被恢复成功, 密码被备份的数据库的密码, 请直接使用备份数据库直接进行登录以检查数据的完整性"

# 数据库恢复软件的位置back
xtra_backup_path=$script_path/component/xtra/.tar安装位置

# mysql的TCP端口
mysql_tcp_port=3306

# 定义临时存储结构
run_temp_variable=""

# 进行文件解析
xbstream -x  -C unpress_file_path < xb_file_path

# 进行解压缩
xtrabackup --decompress --target-dir=unpress_file_path

# 进行prepare操作
xtrabackup --prepare  --target-dir=unpress_file_path

# 把通用mysql配置文件和解压出来的数据库进行替换
# 删除原来的配置文件
rm -rf unpress_file_path/backup-my.cnf
# 把通用文件复制到这个文件件中
cp "$mysql_general_config_file_path/$mysql_config_file_name" "$unpress_file_path/$mysql_config_file_name"

# 获取现在系统上面所有的TCP端口号, 并检查 3306 端口号是否被占用
run_temp_variable=$(netstat -tuln | grep $mysql_tcp_port)
# 判断这个结果为不为null
# 如果为null说明3306 没有被占用, 直接使用3306
if [ -z $run_temp_variable ]; then
    mysql_tcp_port=3306
else
# 那么就生成一个 3306 - 10000 之间的随机数
# 这里让他做一个循环, 如果有端口占有就一直生成
   while [ -z $run_temp_variable ]; do
          mysql_tcp_port=$(shuf -i 3306-10000 -n 1)
          run_temp_variable=$(netstat -tuln | grep $mysql_tcp_port)
   done
fi
# 这里把配置直接写入 mysql 的配置文件
echo prot=$mysql_tcp_port >> "$unpress_file_path/$mysql_config_file_name"

#改变文件的所有者
chown -R mysql:msyql "$unpress_file_path"

# 使用mysqld命令启动mysql服务 并指定端口号
mysqld_safe --defaults-file="$unpress_file_path/$mysql_config_file_name" --user=root --datadir="a$unpress_file_path" &

# 提示用户登录密码为线上数据库密码
ehco $tell_user_how_to_login_in_mysql

# 在退出之后删除临时文件如果是以 -w 方式进行获取文件的haul
rm -rf '$script_path/temp/$w_xb_file_name'

# 按住任意键进行退出
read -p "数据库恢复已经完成, 按住任意键进行退出" exit_input_content

# 退出命令
exit 
