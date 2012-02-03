  # Creates an account and database and grant permissions for the database to the account

define mariadb::database($username, $password, $database, $grants = 'all privileges', $grant_to_host = '%', $withgrants = false, $dbserver = 'localhost') {

  require mariadb::params

  exec { "create-db-${name}-${database}":
    command => "/usr/bin/mysqladmin create -h${dbserver} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} ${database}",
    unless  => "/usr/bin/mysql -h${dbserver} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -e'select schema_name from information_schema.schemata where schema_name = \"${database}\";' | grep ${database}",
    require => Package[$mariadb::params::packagename_client]
  }

  mariadb::user { "grant-mysql-${name}-${database}-${username}":
    username      => $username,
    pw            => $password,
    dbname        => $database,
    grants        => $grants,
    host_to_grant => $grant_to_host,
    dbhost        => $dbserver,
    withgrants    => $withgrants,
  }

}

