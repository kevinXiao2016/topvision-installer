#!/bin/sh
echo "检查linux用户开启文件个数的限制"
echo "-------------/etc/security/limits.conf--------------"
cat /etc/security/limits.conf | grep nofile
echo "----------------------------------------------------"

echo "修改/etc/security/limits.conf,在文件末尾加入配置"
echo "假设运行mysql的用户是victor，请将配置修改为:"
echo "victor soft nofile 65536"
echo "victor hard nofile 65536"

