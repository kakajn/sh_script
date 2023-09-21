#!/bin/bash
echo
echo "un-installing wget"
echo
echo
wget_install_info=$(rpm -qa wget)
rpm -e $wget_install_info
echo
echo
echo "wget install finished..."
exit