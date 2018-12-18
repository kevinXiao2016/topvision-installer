#!/bin/bash

# Program:
#   NM3000 Server Auto Update SHell
# Histroy: 2015-9-10 Rod Johnson First release

# Check User Authority
if [ `id -u` -ne 0 ];then
echo "INSTALL ERROR: You must use root to update NM3000"
exit 0
fi

command -v systemctl > /dev/null
if [ $? == 0 ]; then
  systemdSupport='systemd_supported'
else
  systemdSupport='systemd_no_supported'
fi
echo $systemdSupport

# Check Linux Release
LINUXRELEASE=''
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

echo $LINUXRELEASE


# Install Service Status
if [ $LINUXRELEASE = 'Ubuntu' ]; then
   NM3000INSTALLSTATUS=`service nm3000_server status 2>&1|grep unrecognized`
   if [ "$NM3000INSTALLSTATUS" !=  "" ]; then
      echo "UPDATE ERROR: NM3000 Server has not been installed before"
      exit 0;
   fi
elif [ $LINUXRELEASE = 'RedHat' ] || [ $LINUXRELEASE = 'CentOS' ]; then
   NM3000INSTALLSTATUS=`chkconfig --list|grep nm3000_server`
   NM3000INSTALLPATH=$(ls -al /etc/init.d/nm3000_server|awk -F "->" '{print $2}'|awk -F "/" '{print "/"$2"/"$3"/"$4}')
   if [ "$NM3000INSTALLSTATUS" = "" ] &&  [ "$NM3000INSTALLPATH" = "" ]; then
      echo "UPDATE ERROR: NM3000 Server has not bean installed before"
      exit 0;
   fi
fi


service nm3000_server stop

# Stop Server Process
sleep 10
serverProcess=$(ps -ef|grep jre/bin/java|grep topvision|grep -v grep|awk '{print $2}')
if [ "$serverProcess" != "" ]; then
  kill -9 $serverProcess
fi

# Find Install Path
if [ $systemdSupport = 'systemd_supported' ]; then
  NM3000INSTALLPATH=`cat /usr/lib/systemd/system/install.pwd`
else
  NM3000INSTALLPATH=$(ls -al /etc/init.d/nm3000_server|awk -F "->" '{print $2}'|awk -F "/" '{print "/"$2"/"$3"/"$4}')
fi


# BackUp
BACKUP_SWITCH=$(whiptail --title "BackUp" --menu "Do you want to backup current NM3000 file ?" 15 60 2 \
"1" "YES" \
"2" "NO" 3>&1 1>&2 2>&3)
backupstatus=$?
if [ $backupstatus != 0 ]; then
   exit 0;
fi

if [ $BACKUP_SWITCH = 1 ]; then
   if [ -e $NM3000INSTALLPATH/backup ]; then
      echo 'rm backup'
      rm -rf $NM3000INSTALLPATH/backup
   fi
   mkdir $NM3000INSTALLPATH/backup   
   cp -r -f $NM3000INSTALLPATH/webapp $NM3000INSTALLPATH/backup/
   cp -r -f $NM3000INSTALLPATH/lib    $NM3000INSTALLPATH/backup/
   cp -r -f $NM3000INSTALLPATH/bin    $NM3000INSTALLPATH/backup/
   cp -r -f $NM3000INSTALLPATH/jre    $NM3000INSTALLPATH/backup/ 

fi



# Tar Update File
USERUPDATEPATH=$(pwd)
tar -xvf update
cd ems
mkdir backup
mkdir backup/conf
mkdir backup/lib
mkdir backup/META-INF

# CP restore.sh
cp bin/restore.sh $NM3000INSTALLPATH/backup/ 


# Path To EMS
cd $NM3000INSTALLPATH
echo $NM3000INSTALLPATH
 

