class mariadb::monitoring::tribily {

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

  # path should map to where the zabbix include is
  file { '/etc/zabbix/conf.d/mariadb.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => 640,
    content => template('mariadb/monitoring/tribily.conf')
    # should do a notify - buts its cross module
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
