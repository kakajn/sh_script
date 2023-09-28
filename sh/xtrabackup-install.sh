#!/bin/bash

echo "prepare for installing xtrabackup..."
rpm -ivh ./component/xtrabackup/percona-xtrabackup-80-8.0.33-28.1.el7.x86_64.rpm
echo
echo
echo "installing process is finished"
exit