# Backup File
cp -f webapp/WEB-INF/conf/*  $USERUPDATEPATH/ems/backup/conf/

#modify by Victor@20160526 update all lib
#cp -f webapp/WEB-INF/lib/* $USERUPDATEPATH/ems/backup/lib/
cp -r -f webapp/META-INF/*  $USERUPDATEPATH/ems/backup/META-INF/
#rm $USERUPDATEPATH/ems/backup/lib/topvision-*.jar
#rm $USERUPDATEPATH/ems/backup/lib/report-*.jar
#rm $USERUPDATEPATH/ems/backup/lib/license-parser-*.jar


# Copy Lib File
#rm lib/license-parser-*.jar
#rm lib/com.topvision.launcher_*.jar

# Copy lib File
rm -rf lib
cp -rf $USERUPDATEPATH/ems/lib ./

# Copy bin File
rm -rf bin
cp -rf $USERUPDATEPATH/ems/bin ./

# Copy diskspace File
rm -rf systemd/diskspace_*
cp -rf $USERUPDATEPATH/ems/systemd/diskspace_* ./systemd/

# Copy Webapp File
rm -rf webapp
cp -r $USERUPDATEPATH/ems/webapp ./

# Copy Backup Conf
cp -f $USERUPDATEPATH/ems/backup/conf/*  ./webapp/WEB-INF/conf/

# Copy Backup Lib
#cp -f $USERUPDATEPATH/ems/backup/lib/*  ./webapp/WEB-INF/lib/

# Copy META-INF File
cp -r -f $USERUPDATEPATH/ems/backup/META-INF/* ./webapp/META-INF/
cp -r -f $USERUPDATEPATH/ems/webapp/META-INF/* ./webapp/META-INF/

# Copy New Conf
awk -v cmd="cp -i $USERUPDATEPATH/ems/webapp/WEB-INF/conf/*  ./webapp/WEB-INF/conf/" 'BEGIN { print "n" |cmd; }'

# Copy diskspace
if [ -f /etc/redhat-release ]; then
  linux_release_redhat=$(cat /etc/redhat-release|awk '{print $1$2}'|grep 'RedHat')
  linux_release_centos=$(cat /etc/redhat-release|awk '{print $1}'|grep CentOS)
  if [ ! -z $linux_release_redhat ]; then
    cp $NM3000INSTALLPATH/systemd/diskspace_centos $NM3000INSTALLPATH/bin/diskspace
    chmod +x $NM3000INSTALLPATH/bin/diskspace
  fi
  echo $linux_release_centos
  if [ ! -z $linux_release_centos ]; then
    cp $NM3000INSTALLPATH/systemd/diskspace_centos $NM3000INSTALLPATH/bin/diskspace
    chmod +x $NM3000INSTALLPATH/bin/diskspace
  fi
else
  linux_release_ubuntu=$(cat /etc/issue|sed -n '1p'|awk '{print $1}'|grep Ubuntu)
  if [ ! -z $linux_release_ubuntu ]; then
    cp $NM3000INSTALLPATH/systemd/diskspace_ubuntu $NM3000INSTALLPATH/bin/diskspace
    chmod +x $NM3000INSTALLPATH/bin/diskspace
  fi
fi
echo $NM3000INSTALLPATH > $NM3000INSTALLPATH/bin/path.txt

# Engine Dir Creator
sed -i "s%nm3000Path%${NM3000INSTALLPATH%/*}%g" ./bin/engineCreator.sh
sh ./bin/engineCreator.sh


# Add by Victor@20160526 Update jre to 1.8.0
rm -rf jre
cp -rf $USERUPDATEPATH/ems/jre ./
# Add by Victor@20160827 Update to delete file
rm -rf ./webapp/WEB-INF/conf/config_en.properties

# Remove Update File
rm -rf $USERUPDATEPATH/ems

# Choose Start Switch
START_SWITCH=$(whiptail --title "Start Server" --menu "Update NM3000 Success, Do you want to start server now ?" 15 60 2 \
"1" "YES" \
"2" "NO" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
   exit 0;
fi

if [ $START_SWITCH = 1 ]; then
  service nm3000_server start
fi

echo NM3000 UPDATE FINISH
