# == Class: glpi::params
#
# This is a container class with default parameters for glpi classes.
class glpi::params {
  $package_ensure        = 'present'

  case $::osfamily {
    'Debian': {
      $package_name = 'glpi'
    }
    default: {
      fail("glpi supports osfamilies Debian. Detected osfamily is <${::osfamily}>.")
    }
  }
}
