# Private class
class glpi::install inherits glpi {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'glpi':
    ensure => $glpi::package_ensure,
    name   => $glpi::package_name,
  }
}
