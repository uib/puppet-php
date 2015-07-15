# == Define: php::module
#
# Install php modules. Only modules defined in the case switch will install
# module pacakges, otherwise we asume the module is embedded in core and
# only enables the module with a extension=<name>.so statement
#
# === Parameters
#
# Document parameters here
#
# [*name*]
#   If there is a parameter that defaults to the value of the title string
#   when not explicitly set, you must always say so.  This parameter can be
#   referred to as a "namevar," since it's functionally equivalent to the
#   namevar of a core resource type.
#
# [*ensure*]
#   Ensure that the module is either present or absent
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   php::module { 'curl':
#     ensure => 'present',
#   }
#
# === Authors
#
# Raymond Kristiansen <st02221@uib.no>
#
# === Copyright
#
# Copyright 2013 UiB
#
define php::module(
  $ensure       = 'absent',
  $confd_dir    = $::php::confd_dir,
  $version      = $::php::version,
  $order        = '20',
  $package      = false
) {

  # Install package
  if $package == false {
    case $name {
      'gd':           { $install_package = 'php-gd' }
      'xml':          { $install_package = 'php-xml' }
      'imap':         { $install_package = 'php-imap' }
      'ldap':         { $install_package = 'php-ldap' }
      'mysql':        { $install_package = 'php-mysql' }
      'pgsql':        { $install_package = 'php-pgsql' }
      'sqlite3':      { $install_package = 'php-pdo' }
      'mbstring':     { $install_package = 'php-mbstring' }
      'odbc':         { $install_package = 'php-odbc' }
      'mcrypt':       { $install_package = 'php-mcrypt' }
      'bcmath':       { $install_package = 'php-bcmath' }
      'apc':          { $install_package = 'php-pecl-apc' }
      'snmp':         { $install_package = 'php-snmp' }
      'eaccelerator': { $install_package = 'php-eaccelerator' }
      'fpdf':         { $install_package = 'php-fpdf' }
      default: {
        if $version == '56' {
          $path = "${confd_dir}/${order}-${name}.ini"
        } else {
          $path = "${confd_dir}/${name}.ini"
        }

        unless $ensure == 'absent' {
          file { $path:
            ensure => $ensure,
            mode => '0644',
            owner => 'root',
            group => 'root',
            content => template("${module_name}/module.ini.erb");
          }
        }
      }
    }
  } else {
    $install_package = $package
  }

  if $install_package {
    package { $install_package:
      ensure => $ensure
    }
  }

}
