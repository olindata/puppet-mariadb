class mariadb::backup::binary {
  include mariadb::backup::generic
  include xtrabackup

  file {"${::mysql-backup-dir}/scripts/mysql-binary-backup.sh":
    ensure  => "present",
    content   =>  template("mariadb/mysql-binary-backup.sh.erb"),
    owner  => root,
    group   => root,
    mode  => 500,
    require => [
          File["${::mysql-backup-dir}/scripts"], 
          Package["mariadb-server"]
          ]
  }

  file {"${::mysql-backup-dir}/scripts/mysql-bin-bkup-rotate.sh":
    ensure  => "present",
    content   =>  template("mariadb/mysql-bin-bkup-rotate.sh.erb"),
    owner  => root,
    group   => root,
    mode  => 500,
    require => [
          File["${::mysql-backup-dir}/scripts/mysql-binary-backup.sh"]
          ]
  }

  cron { "mysql-binary-backup":
    command => "${::mysql-backup-dir}/scripts/mysql-binary-backup.sh",
    user => root,
    hour => 02,
    minute  => 17
  }

}