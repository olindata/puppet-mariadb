class mariadb::monitoring::tribily {
  
  tribily::agent::userparams{ 'mariadb':
    file_src => 'mariadb/monitoring/tribily.conf',
    username      => $mariadb::params::monitor_user, 
    password      => $mariadb::params::monitor_pass,
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
