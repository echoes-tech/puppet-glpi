# == Define: glpi::plugin
#
define glpi::plugin (
  $ensure   = present,
  $source   = undef,
  $version  = undef,
  $provider = 'git',
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['glpi']) {
    fail('You must include the glpi base class before using any glpi defined resources')
  }

  validate_re($ensure, '^(present|absent)$',
    "glpi::plugin::ensure is <${ensure}> and must be 'present' or 'absent'.")

  if $source != undef and is_string($source) == false {
    fail 'glpi::plugin::source is not a string.'
  }

  vcsrepo { "${::glpi::install_dir}/plugins/${name}":
    ensure   => $ensure,
    provider => $provider,
    source   => $source,
    revision => $version,
    require  => Package['glpi'],
  }
}
