#!/bin/bash

# Program:
#   NM3000 Server Auto Install SHell
# History: 2015-3-1 Rod Johnson First release

# History: 2015-9-1 Rod Johnson Second release

# History: 2015-9-10 Rod Johnson Third release

# History: 2016-3-18 Rod Johnson Forth release (add ulimit file)

# History: 2016-6-20 Rod Johnson Fifth release (add EngineMgr install)

# HIstory: 2016-9-20 ROd Johoson Sixth release (add auto memory config)

# Check User Authority
if [ `id -u` -ne 0 ];then
echo "INSTALL ERROR: You must use root to install NM3000"
exit 0
fi

# Check Linux Release
LINUXRELEASE=0
if [ -f /etc/redhat-release ]; then
  linux_release_redhat=$(cat /etc/redhat-release|awk '{print $1$2}'|grep 'RedHat')
  linux_release_centos=$(cat /etc/redhat-release|awk '{print $1}'|grep CentOS)
  if [ ! -z $linux_release_redhat ]; then
    LINUXRELEASE='RedHat'
  fi
  echo $linux_release_centos
  if [ ! -z $linux_release_centos ]; then
    LINUXRELEASE='CentOS'
  fi
else
  linux_release_ubuntu=$(cat /etc/issue|sed -n '1p'|awk '{print $1}'|grep Ubuntu)
  if [ ! -z $linux_release_ubuntu ]; then
    LINUXRELEASE='Ubuntu'
  fi
fi

if [ $LINUXRELEASE = 0 ]; then
  echo "INSTALL ERROR: Unknown Linux Release"
  exit 0
fi

echo -e "Linux Release : $LINUXRELEASE"

# Type: 1/8G 2/16G 3/32G 4/64G
MEMORYTYPE=1;

linux_memory=$(cat /proc/meminfo |grep 'MemTotal' |awk -F : '{print $2}' |awk -F " " '{print $1}')

linux_memory_G=`expr $linux_memory / 1024 / 1024`;

echo -e "Linux Memory : $linux_memory";


if [ $linux_memory_G -ge 60 ]; then
   MEMORYTYPE=4;
elif [ $linux_memory_G -ge 30 ]; then
   MEMORYTYPE=3;
elif [ $linux_memory_G -ge 15 ]; then
   MEMORYTYPE=2;
fi

echo -e "MEMORYTYPE :  $MEMORYTYPE";



command -v systemctl > /dev/null
if [ $? == 0 ]; then
  systemdSupport='systemd_supported'
else
  systemdSupport='systemd_no_supported'
fi
echo $systemdSupport

# Check Intall Tar File
TAR_FILE=setup

if [ ! -f $TAR_FILE ]; then
   echo "INSTALL ERROR: Parameter Error: Install Tar File setup not exists"
   exit 0
fi


# Install Confirm
if (! whiptail --title "Install NM3000" --yesno "Install NM3000" 10 60 ); then
exit 0;
fi


NM3000REMOVESERVICE=0
# Install Service Status
if [ $systemdSupport = 'systemd_supported' ]; then
  if [ -f /etc/systemd/system/nm3000 ]; then
    NM3000INSTALLSTATUS=1
  else 
    NM3000INSTALLSTATUS=0
  fi
  echo 'NM3000 INSTALL STATUS : ' + $NM3000INSTALLSTATUS 
  if [ $NM3000INSTALLSTATUS = 1 ]; then
    if(! whiptail --title "INSTALL NM3000" --yesno "nm3000 has already bean installed, are you sure to install nm3000 again ?" 10 60) then
      exit 0;
    fi
    # Flag REMOVE SERVICE STATUS
    NM3000REMOVESERVICE=1
  fi
else 
  if [ $LINUXRELEASE = 'Ubuntu' ]; then
    NM3000INSTALLSTATUS=`service nm3000 status 2>&1|grep unrecognized`
    echo $NM3000INSTALLSTATUS 
    if [ "$NM3000INSTALLSTATUS" =  "" ]; then
      if(! whiptail --title "INSTALL NM3000" --yesno "nm3000 has already bean installed, are you sure to install nm3000 again ?" 10 60) then
        exit 0;
      fi
      NM3000REMOVESERVICE=1
    fi
  elif [ $LINUXRELEASE = 'RedHat' ] || [ $LINUXRELEASE = 'CentOS' ]; then 
    NM3000INSTALLSTATUS=`chkconfig --list|grep nm3000`
    if [ "$NM3000INSTALLSTATUS" != "" ]; then
      if(! whiptail --title "INSTALL NM3000" --yesno "nm3000 has already bean installed, are you sure to install nm3000 again ?" 10 60) then
        exit 0;
      fi
      NM3000REMOVESERVICE=1
    fi
  fi
