# == Class: glpi
#
class glpi (
  $package_ensure        = $glpi::params::package_ensure,
  $package_name          = $glpi::params::package_name,
) inherits glpi::params {
  # <variable validations>
  validate_string($package_ensure)
  validate_string($package_name)
  # </variable validations>

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
