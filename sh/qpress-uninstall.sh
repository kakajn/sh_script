#!/bin/bash

echo
echo "un-installing qpress...."
echo
echo
qpress_install_dirs=$(find / -name qpress)
for remove_dir in $qpress_install_dirs; do
    rm -rf $remove_dir
done
rm -rf $qpress_install_dir
echo
echo
echo "qpress has been removed...."
exit