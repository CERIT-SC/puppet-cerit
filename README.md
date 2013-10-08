# Puppet CERIT-SC module

This module contains facts and classes specific for CERIT-SC environment.

### Requirements

Module has been tested on:

* Puppet 3.3
* Debian and Red Hat family systems

Required modules:

* stdlib (https://github.com/puppetlabs/puppetlabs-stdlib)

# Facts

* city (e.g. *brno*, *jihlava*)
* is\_cluster (e.g. *true*, *false*)
* clustername (e.g. *zewura*)
* clusternodeid (e.g. *12*)
* link\_ethX (e.g. *true*, *false*)
* speed\_ethX (e.g. *10000*)
* has\_kernel\_zs (e.g. *true*, *false*)
* is\_numa (e.g. *true*, *false*)
* has\_scratch (e.g. *true*, *false*)
* has\_scratchssd (e.g. *true*, *false*)
* virtual (e.g. *true*, *false*)

# Classes

## cerit::firewall

Configure firewall default rules (based on RHEL's defaults).

```puppet
class { 'cerit::firewall':
  enabled      => false|true,  # enable configuration
  purge        => false|true,  # purge rules not managed by Puppet
  strict       => false|true,  # drop all undefined traffic
  source_ssh   => '0.0.0.0/0', # enable sshd from address range
  source_http  => CIDR,        # enable http from address range
  source_https => CIDR,        # enable https from address range
  services     => {},          # hash of cerit::firewall::service resources
}
```

Simple custom service rules can be specified as hash passed to
`create_resources` to get `cerit::firewall::service` resources.
Example:

```puppet
$services = {
  'postgresql' => {
    'port'   => '5432',
    'source' => '1.2.3.4/24'
  }
}

class { 'cerit::firewall':
  services => $services,
}
```

## cerit::motd

Creates standard login banners for CERIT-SC or ICS-MU.

```puppet
class { 'cerit::motd':
  message => '...',   # custom add-on message
  logo    => array,   # custom 4 lines logo in 4 array elements
}
```

Example:

```puppet
$logo = [
  ' ___         '
  '| __|__  ___ '
  '| _/ _ \/ _ \'
  '|_|\___/\___/'
]

class { 'cerit::motd':
   message => 'Merry Christmas and Happy New Year',
   logo    => $logo,
}

```

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
