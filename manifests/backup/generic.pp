class mariadb::backup::generic {
  file {$::mysql-backup-dir:
    ensure   => "directory",
    owner  => root,
    group   => root,
  }

  file {"${::mysql-backup-dir}/scripts":
    ensure  => "directory",
    owner  => root,
    group  => root,
    require  => File[$::mysql-backup-dir]
  }
  
}