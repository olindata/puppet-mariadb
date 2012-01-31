class mariadb::monitoring::tribily {

  tribily::agent::userparams{ 'mariadb':
    content       => template('mariadb/monitoring/tribily.conf'),
  }

  file { '/opt/tribily/bin/mysql_repl_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('mariadb/monitoring/mysql_repl_status.pl.erb'), 
  }

  file { '/opt/tribily/bin/mysql_status.pl':
    ensure  => present,
    owner   => 'root',
    group   => 'zabbix',
    mode    => 510,
    content => template('mariadb/monitoring/mysql_status.pl.erb'), 
    
  }

  mariadb::user{ 'tribilyagent':
    username      => $mariadb::params::monitor_user, 
    pw            => $mariadb::params::monitor_pass,
    dbname        => '*', 
    grants        => 'REPLICATION CLIENT', 
    host_to_grant => 'localhost', 
    dbhost        => 'localhost', 
    withgrants    => false
  }
}