fi




# Input Install User
user_name=$(whiptail --title "NM3000 USER" --inputbox "What is NM3000 install user?" 10 60 nm3000 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  NM3000USER=$user_name
else
  exit 0;
fi

# Choose Language
language=$(whiptail --title "Please Choose Language" --menu "Choose Language" 15 60 4 \
"1" "Simple Chinese" \
"2" "English" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
   NM3000LANGUAGE=$language
else
  exit 0;
fi


# Create Dir And User
NM3000PATH="/home/"${NM3000USER}

NM3000GROUP=$NM3000USER

echo $NM3000PATH
echo $NM3000GROUP


# Stop NM3000 Server
if false; then
nm3000Server=$(ps -aux|grep jre/bin/java|grep topvision|grep -v grep)
if [ "$nm3000Server" != "" ]; then
  if(! whiptail --title "" --yesno "NM3000 Server is already running, install must stop current NM3000 Server" 10 60) then
    exit 0;
  fi
  if [ $systemdSupport = 'systemd_supported' ]; then
    systemctl stop nm3000_server
  else 
    service nm3000_server stop
  fi
fi
fi


# Stop Mysql Server
if false; then
mysqling=$(ps -aux|grep mysqld|grep -v grep)
if [ "$mysqling" != "" ]; then
   if(! whiptail --title "" --yesno "Mysql Server is already running, install must shutdown current Mysql Server" 10 60) then
      exit 0;
   fi
fi
fi

# Create Dir And User
USERREMOVE=0
USEREXISTS=$(cat /etc/passwd|grep -w "$NM3000USER")
echo $USEREXISTS
if [ ! -z $USEREXISTS ]; then
   if(! whiptail --title "" --yesno "$NM3000USER already exists, install must remove origin user" 10 60) then
      exit 0;
   fi
   USERREMOVE=1
fi

# Choose Server Or Database
while [ -z $INSTALLOPTION ]; do
SERVER_DATABASE=$(whiptail --title "INSTALL OPTION" --checklist "Choose Install Server Option" 15 60 4 \
"1" "NM3000 Server                             " ON \
"2" "Database Server                           " ON \
"3" "Engine Manage                      " OFF 3>&1 1>&2 2>&3) 
exitstatus=$?
if [ $exitstatus = 0 ]; then
   INSTALLOPTION=$SERVER_DATABASE
else 
  exit 0;
fi




INSTALLOPTION=`echo $INSTALLOPTION | tr -d " "`
 
if [ -z $INSTALLOPTION ]; then
   whiptail --title "Install Message" --msgbox "You mush choose one server to install. Choose Ok to retry" 10 60
fi
done

echo $INSTALLOPTION

# INSTALL NM3000 ENGINE MGR
INSTALLMGR=0
if [ ! -z `echo $INSTALLOPTION|grep 3` ]; then
   INSTALLMGR=1
fi

INSTALLTYPE=0

if [ $INSTALLOPTION = '"3"' ]; then
   INSTALLTYPE=3
fi


# INSTALL ONLY NM3000 SERVER
if [ ! -z `echo $INSTALLOPTION|grep 1|grep -v 2` ]; then
   INSTALLTYPE=1
   ipaddress=$(whiptail --title "Database IpAddress" --inputbox "Please Input Database Server IpAddress" 10 60 "127.0.0.1" 3>&1 1>&2 2>&3)
   exitstatus=$?
   if [ $exitstatus = 0 ]; then
      DATABASE_IPADDRESS=$ipaddress
   else
      exit 0;
   fi
fi

# INSTALL ONLY DATABASE SERVER
if [ ! -z `echo $INSTALLOPTION|grep 2|grep -v 1` ]; then
   INSTALLTYPE=2
fi

echo "INSTALLTYPE:"$INSTALLTYPE

# REMOVE NM3000 SERVICE
if [ $NM3000REMOVESERVICE = 1 ]; then
  if [ $systemdSupport = 'systemd_supported' ]; then
    # Stop Server
    systemctl stop nm3000_server 2>/dev/null
    systemctl stop nm3000_mysql 2>/dev/null
    systemctl stop nm3000_mgr 2>/dev/null
    # Remove Service
    systemctl disable nm3000 2>/dev/null
    systemctl disable nm3000_server 2>/dev/null
    systemctl disable nm3000_mysql 2>/dev/null
    systemctl disable nm3000_mgr 2>/dev/null
    # Delete Soft Link
    rm /usr/lib/systemd/system/nm3000.service
    rm /usr/lib/systemd/system/nm3000_server.service
    rm /usr/lib/systemd/system/nm3000_mysql.service
    rm /usr/lib/systemd/system/install.pwd
    rm /usr/lib/systemd/system/nm3000_mgr.service
  else 
    if [ $LINUXRELEASE = 'Ubuntu' ]; then
      # Stop Server
      service nm3000_server stop 2>/dev/null
      service nm3000_mysql stop 2>/dev/null
      service nm3000_mgr stop  2>/dev/null
      # Delete Soft Link
      rm /etc/init.d/nm3000
      rm /etc/init.d/nm3000_server 2>/dev/null
      rm /etc/init.d/nm3000_mysql  2>/dev/null
      rm /etc/init.d/nm3000_mgr    2>/dev/null
      # Remove Service
      update-rc.d nm3000 remove
      update-rc.d nm3000_server remove 2>/dev/null
      update-rc.d nm3000_mysql remove 2>/dev/null
      update-rc.d nm3000_mgr remove  2>/dev/null
    elif [ $LINUXRELEASE = 'RedHat' ] || [ $LINUXRELEASE = 'CentOS' ]; then
      # Stop Server
      service nm3000_server stop 2>/dev/null
      service nm3000_mysql stop 2>/dev/null
      service nm3000_mgr stop  2>/dev/null
      # Remove Service
      chkconfig --del nm3000
      chkconfig --del nm3000_server 2>/dev/null
      chkconfig --del nm3000_mysql 2>/dev/null
      chkconfig --del nm3000_mgr  2>/dev/null
      # Delete File
      rm /etc/init.d/nm3000
      rm /etc/init.d/nm3000_server 2>/dev/null
      rm /etc/init.d/nm3000_mysql 2>/dev/null
      rm /etc/init.d/nm3000_mgr  2>/dev/null
    fi
  fi
fi

# Stop Server And Mysql Process
sleep 10
serverProcess=$(ps -ef|grep jre/bin/java|grep topvision|grep -v grep|awk '{print $2}')
if [ "$serverProcess" != "" ]; then
  kill -9 $serverProcess
fi
mysqlProcess=$(ps -ef|grep mysqld|grep -v grep|awk '{print $2}')
if [ "$mysqlProcess" != "" ]; then
  kill -9 $mysqlProcess
fi
 


# Delete User
if [ $USERREMOVE = 1 ]; then
   rm -rf $NM3000PATH 
   userdel $NM3000USER
fi
if [ ! -d "$NM3000PATH" ]; then
   mkdir $NM3000PATH
fi
groupadd $NM3000GROUP 2>/dev/null
useradd $NM3000USER -g $NM3000GROUP -d $NM3000PATH


# Tar INSTALL Package
tar -xvf $TAR_FILE -C $NM3000PATH

# Change File Owner
chown -R $NM3000USER:$NM3000GROUP $NM3000PATH


# Edit Service Shell Path
cd $NM3000PATH/ems/
sed -i "s%nm3000Path%$NM3000PATH%g" nm3000_server.sh
sed -i "s%nm3000Path%$NM3000PATH%g" nm3000_mysql.sh
sed -i "s%nm3000Path%$NM3000PATH%g" nm3000_mgr.sh
sed -i "s%nm3000Path%$NM3000PATH%g" bin/engineCreator.sh
cd $NM3000PATH/ems/systemd
sed -i "s%nm3000Path%$NM3000PATH%g" nm3000_server.service
sed -i "s%nm3000Path%$NM3000PATH%g" nm3000_mysql.service
sed -i "s%NM3000USER%$NM3000USER%g" nm3000_mysql.service
sed -i "s%nm3000Path%$NM3000PATH%g" install.pwd
echo DONE

# Edit Local Language
cd $NM3000PATH/ems/webapp/WEB-INF/conf/
echo $1
if [ "$NM3000LANGUAGE" = "1" ];then
   echo Install EMS by Simple Chinese
   sed -i 's/en_US/zh_CN/g' config.properties
elif [ "$NM3000LANGUAGE" = "2" ];then
   sed -i 's/zh_CN/en_US/g' config.properties
else
   echo Install EMS by English
fi

# Edit Database Server Config
if [ $INSTALLTYPE = 1 ]; then
   sed -i "s/localhost/$DATABASE_IPADDRESS/g" jdbc.properties
fi 

# Edit Memory
cd $NM3000PATH/ems/bin
if [ $INSTALLTYPE = 0 ] || [ $INSTALLTYPE = 1 ]; then
   if [ $MEMORYTYPE = 1 ]; then
      sed -i "s/-Xms2G -Xmx6G/-Xms2G -Xmx4G/g" nm3000Start.sh
   elif [ $MEMORYTYPE = 2 ]; then
      sed -i "s/-Xms2G -Xmx6G/-Xms5G -Xmx10G/g" nm3000Start.sh
   elif [ $MEMORYTYPE = 3 ]; then
      sed -i "s/-Xms2G -Xmx6G/-Xms12G -Xmx24G/g" nm3000Start.sh
   elif [ $MEMORYTYPE = 4 ]; then
      sed -i "s/-Xms2G -Xmx6G/-Xms20G -Xmx40G/g" nm3000Start.sh
   fi
fi

cd $NM3000PATH/ems/mysql
if [ $INSTALLTYPE = 0 ]; then
   if [ $MEMORYTYPE = 1 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 2G/g" my.cnf
   elif [ $MEMORYTYPE = 2 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 4G/g" my.cnf
   elif [ $MEMORYTYPE = 3 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 6G/g" my.cnf
   elif [ $MEMORYTYPE = 4 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 20G/g" my.cnf
   fi
elif [ $INSTALLTYPE = 2 ]; then
   if [ $MEMORYTYPE = 1 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 4G/g" my.cnf
   elif [ $MEMORYTYPE = 2 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 10G/g" my.cnf
   elif [ $MEMORYTYPE = 3 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 24G/g" my.cnf
   elif [ $MEMORYTYPE = 4 ]; then
      sed -i "s/innodb_buffer_pool_size = 256M/innodb_buffer_pool_size = 40G/g" my.cnf
   fi
fi

# Copy diskspace
if [ -f /etc/redhat-release ]; then
  linux_release_redhat=$(cat /etc/redhat-release|awk '{print $1$2}'|grep 'RedHat')
  linux_release_centos=$(cat /etc/redhat-release|awk '{print $1}'|grep CentOS)
  if [ ! -z $linux_release_redhat ]; then
    cp $NM3000PATH/ems/systemd/diskspace_centos $NM3000PATH/ems/bin/diskspace
    chmod +x $NM3000PATH/ems/bin/diskspace
  fi
  echo $linux_release_centos
  if [ ! -z $linux_release_centos ]; then
    cp $NM3000PATH/ems/systemd/diskspace_centos $NM3000PATH/ems/bin/diskspace
    chmod +x $NM3000PATH/ems/bin/diskspace
  fi
else
  linux_release_ubuntu=$(cat /etc/issue|sed -n '1p'|awk '{print $1}'|grep Ubuntu)
  if [ ! -z $linux_release_ubuntu ]; then
    cp $NM3000PATH/ems/systemd/diskspace_ubuntu $NM3000PATH/ems/bin/diskspace
    chmod +x $NM3000PATH/ems/bin/diskspace
  fi
fi
echo $NM3000PATH > $NM3000PATH/ems/bin/path.txt


# Change User Start Server
cd $NM3000PATH/ems/mysql/bin/
sed -i "s/--user=ems/--user=$NM3000USER/g" startMysql.sh


# INSTALL NM3000 AS LINUX SERVICE
if [ $systemdSupport = 'systemd_supported' ]; then
  mkdir -p /usr/lib/systemd/system/
  mv $NM3000PATH/ems/systemd/*.service /usr/lib/systemd/system/
  mv $NM3000PATH/ems/systemd/install.pwd /usr/lib/systemd/system/
  if [ ! $INSTALLTYPE = 3 ]; then
    # NM3000 MYSQL AS SERVICE
    if [ ! $INSTALLTYPE = 1 ]; then
      systemctl enable nm3000_mysql 
    fi
    # NM3000 SERVER AS SERVICE
    if [ ! $INSTALLTYPE = 2 ]; then
      systemctl enable nm3000_server 
    fi
  fi
  # NM3000 MGR AS SERVICE
  if [ $INSTALLMGR = 1 ]; then
    systemctl enable nm3000_mgr 
  fi
  systemctl enable nm3000 
else 
  if [ $LINUXRELEASE = 'Ubuntu' ]; then
    cd $NM3000PATH/ems
    if [ ! $INSTALLTYPE = 3 ]; then
      # NM3000 MYSQL AS SERVICE
      if [ ! $INSTALLTYPE = 1 ]; then
         ln -s $NM3000PATH/ems/nm3000_mysql.sh /etc/init.d/nm3000_mysql
         update-rc.d nm3000_mysql defaults 
      fi
      # NM3000 SERVER AS SERVICE
      if [ ! $INSTALLTYPE = 2 ]; then
         ln -s $NM3000PATH/ems/nm3000_server.sh /etc/init.d/nm3000_server
         update-rc.d nm3000_server defaults
      fi
    fi
    # NM3000 MGR AS SERVICE
    if [ $INSTALLMGR = 1 ]; then
      ln -s $NM3000PATH/ems/nm3000_mgr.sh /etc/init.d/nm3000_mgr
      update-rc.d nm3000_mgr defaults
    fi
    # NM3000 AS SERVICE
    ln -s $NM3000PATH/ems/nm3000.sh /etc/init.d/nm3000
    update-rc.d nm3000 defaults
  elif [ $LINUXRELEASE = 'RedHat' ] || [ $LINUXRELEASE = 'CentOS' ]; then
    cd $NM3000PATH/ems
    if [ ! $INSTALLTYPE = 3 ]; then
      # NM3000 MYSQL AS SERVICE
      if [ ! $INSTALLTYPE = 1 ]; then
         # cp $NM3000PATH/ems/nm3000_mysql.sh /etc/init.d/nm3000_mysql
         ln -s $NM3000PATH/ems/nm3000_mysql.sh /etc/init.d/nm3000_mysql
         chkconfig --add nm3000_mysql
         chkconfig nm3000_mysql on
      fi
      # NM3000 SERVER AS SERVICE
      if [ ! $INSTALLTYPE = 2 ]; then
         # cp $NM3000PATH/ems/nm3000_server.sh /etc/init.d/nm3000_server
         ln -s $NM3000PATH/ems/nm3000_server.sh /etc/init.d/nm3000_server
         chkconfig --add nm3000_server
         chkconfig nm3000_server on
      fi
    fi
    # NM3000 MGR AS SERVICE
    if [ $INSTALLMGR = 1 ]; then
      # cp $NM3000PATH/ems/nm3000_mgr.sh /etc/init.d/nm3000_mgr
      ln -s $NM3000PATH/ems/nm3000_mgr.sh /etc/init.d/nm3000_mgr
      chkconfig --add nm3000_mgr
      chkconfig nm3000_mgr on
    fi
    ln -s $NM3000PATH/ems/nm3000.sh /etc/init.d/nm3000
    chkconfig --add nm3000
  fi
fi

# Engine Dir Creator
sh $NM3000PATH/ems/bin/engineCreator.sh



USEROPENFILE=$(ulimit -a|grep -w 'open files'|grep -w 65535)
if [ -z "$USEROPENFILE" ]; then
   echo -e 'root soft nofile 65535\nroot hard nofile 65535' >> /etc/security/limits.conf
fi


REBOOT_SWITCH=$(whiptail --title "Reboot System" --menu "You must reboot the system after install, Do you want to reboot now ?" 15 60 4 \
"1" "YES" \
"2" "NO" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
   REBOOTSWITCH=$REBOOT_SWITCH
else
  exit 0;
fi

# Reboot System
if [ $REBOOTSWITCH = 1 ]; then
  reboot
else 
  if [ $systemdSupport = 'systemd_supported' ]; then
    systemctl start nm3000_mysql
    sleep 10
    systemctl start nm3000_server
  else
    service nm3000_mysql start
    sleep 10
    service nm3000_server start
  fi
fi

