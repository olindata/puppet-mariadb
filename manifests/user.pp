# Grant a mysql user permissions to a database
#
# Usage: mariadb::user { "dbname": "username" }
define mariadb::user ($username, $pw, $dbname, $grants = 'all privileges',
  $host_to_grant = '%', $dbhost = 'localhost', $withgrants = false) {

  include mariadb::params

  if $withgrants {
    $grantoption = ' with grant option'
    $isgrantable = 'YES'
  } else {
    $grantoption = ''
    $isgrantable = 'NO'
  }

  if ($mariadb::params::admin_pass == '') {
    $real_admin_pass = ''
  } else {
    $real_admin_pass = "-p\"${mariadb::params::admin_pass}\""
  }

  if ($dbname == '*') {
    $real_dbname = "*.*"
    $privilege_check_query = "select count(*) from information_schema.USER_PRIVILEGES where GRANTEE=\"'${username}'@'${dbhost}'\" and PRIVILEGE_TYPE=\"${grants}\" and IS_GRANTABLE=\"${isgrantable}\""
  } else {
    $real_dbname = "`${dbname}`.*"
    $privilege_check_query = "select count(*) from information_schema.SCHEMA_PRIVILEGES where TABLE_SCHEMA=\"'${dbname}'\" GRANTEE=\"'${username}'@'${dbhost}'\" and PRIVILEGE_TYPE=\"${grants}\" and IS_GRANTABLE=\"${isgrantable}"
  }

  exec { "create-grant-${name}-${username}-${dbhost}":
    command => "/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -e 'grant ${grants} on ${real_dbname} to `${username}`@`${host_to_grant}` identified by \"${pw}\" ${grantoption}'",
    path    => "/bin:/usr/bin",
    onlyif  => "[ `/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -BN -e \"${privilege_check_query}\"` -eq 0 ]",
    require => Package[$mariadb::params::packagename_client]
  }
}

