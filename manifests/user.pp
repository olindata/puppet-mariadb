# Grant a mysql user permissions to a database
#
# Usage: mariadb::user { "dbname": "username" }
define mariadb::user ($username, $pw, $dbname, $grants = 'all privileges',
  $host_to_grant = '%', $dbhost = 'localhost', $withgrants = false) {

  include mariadb::params 
  
  if ($dbname == '*') {
    $real_dbname = "*.*"
  } else {
    $real_dbname = "`${dbname}`.*"
  }
  
  if $withgrants {
    exec { "create-grant-${name}-${username}-${dbhost}":
      command => "/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -e 'grant ${grants} on ${real_dbname} to `${username}`@`${host_to_grant}` identified by \"${pw}\" with grant option'",
      path    => "/bin:/usr/bin",
      onlyif  => "[ `/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -BN -e 'select count(*) from mysql.db where User=\"${username}\" and Db=\"${real_dbname}\"'` -eq 0 ]",
      require => Package['mariadb-client']
    }
  } else {
    exec { "create-grant-${name}-${username}-${dbhost}":
      command => "/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -e 'grant ${grants} on ${real_dbname} to `${username}`@`${host_to_grant}` identified by \"${pw}\"'",
      path    => "/bin:/usr/bin",
      onlyif  => "[ `/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} -p${mariadb::params::admin_pass} -BN -e 'select count(*) from mysql.db where User=\"${username}\" and Db=\"${real_dbname}\"'` -eq 0 ]",
      require => Package['mariadb-client']
    }
  }
}

