# glpi

[![Build Status](https://travis-ci.org/echoes-tech/puppet-glpi.svg?branch=master)]
(https://travis-ci.org/echoes-tech/puppet-glpi)
[![Flattr Button](https://api.flattr.com/button/flattr-badge-large.png "Flattr This!")]
(https://flattr.com/submit/auto?user_id=echoes&url=https://forge.puppetlabs.com/echoes/glpi&title=Puppet%20module%20to%20manage%20GLPI&description=This%20module%20installs%20and%20configures%20GLPI.&lang=en_GB&category=software "Puppet module to manage GLPI installation and configuration")

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with glpi](#setup)
    * [Beginning with glpi](#beginning-with-glpi)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Add a plugin](#add-a-plugin)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)

## Overview

Puppet module to manage GLPI installation and configuration.

## Module Description

This module installs and configures [GLPI](glpi-project.org).

## Setup

### Beginning with glpi

```puppet
include ::apache
include ::mysql::server
include ::glpi
```

## Usage

### Add a plugin

**WARNING:** The glpi module use the [puppetlabs-vcsrepo](https://forge.puppet.com/puppetlabs/vcsrepo) module and it does not install any VCS software for you. You must install a VCS before you can use this module.

```puppet
plugin::install { 'racks':
  source  => 'https://github.com/InfotelGLPI/racks.git',
  version => '1.7.0'
}
```

## Reference

### Classes

#### Public classes

* glpi: Main class, includes all other classes.

#### Private classes

* glpi::params: Sets parameter defaults per operating system.
* glpi::install: Handles the packages.
* glpi::config: Handles the configuration file.

#### Parameters

The following parameters are available in the `::glpi` class:

##### `package_ensure`

Tells Puppet whether the GLPI package should be installed, and what version. Valid options: 'present', 'latest', or a specific version number. Default value: 'present'

##### `package_name`

Tells Puppet what GLPI package to manage. Valid options: string. Default value: 'glpi'

### Defines

#### Public defines

* glpi::plugin: Adds a GLPI plugin.

#### Parameters

The following parameters are available in the `::glpi::plugin` define:

##### `ensure`

Tells Puppet whether the check should exist. Valid options: 'present', 'absent'. Default value: present

##### `source`

Tells Puppet what is the path of the repository plugin. Valid options: string. Default value: undef

##### `version`

Tells Puppet what is the version of the repository plugin. Valid options: string. Default value: undef

##### `provider`

Specifies the provider for the [puppetlabs-vcsrepo](https://forge.puppet.com/puppetlabs/vcsrepo) module. Valid options: string. Default value: git

## Limitations

Debian family OSes are officially supported. Tested and built on Debian.

## Development

[Echoes Technologies](https://echoes.fr) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/echoes-tech/puppet-glpi/fork)

## Contributors

The list of contributors can be found at: https://github.com/echoes-tech/puppet-glpi/graphs/contributors
