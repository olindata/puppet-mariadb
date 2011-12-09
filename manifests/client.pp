class mariadb::client {
  
  require apt::repo::mariadb
  
  package { $mariadb::params::packagename_client:  
    ensure  => "present",
  }
}

