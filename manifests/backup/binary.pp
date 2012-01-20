class mariadb::backup::binary {
  
  require mariadb::params
  
  include mariadb::backup::generic

  include xtrabackup

  file {"${mariadb::params::backup_dir}/scripts/mysql-binary-backup.sh":
    ensure  => "present",
    content => template("mariadb/mysql-binary-backup.sh.erb"),
    owner   => root,
    group   => root,
    mode    => 500,
    require => [
      File["${mariadb::params::backup_dir}/scripts"], 
      Package["mariadb-client"]
    ]
  }

  file {"${mariadb::params::backup_dir}/scripts/mysql-bin-bkup-rotate.sh":
    ensure  => "present",
    content => template("mariadb/mysql-bin-bkup-rotate.sh.erb"),
    owner   => root,
    group   => root,
    mode    => 500,
    require => [
      File["${mariadb::params::backup_dir}/scripts/mysql-binary-backup.sh"]
    ]
  }

  cron { "mysql-binary-backup":
    command => "${mariadb::params::backup_dir}/scripts/mysql-binary-backup.sh",
    user    => root,
    hour    => 02,
    minute  => 17
  }

}