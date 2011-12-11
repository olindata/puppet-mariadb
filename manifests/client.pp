class mariadb::client {
  
  require apt::repo::mariadb
  require mariadb::params
    
  package { "mariadb-client":
    name    => $mariadb::params::packagename_client,  
    ensure  => "present",
  }
}

