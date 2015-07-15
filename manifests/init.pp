# == Class: php
#
# PHP module for el6 and higher.
#  
#
# === Parameters
#
# Document parameters here.
#
#
# === Examples
#
#  class { 'php': }
#
# === Authors
#
# Raymond Kristiansen <st02221@uib.no>
#
# === Copyright
#
# Copyright 2013 UiB
#
class php (
  $purge_confd          = false,
  $confd_dir            = "/etc/php.d",
  $max_execution_time   = 30,
  $max_input_time       = 60,
  $memory_limit         = "128M",
  $post_max_size        = "10M",
  $upload_max_filesize  = "5M",
  $error_reporting      = $::data_env ? {
    'production'  => "E_ALL & ~E_DEPRECATED",
    'dev'         => "E_ALL | E_STRICT",
    default       => "E_ALL & ~E_NOTICE" },
  $display_errors = $::data_env ? {
    'production'  => "off",
    default       => "on" },
  $packages = ['php','php-common', 'php-cli'],
  $scl = false,
  $modules = hiera_hash('php::modules_hiera', {})
) {

  # Version
  if $scl {
    $version = $scl? {
      'php56' => 56,
      'php55' => 55,
      default => 56
    }
  } elsif $::osfamily == 'RedHat' {
    $version = $::operatingsystemmajrelease? {
      6 => 53,
      7 => 54,
      default => 53
    }
  } else { $version = 53 }

  # SCL
  if $scl == 'php56' {
    file { '/etc/opt/rh/rh-php56/php.ini':
      ensure => link,
      force => true,
      target => '/etc/php.ini',
      #before => Class['::php::config'],
    }
    file { '/etc/opt/rh/rh-php56/php.d':
      ensure => link,
      force => true,
      target => '/etc/php.d',
      #before => Class['::php::config'],
    }
  }

  class { 'php::install': } ->
  class { 'php::config': } 

  create_resources('php::module', $modules, { require => Class['php::config']})

}
