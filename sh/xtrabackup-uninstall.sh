#!/bin/bash
# using yum un-install software, please make sure that you has installed yum command.

echo
echo "staring remove xtrabackup"
echo -e "\033[31mWARNING: remove software must has relational authority, so you had better run this script with ROOT \033[0m"
echo
rpm -e --nodeps percona-xtrabackup-80-8.0.33-28.1.el7.x86_64
echo
echo "xtrabackup has been removed"
exit
