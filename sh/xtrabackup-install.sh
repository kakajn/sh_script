#!/bin/bash
# using yum un-install software, please make sure that you has installed yum command.

echo
echo "staring remove xtrabackup"
echo "\033[31mWARNING: remove software must has relational authority, so you had better run this script with ROOT "
echo
xtrabackup_install_info=$(yum search xtrabackup)
for item in $xtrabackup_install_info; do
  yum remove $item
done
echo
echo "xtrabackup has been removed"
exit
