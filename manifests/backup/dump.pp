class mariadb::backup::dump {
  include mariadb::backup::generic
  
  file {"${::mysql-backup-dir}/mysqldumps":
    ensure   => "directory",
    owner  => root,
    group   => root,
    require  => File["${::mysql-backup-dir}"]
  }

  file {"/etc/mysql_backup.conf":
    ensure  => "present",
    content   =>  template("mariadb/mysql_backup.conf.erb"),
    owner  => root,
    group   => root,
    mode  => 500,
    require => [
          File["${::mysql-backup-dir}/scripts"], 
          File["${::mysql-backup-dir}/mysqldumps"], 
          Package["mariadb-server"]
          ]
  }

  file {"${::mysql-backup-dir}/scripts/mysql-dump-backup.sh":
    ensure  => "present",
    content   =>  template("mariadb/mysql-dump-backup.sh.erb"),
    owner  => root,
    group   => root,
    mode  => 500,
    require => [
          File["${::mysql-backup-dir}/scripts"], 
          File["${::mysql-backup-dir}/mysqldumps"], 
          Package["mariadb-client"]
          ]
  }

     file {"${::mysql-backup-dir}/scripts/mysql-dump-bkup-rotate.sh":
                ensure  => "present",
                content =>  template("mariadb/mysql-dump-bkup-rotate.sh.erb"),
                owner   => root,
                group   => root,
                mode    => 500, 
                require => [
                                        File["${::mysql-backup-dir}/scripts/mysql-dump-backup.sh"]
                                        ]       
        }       


  cron { "mysql-sqldump-backup":
    command => "${::mysql-backup-dir}/scripts/mysql-dump-backup.sh",
    user => root,
    hour => 04,
    minute  => 17
  }
  
}
