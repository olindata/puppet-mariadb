class mariadb::backup::dump {
  
  require mariadb::params
  
  include mariadb::backup::generic
  
  file {"${mariadb::params::backup_dir}/mysqldumps":
    ensure  => "directory",
    owner   => root,
    group   => root,
    require => File["${mariadb::params::backup_dir}"]
  }

  file {"${mariadb::params::backup_dir}/scripts/mysql-dump-backup.sh":
    ensure  => "present",
    content => template("mariadb/mysql-dump-backup.sh.erb"),
    owner   => root,
    group   => root,
    mode    => 500,
    require => [
      File["${mariadb::params::backup_dir}/scripts"], 
      File["${mariadb::params::backup_dir}/mysqldumps"], 
      Package["mariadb-client"]
    ]
  }

  file {"${mariadb::params::backup_dir}/scripts/mysql-dump-bkup-rotate.sh":
    ensure  => "present",
    content => template("mariadb/mysql-dump-bkup-rotate.sh.erb"),
    owner   => root,
    group   => root,
    mode    => 500, 
    require => File[$mariadb::params::backup_dir]
  }       

  cron { "mysql-sqldump-backup":
    command => "${mariadb::params::backup_dir}/scripts/mysql-dump-backup.sh",
    user    => root,
    hour    => 04,
    minute  => 17,
    require => File["${mariadb::params::backup_dir}/scripts/mysql-dump-backup.sh"]
  }
  
}
