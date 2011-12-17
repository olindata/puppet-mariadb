class mariadb::client {
  
  # We need the apt repo to be able to install the latest mariadb version
  require apt::repo::mariadb
  
  # require the params class so we have access to the params inside it
  require mariadb::params
    
  package { "mariadb-client":
    name    => $mariadb::params::packagename_client,  
    ensure  => "present",
  }
}

