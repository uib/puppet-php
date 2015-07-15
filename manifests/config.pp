# == Class: php::config
#
# Config for PHP module
#
# === Authors
#
# Raymond Kristiansen <st02221@uib.no>
#
# === Copyright
#
# Copyright 2013 UiB
#
class php::config (
  $confd_dir            = $::php::confd_dir,
  $purge_confd          = $::php::purge_confd,
  $max_execution_time   = $::php::max_execution_time,
  $max_input_time       = $::php::max_input_time,
  $memory_limit         = $::php::memory_limit,
  $error_reporting      = $::php::error_reporting,
  $display_errors       = $::php::display_errors,
  $post_max_size        = $::php::post_max_size,
  $upload_max_filesize  = $::php::upload_max_filesize,
  $version              = $::php::version
) {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # module conf dir
  file { $confd_dir:
    ensure    => directory,
    purge     => $purge_confd,
    recurse   => $purge_confd
  }

  # default php conf
  file { 'php.ini':
    path =>  "/etc/php.ini",
    ensure => present,
    content => template("${module_name}/${version}/php.ini.erb"),
  }

}
