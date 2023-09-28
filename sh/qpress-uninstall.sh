#!/bin/bash

echo
echo "un-installing qpress...."
echo
echo
script_path=$(pwd)
qpress_install_dirs=$(find / -name qpress)
for remove_dir in $qpress_install_dirs; do
  if [ -z $(echo $remove_dir | grep $script_path) ]; then
       rm -rf $remove_dir
  fi
done
rm -rf $qpress_install_dir
echo
echo
echo "qpress has been removed...."
exit