# == Class: php::install
#
# Installation for PHP module
#
# === Authors
#
# Raymond Kristiansen <st02221@uib.no>
#
# === Copyright
#
# Copyright 2013 UiB
#
class php::install (
  $packages = $php::packages  
) {

  # managing main package
  package {
    $packages:
      ensure => latest
  }

}
