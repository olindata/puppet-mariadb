class mariadb::server inherits mariadb::client {

  require apt::repo::mariadb 
  require mariadb::params

  # make sure the proper 5.1 packages are installed
  package { "mariadb-server":
    name    => $mariadb::params::packagename_server,  
    ensure  => "present"     
  }

  # make sure the mysql user and group exist
  group { "mysql": 
    ensure    => "present",
    gid       => $mariadb::params::user_gid,
    require   => Package["mariadb-server"],
  }

  # data directory at /mysql/data, so
  # make sure that those directories exist
  file { $mariadb::params::data_dir: 
    ensure    => "directory",
    owner     => "mysql",
    group     => "mysql" 
  }
    
  file { $mariadb::params::log_dir:
    ensure    => "directory",
    owner     => "mysql",
    group     => "mysql" 
  }
    
  file { "/var/run/mysqld": 
    ensure    => "directory",
    owner     => "mysql",
    group     => "mysql" 
  }

  # make sure that /etc/my.cnf exists.
  # this only ensure that the file exists and has the correct 
  # permissions.  If you want to supply a custom source, you may override
  # this in a subclass.
  file { "/etc/mysql/my.cnf":  
    require   => Package["mariadb-server"], 
    source    => $mariadb::params::my_cnf_source,
    owner     => "mysql",
    group     => "mysql" 
  }

  file { "/etc/mysql/debian.cnf":  
    require   => Package["mariadb-server"], 
    content   => template("mariadb/debian.cnf.erb"),
    owner     => root,
    group     => root,
    mode      => 600
  }

  user { "mysql": 
    ensure  => "present",
    uid     => $mariadb::params::user_gid,
    gid     => $mariadb::params::user_gid,
    comment => "MariaDB Server",
    home    => $mariadb::params::data_dir,
    shell   => "/bin/bash",
    require => [
      Package["mariadb-server"], 
      Group["mysql"]
    ],
  }

  # make sure that mysqld is running
  service { "mysql":
    enable     => true,
    ensure     => "running",
    #ensure    => "stopped",
    hasrestart => true,
    hasstatus  => true,
    require    => [
      File["/etc/mysql/my.cnf"], 
      File[$mariadb::params::data_dir], 
      Package["mariadb-server"] 
    ],
  }

  # set mysql root password
  exec { "Set MySQL server root password":
    subscribe   => Package["mariadb-server"],
    refreshonly => true,
    unless      => "/usr/bin/mysqladmin -uroot -p${mariadb::params::root_password} status",
    command     => "/usr/bin/mysqladmin -uroot password ${mariadb::params::root_password}",
  }
}
