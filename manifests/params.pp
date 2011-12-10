# Class: mariadb::params
#
# Sets internal variables and defaults for mariadb module
# This class is automatically loaded in all the classes that use the values set here 
#
class mariadb::params  {

## DEFAULTS FOR VARIABLES USERS CAN SET
# (Here are set the defaults, provide your custom variables externally)
# (The default used is in the line with '')

  ## The credentials to a mysql user that will be able to create other users, databases and grants
  $admin_user = $::mariadb_admin_user ? {
    ''      => "root",
    default => "${::mariadb_admin_user}",
  }
  
  ## The credentials to a mysql user that will be able to create other users, databases and grants
  $admin_pass = $::mariadb_admin_pass ? {
    ''      => "root",
    default => "${::mariadb_admin_pass}",
  }

  ## The preferred root password
  $root_password = $::mariadb_root_password ? {
    ''      => "root",
    default => "${::mariadb_root_password}",
  }

  ## The preferred password for the debian-sys-maint user
  $debian_sys_maint_pass = $::mariadb_debian_sys_maint_pass ? {
    ''      => "5W2Ep2EATF7-x_Vq",
    default => "${::mariadb_debian_sys_maint_pass}",
  }


  ## The userid/groupid of the mysql user/group
  $user_gid = $::mariadb_user_gid ? {
    ''      => 107,
    default => "${::mariadb_user_gid}",
  }


  ## The data directory for mysql
  $data_dir = $::mariadb_data_dir ? {
    ''      => "/var/lib/mysql",
    default => "${::mariadb_data_dir}",
  }

  ## The main config file for mysql
  $my_cnf_source = $::mariadb_my_cnf_source ? {
    ''      => ["puppet:///mariadb/my.cnf.${::hostname}","puppet:///mariadb/my.cnf"],
    default => [$::mariadb_my_cnf_source,"puppet:///mariadb/my.cnf.${::hostname}","puppet:///mariadb/my.cnf"],
  }

  ## The directory where mysql log files are stored
  $log_dir = $::mariadb_log_dir ? {
    ''      => "/var/log/mysql",
    default => "${::mariadb_log_dir}",
  }

  ## The directory where mysql backups are stored
  $backup_dir = $::mariadb_backup_dir ? {
    ''      => "/backup/mysql",
    default => "${::mariadb_backup_dir}",
  }

  ## the ip of the host the mysqldump backup is to be taken from
  $backup_host_ip = $::mariadb_backup_host_ip ? {
    ''      => "127.0.0.1",
    default => "${::mariadb_backup_host_ip}",
  }
 
  ## The ip address to an sftp server that remote backups are stored on
  $backup_remote_ip = $::mariadb_backup_remote_ip ? {
    ''      => "",
    default => "${::mariadb_backup_remote_ip}",
  }

  ## The credentials to a mysql user that will do mysqldump backups
  $backup_user = $::mariadb_backup_user ? {
    ''      => "root",
    default => "${::mariadb_backup_user}",
  }

#$::mysql-backup-pass  => The credentials to a mysql user that will do mysqldump backups    
  ## The credentials to a mysql user that will be able to create other users, databases and grants
  $backup_pass = $::mariadb_backup_pass ? {
    ''      => "root",
    default => "${::mariadb_backup_pass}",
  }

## EXTRA MODULE INTERNAL VARIABLES
#(add here module specific internal variables)

# Location of postfix admin configuration file. Used in postfix::postfixadmin
    $mariadbconf = $::operatingsystem ? {
        debian  => "/etc/mysql/my.cnf",
        ubuntu  => "/etc/mysql/my.cnf",
        default => "/etc/mysql/my.cnf",
    }

## MODULE INTERNAL VARIABLES
# (Modify to adapt to unsupported OSes)

    $packagename_server = $::operatingsystem ? {
        default => "mariadb-server",
    }
    $packagename_client = $::operatingsystem ? {
        default => "mariadb-client",
    }

    $servicename = $::operatingsystem ? {
        default => "mysql",
    }

    $processname = $::operatingsystem ? {
        default => "mysqld",
    }
}