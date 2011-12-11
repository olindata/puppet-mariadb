# Grant a mysql user permissions to a database
#
# Usage: mariadb::user { "dbname": "username" }

define mariadb::user($username, $pw, $dbname, $grants = 'all privileges', $host_to_grant = '%', $dbhost = 'localhost', $withgrants = false) {
  
  require mariadb::params
  
  Exec { path => "/bin:/usr/bin" }

  if $withgrants {
      exec { "create-grant-${name}-${username}-${dbhost}":
      command => "mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -e 'grant ${grants} on ${dbname}.* to `${username}`@`${host_to_grant}` identified by \"${pw}\" with grant option'",
      onlyif  => "[ `mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -BN -e 'select count(*) from mysql.db where User=\"${username}\" and Db=\"${dbname}\"'` -eq 0 ]",
      require => Package['mariadb-client']
    }
  } else {
      exec { "create-grant-${name}-${username}-${dbhost}":
      command => "mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -e 'grant ${grants} on ${dbname}.* to `${username}`@`${host_to_grant}` identified by \"${pw}\"'",
      onlyif  => "[ `mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -BN -e 'select count(*) from mysql.db where User=\"${username}\" and Db=\"${dbname}\"'` -eq 0 ]",
      require => Package['mariadb-client']
    }
    }
}

