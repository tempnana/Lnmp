#!/usr/bin/env bash
#01 00 * * * bash /home/backup/backup.sh
#Funciont: Backup website and mysql database
#Author: licess
#Website: https://lnmp.org
#IMPORTANT!!!Please Setting the following Values!
## chang ftp to sftp

cd "$(dirname "$0")"
Backup_Home="/home/backup/"
MySQL_Dump="/usr/local/mysql/bin/mysqldump"
######~Set Directory you want to backup~######
Backup_Dir=("/home/wwwroot/vpser.net" "/home/wwwroot/lnmp.org")

######~Set MySQL Database you want to backup~######
Backup_Database=("lnmp" "vpser")

######~Set MySQL UserName and password~######
MYSQL_UserName='root'
MYSQL_PassWord='yourrootpassword'

######~Enable Ftp Backup~######
Enable_FTP=0
# 0: enable; 1: disable
######~Set FTP Information~######
FTP_Host='1.2.3.4'
FTP_Username='vpser.net'
#FTP_Password='yourftppassword'
FTP_Dir="backup"

#Values Setting END!

TodayWWWBackup=www-*-$(date +"%Y%m%d").tar.gz
#TodayDBBackup=db-*-$(date +"%Y%m%d").sql
TodayDBBackup=db-*-$(date +"%Y%m%d").sql.gz
OldWWWBackup=www-*-$(date -d -3day +"%Y%m%d").tar.gz
OldDBBackup=db-*-$(date -d -3day +"%Y%m%d").sql.gz

Backup_Dir()
{
    Backup_Path=$1
    Dir_Name=`echo ${Backup_Path##*/}`
    Pre_Dir=`echo ${Backup_Path}|sed 's/'${Dir_Name}'//g'`
    tar zcf ${Backup_Home}www-${Dir_Name}-$(date +"%Y%m%d").tar.gz -C ${Pre_Dir} ${Dir_Name}
}
Backup_Sql()
{
    # ${MySQL_Dump} -u$MYSQL_UserName -p$MYSQL_PassWord $1 > ${Backup_Home}db-$1-$(date +"%Y%m%d").sql
    ${MySQL_Dump} -u$MYSQL_UserName -p$MYSQL_PassWord $1 | gzip > ${Backup_Home}db-$1-$(date +"%Y%m%d").sql.gz
}

if [ ! -f ${MySQL_Dump} ]; then  
    echo "mysqldump command not found.please check your setting."
    exit 1
fi

if [ ! -d ${Backup_Home} ]; then  
    mkdir -p ${Backup_Home}
fi

#if [ ${Enable_FTP} = 0 ]; then
 #   type lftp >/dev/null 2>&1 || { echo >&2 "lftp command not found. Install: centos:yum install lftp,debian/ubuntu:apt-get install lftp."; }
#fi

echo "Backup website files..."
for dd in ${Backup_Dir[@]};do
    echo "Backup website : ${dd} ..."
    Backup_Dir ${dd}
done

echo "Backup Databases..."
for db in ${Backup_Database[@]};do
    echo "Backup Databases : ${db} ..."
    Backup_Sql ${db}
done

echo "Delete old backup files..."
rm -f ${Backup_Home}${OldWWWBackup}
rm -f ${Backup_Home}${OldDBBackup}

if [ ${Enable_FTP} = 0 ]; then
    echo "Uploading backup files to ftp..."
    cd ${Backup_Home}
    sftp ${FTP_Username}@${FTP_Host} << EOF
cd ${FTP_Dir}
rm ${OldWWWBackup}
rm ${OldDBBackup}
put ${TodayWWWBackup}
put ${TodayDBBackup}
bye
EOF

echo "complete."
fi
