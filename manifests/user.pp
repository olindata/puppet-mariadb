# Grant a mysql user permissions to a database
#
define mariadb::user::dummyloop($dbname, $grantoption, $isgrantable, $username,
  $pw, $real_admin_pass, $dbhost, $host_to_grant){

  # un-parse our nastyness to get to the actual grant again
  $grant_ = regsubst($name, '___', '', 'G')
  $grant_parts = split($grant_, '__')
  $grant = $grant_parts[3]

  if ($dbname == '*') {
    $real_dbname = "*.*"
    $privilege_check_query = "select count(*) from information_schema.USER_PRIVILEGES where GRANTEE=\\\"'${username}'@'${host_to_grant}'\\\" and PRIVILEGE_TYPE=\\\"${grant}\\\" and IS_GRANTABLE=\\\"${isgrantable}\\\""
  } else {
    $real_dbname = "`${dbname}`.*"
    $privilege_check_query = "select count(*) from information_schema.SCHEMA_PRIVILEGES where TABLE_SCHEMA=\\\"'${dbname}'\\\" GRANTEE=\\\"'${username}'@'${host_to_grant}'\\\" and PRIVILEGE_TYPE=\\\"${grant}\\\" and IS_GRANTABLE=\\\"${isgrantable}\\\""
  }

  exec { "create-grant-${name}-${username}-${host_to_grant}-${dbhost}":
    command => "/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -e 'grant ${grant} on ${real_dbname} to `${username}`@`${host_to_grant}` identified by \"${pw}\" ${grantoption}'",
    path    => "/bin:/usr/bin",
    onlyif  => "[ `/usr/bin/mysql -h${dbhost} -u${mariadb::params::admin_user} ${real_admin_pass} -BN -e \"${privilege_check_query}\"` -eq 0 ]",
    require => Package[$mariadb::params::packagename_client]
  }

}

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

  # This is some very nasty puppet stunts to make it possible to run through a string of grants
  # First surround all individual grants with triple underscores, then prefix each with host,
  # dbname and username so the $name var for the dummy loop stays unique

  #replace all spaces by underscores
  #$grants = 'INSERT, DELETE'
  $grants_ = regsubst($grants, '\s*,\s*', "___,___${dbhost}__${dbname}__${username}__", 'G')
  #$grants_ = 'INSERT__,__DELETE'
  $grants__ = "___${dbhost}__${dbname}__${username}__${grants_}___"
  #$grants__ = "__localhost_zabbix_zabbixuser_INSERT__,__DELETE__
  # split the grants by comma into an array
  $grants_array = split($grants__,',')
  #$grants_array =

  # call dummy loop with the array in order to check/create all desired grants
  mariadb::user::dummyloop{ $grants_array:
    dbname          => $dbname,
    grantoption     => $grantoption,
    isgrantable     => $isgrantable,
    username        => $username,
    pw              => $pw,
    real_admin_pass => $real_admin_pass,
    dbhost          => $dbhost,
    host_to_grant   => $host_to_grant
  }
}
