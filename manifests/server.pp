class mariadb::server inherits mariadb::client {

  # make sure the proper 5.1 packages are installed
  package { "mariadb-server":  
    ensure => "installed" 
  }

  # make sure the mysql user and group exist
  group { "mysql": 
    ensure    => "present",
    gid      => 111,
    require    => Package["mariadb-server"],
  }

  # data directory at /mysql/data, so
  # make sure that those directories exist
  file { ["/var/lib/mysql", "/var/log/mysql", "/var/run/mysqld"]: 
    ensure     => "directory",
    owner    => "mysql",
    group     => "mysql" 
  }

  # make sure that /etc/my.cnf exists.
  # this only ensure that the file exists and has the correct 
  # permissions.  If you want to supply a custom source, you may override
  # this in a subclass.
  file { "/etc/mysql/my.cnf":  
    require   =>  Package["mariadb-server"], 
    source     =>  ["puppet:///mariadb/my.cnf.${::hostname}",
             "puppet:///mariadb/my.cnf"]
  }
  file { "/etc/mysql/common.cnf":  
    require   =>  Package["mariadb-server"], 
    source     =>  ["puppet:///mariadb/common.cnf"]
  }

  file { "/etc/mysql/binlog.cnf":  
    require   =>  Package["mariadb-server"], 
    source     =>  ["puppet:///mariadb/binlog.cnf"]
  }

  file { "/etc/mysql/debian.cnf":  
    require   =>  Package["mariadb-server"], 
    content     =>  template("mariadb/debian.cnf"),
                owner           => root,
                group           => root,
                mode            => 600
  }

  user { "mysql": 
    ensure    => "present",
    uid      => 111,
    gid      => 111,
    comment    => "MariaDB Server",
    home    => "/var/lib/mysql",
    shell    => "/bin/bash",
    require    => [
            Package["mariadb-server"], 
            Group["mysql"]
            ],
  }

  # make sure that mysqld is running
  service { "mysql":
    enable    => true,
    ensure    => "running",
    #ensure      => "stopped",
    hasrestart  => true,
    hasstatus  => true,
    require    => [
            File["/etc/mysql/my.cnf"], 
            File["/var/lib/mysql"], 
            Package["mariadb-server"] 
            ],
  }

  # set mysql root password
  exec { "Set MySQL server root password":
    subscribe   => Package["mariadb-server"],
    refreshonly => true,
    unless      => "/usr/bin/mysqladmin -uroot -p${::mysql_root_password} status",
    command     => "/usr/bin/mysqladmin -uroot password ${::mysql_root_password}",
  }

  file { "/etc/mysql/conf.d/skip-name-resolv.cnf":
    content => "[mysqld]\n skip-name-resolve\n",
    notify  => Service["mysql"],
    require => Package["mariadb-server"],
  }

  # file {"/backup":
  #   ensure   => "directory",
  #   owner  => root,
  #   group   => root,
  # }
  # 
  # file {"/backup/mysql":
  #   ensure   => "directory",
  #   owner  => root,
  #   group   => root,
  #   require  => File["/backup"]
  # }
  # 
  # file {"/backup/mysql/scripts":
  #   ensure  => "directory",
  #   owner  => root,
  #   group  => root,
  #   require  => File["/backup/mysql"]
  # }
  # 
  # file {"/backup/mysql/scripts/mysql-dump-backup.sh":
  #   ensure  => "present",
  #   source   =>  "puppet:///mariadb/mysql-dump-backup.sh",
  #   owner  => root,
  #   group   => root,
  #   mode  => 500,
  #   require => [
  #         File["/backup/mysql/scripts"], 
  #         Package["mariadb-server"]
  #         ]
  # }
  # 
  # file {"/backup/mysql/scripts/mysql-binary-backup.sh":
  #   ensure  => "present",
  #   source   =>  "puppet:///mariadb/mysql-binary-backup.sh",
  #   owner  => root,
  #   group   => root,
  #   mode  => 500,
  #   require => [
  #         File["/backup/mysql/scripts"], 
  #         Package["mariadb-server"]
  #         ]
  # }
  # 
  # file {"/backup/mysql/scripts/mysql-bin-bkup-rotate.sh":
  #   ensure  => "present",
  #   source   =>  "puppet:///mariadb/mysql-bin-bkup-rotate.sh",
  #   owner  => root,
  #   group   => root,
  #   mode  => 500,
  #   require => [
  #         File["/backup/mysql/scripts/mysql-binary-backup.sh"]
  #         ]
  # }

  # if $fqdn == "xxx.com" {
  #   cron { "mysql-binary-backup":
  #     command => "/backup/mysql/scripts/mysql-binary-backup.sh",
  #     user => root,
  #     hour => 02,
  #     minute  => 17
  #   }
  # }

  # For Mysql Monitoring and Health Stuff

        file { "/opt/tribily/bin/mysql_repl_status.pl":
                ensure  => present,
              #  require => [File["/opt/tribily/bin"], Package["libdbd-mysql-perl"], Package["libdbi-perl"]],
                require => [File["/opt/tribily/bin"]],
                source  => "puppet:///mariadb/mysql_repl_status.pl",
                owner   => "root", 
                group   => "root", 
                mode    => "0655",        
        }       


}
