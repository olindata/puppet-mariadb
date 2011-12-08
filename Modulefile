name 'tribily-mariadb'
version '1.0'

author 'Walter Heck'
license 'GPLv2'
project_page ''
source ''
summary 'This module manages mariadb'
description 'Only works for debian for now, feel free to contribute other operating systems.

Requires some top-level variables to work for now:


$::mysql_admin_user	=> The credentials to a mysql user that will be able to create other users, databases and grants
$::mysql_admin_pass	=> The credentials to a mysql user that will be able to create other users, databases and grants

$::mysql_root_password => The preferred root password

$::debian-sys-maint-pass => The preferred password for the debian-sys-maint user

$::mysql-gid			=> The userid/groupid of the mysql user/group

$::mysql-data-dir		=> The data directory for mysql
$::mysql-log-dir		=> The directory where mysql log files are stored
$::mysql-backup-dir		=> The directory where mysql backups are stored

$::mysql-backup-host-to-backup => the ip of the host the mysqldump backup is to be taken from
$::mysql-backup-sftp-ip	=> The ip address to an sftp server that remote backups are stored on
$::mysql-backup-user	=> The credentials to a mysql user that will do mysqldump backups
$::mysql-backup-pass	=> The credentials to a mysql user that will do mysqldump backups'
dependency 'tribily/xtrabackup', '>=1.0'
