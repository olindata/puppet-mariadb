class mariadb::client {
  
  require apt::repo::mariadb
  require mariadb::params
    
  package { $mariadb::params::packagename_client:  
    ensure  => "present",
  }
}

