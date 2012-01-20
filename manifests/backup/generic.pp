class mariadb::backup::generic {
  
  require mariadb::params
  
  file {"/etc/mysql_backup.conf":
    ensure  => "present",
    content => template("mariadb/mysql_backup.conf.erb"),
    owner   => root,
    group   => root,
    mode    => 500,
    require => [
      File["${mariadb::params::backup_dir}/scripts"], 
      Package["mariadb-client"]
    ]
  }

  file {$mariadb::params::backup_dir:
    ensure => "directory",
    owner  => root,
    group  => root,
  }

  file {"${mariadb::params::backup_dir}/scripts":
    ensure  => "directory",
    owner   => root,
    group   => root,
    require => File[$mariadb::params::backup_dir]
  }

  mariadb::user{ 'backup':
    username      => $mariadb::params::backup_user, 
    pw            => $mariadb::params::backup_pass,
    dbname        => '*', 
    grants        => 'SELECT, RELOAD, SUPER, LOCK TABLES, REPLICATION CLIENT', 
    host_to_grant => 'localhost', 
    dbhost        => 'localhost', 
    withgrants    => false
  }

}