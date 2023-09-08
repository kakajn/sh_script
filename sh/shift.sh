#!/bin/bash
# 遍历所有变量
for i in "$@"; do
  echo $($i)"本次"
done