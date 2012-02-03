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

  if ($mariadb::params::admin_pass == '') {
    $real_admin_pass = ''
  } else {
    $real_admin_pass = "-p\"${mariadb::params::admin_pass}\""
  }

  if $withgrants {
    $grantoption = ' with grant option'
    $isgrantable = 'YES'
  } else {
    $grantoption = ''
    $isgrantable = 'NO'
  }

  exec { "create-grant-${name}-${username}-${dbhost}":
    command => "/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -e 'grant ${grants} on ${real_dbname} to `${username}`@`${host_to_grant}` identified by \"${pw}\" ${grantoption}'",
    path    => "/bin:/usr/bin",
    onlyif  => "[ `/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -BN -e \"select count(*) from information_schema.USER_PRIVILEGES where GRANTEE=\\\"'${username}'@'${dbhost}'\\\" and PRIVILEGE_TYPE=\\\"${grants}\\\" and IS_GRANTABLE=\\\"${isgrantable}\\\"\"` -eq 0 ]",
    require => Package[$mariadb::params::packagename_client]
  }
}

