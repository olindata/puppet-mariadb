class mariadb::server inherits mariadb::client {

  # make sure the proper 5.1 packages are installed
  package { "mariadb-server":  
    ensure => "present" 
  }

  # make sure the mysql user and group exist
  group { "mysql": 
    ensure    => "present",
    gid      => $::mysql-gid,
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
    content     =>  template("mariadb/debian.cnf.erb"),
                owner           => root,
                group           => root,
                mode            => 600
  }

  user { "mysql": 
    ensure    => "present",
    uid      => $::mysql-gid,
    gid      => $::mysql-gid,
    comment    => "MariaDB Server",
    home    => $::mysql-data-dir,
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
            File[$::mysql-data-dir], 
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
}
