1 Linux安装/卸载/升级
  目前支持RedHat Linux和Unbuntu Linux的64位版本，不支持32位Linux。
  默认安装英文版。如果需要更改默认安装语言，请在运行启动脚本之前，打开网管根目录下webapp/WEB-INF/conf/config.properties文件，找到language = en_US，将en_US改为目标语言代码，例如改为language = zh_CN，zh_CN表示简体中文。请在系统初始化之前执行，在运行过后修改对以前数据库保存数据不做转换。修改配置文件重启生效。

1.1 运行步骤
特别注意：
  1.  由于网管需要开启ftp（21）、tftp（69）、Trap接收（162）端口监听，所以网管必须使用root权限运行，否则影响ftp、tftp、Trap接收。影响设备升级和告警接收。
  2.  内嵌Mysql不支持以root权限运行，需要创建或者使用非root用户运行。
前提：存在非root权限用户，Ubuntu Linux默认是非root权限用户，RedHat 默认是root用户，请先创建用户，比如：useradd ems.
步骤：
  1)  请以非root权限用户登录
  2)  把网管压缩包下载到这个用户的主目录，~/NM3000-V*.tar
  3)  对压缩包进行解压：tar xzf NM3000-V*.tar
  4)  进入ems目录：cd ems
  5)  注意：默认安装语言是英文版，如果需要更改为中文版，则需要修改webapp/WEB-INF/conf/config.properties，修改language=zh_CN
  6)  把运行脚本增加可执行权限：chmod +x *.sh
  7)  运行mysql数据库：./startmysql.sh
  8)  以root权限运行启动脚本
     a)  su root进入root用户试图，然后运行./startems.sh(RedHat Linux/ SUSE Linux)
     b)  直接sudo ./startems.sh（Ubuntu Linux）

1.2 卸载
  1)  执行ps –A命令找出mysqld和wrapper的进程号
  2)  执行kill -9 进程号停止Mysql和NM3000服务
注意：NM3000服务需要root权限kill
  3)  退出到ems的上层目录，执行rm –rf ems删除整个目录
注意：删除不可恢复，所有数据也被删除，请谨慎使用。

1.3 脚本执行问题
执行脚本时出现如下报错时
-bash: ./startems.sh: /bin/sh^M: bad interpreter: No such file or directory
-bash: ./startmysql.sh: /bin/sh^M: bad interpreter: No such file or directory
需要注意，这是由于脚本字符编码的原因导致的错误，可以通过执行如下的命令修改脚本字符编码，从而解决问题
dos2unix ./startems.sh 
dos2unix ./startmysql.sh 
dos2unix ./bin/runService.sh 
PS：
1、此步骤不一定需要执行，只在出错是需要执行
2、这里有三个脚本都需要进行转码，任何一个少了都会导致启动不起来

1.4 Linux 打开文件个数限制的问题
1,运行 ./modify_nofile_limit.sh 检查当前的配置
2,修改 /etc/security/limits.conf 文件，修改内容参考下面的参数
* soft nofile 65536
* hard nofile 65536
