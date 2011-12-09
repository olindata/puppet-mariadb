class mariadb::backup::generic {
  file {$mariadb::params::backup_dir:
    ensure   => "directory",
    owner  => root,
    group   => root,
  }

  file {"${mariadb::params::backup_dir}/scripts":
    ensure  => "directory",
    owner  => root,
    group  => root,
    require  => File[$mariadb::params::backup_dir]
  }
  
}