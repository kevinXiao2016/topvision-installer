1. Linux Installation/Uninstall/Upgrade
  The EMS(NM3000) currently supports RedHat Linux / SUSE Linux / Unbuntu Linux 64-bit version does not support any 32-bit version of Linux. 
  If you need to change the default installation language, before running the startup script, open the root directory of the ems management directory webapp/WEB-INF/conf/config.properties file. Before system initialization to perform modifications to the previously saved data is not to convert the database after the operation. Modify the configuration file restart to take effect.

1.1 Installation
Special Note：
  Because the ems needs to open ftp port(21), tftp port(69), Trap receiving port(162) monitor, you must use root privileges to run ems management, or this will affect ftp, tftp, Trap receiver and it will impact future equipment upgrades and alarm reception.
Premise: 
  The existence of a non-root user is premise that Ubuntu Linux uses by default.  The same for RedHat. So it’s important to create a user, such as: useradd ems.
Installation Steps：
  1. Please login as a non-root user 
  2. The ems archive is downloaded to the user's home directory, ~/NM3000-V*.tar 
  3. For the archive to extract: tar xzf NM3000-VX.*.tar 
  4. Into the ems directory: cd ems 
  5. Note: The default installation language is English, if you need to change the other version, you need to modify the webapp/WEB-INF/conf/config.properties,eg. change the Chinese version: language = zh_CN
  6. The *.sh changed executable: chmod +x *.sh
  7. Run mysql database: ./startmysql.sh 
  8. With root privileges to run the startup script 
    1) su root root user tries to enter, and then run: ./startems.sh (RedHat Linux / SUSE Linux) 
    2) Direct run: sudo ./startems.sh (Ubuntu Linux)

1.2 Uninstall
  1. Execute ps -A command to find the process ID mysqld and wrapper 
  2. Execute kill -9 process ID stopped Mysql and wrapper(NM3000 Service)
  Note: NM3000 service requires root privileges kill 
  3. Exit to ems parent directory, execute rm -rf ems delete the entire directory 
  Note: Deleting is not recoverable, all data is deleted, please use caution!

1.3 Script execution problems
When the script is the following error occurred
-bash:./startems.sh: /bin/sh^M: bad interpreter: No such file or directory
-bash:./startmysql.sh: /bin/sh^M: bad interpreter: No such file or directory
Need to pay attention to, this is because the script character coding errors, you can perform the following commands to modify the script character encoding, thus solving the problem
Dos2unix./startems.sh
Dos2unix./startmysql.sh
Dos2unix./bin/runService.sh
PS:
1, this step does not necessarily need to perform, only in the error is required to perform
2, there are three scripts are the need for transcoding, any one less will lead to not start up


1.4 Linux open file limit problems
1,run ./modify_nofile_limit.sh to check current config
2,modify file /etc/security/limits.conf 
* soft nofile 65536
* hard nofile 65536
