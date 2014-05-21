# Puppet CERIT-SC module

This module contains facts and classes specific for CERIT-SC environment.

### Requirements

Module has been tested on:

* Puppet 3.3
* Debian and Red Hat family systems

Required modules:

* stdlib (https://github.com/puppetlabs/puppetlabs-stdlib)

# Facts

Fact                         | Description                      | Example
---------------------------- | -------------------------------- | -----------------
**city**                     | Machine physical location        | *brno*, *jihlava*
**is\_cluster**              | Is cluster node?                 | *true*, *false*
**clustername**              | Detect name of cluster           | *zewura*
**clusternodeid**            | Detect node ID in cluster        | *12*
**link\_ethX**               | Is link on net. iface?           | *true*, *false*
**speed\_ethX**              | Net. iface speed [Mbit/s]        | *10000*
**speeds\_ethX**             | List of supported net. speeds    | *10,100,1000*
**kernels\_avail**           | List of available kernel pkgs    |
**headers\_avail**           | List of available header pkgs    |
**has\_kernel\_zs**          | Is running kernel patched by ZS? | *true*, *false*
**has\_libnfsidmap2\_du**    | Is installed our libnfsidmap2?   | *true*, *false*
**has\_scratch**             | Is /scratch available?           | *true*, *false*
**has\_scratchssd**          | Is /scratch.ssd available?       | *true*, *false*
**mounts**                   | List of current mount points     | */,/boot,/home*
**virtual**                  | Fixed generic fact for KVM       |
**is\_numa**                 | Is hardware NUMA?                | *true*, *false*
**numacount**                | Number of NUMA nodes             |
**has\_hyperthreading**      | Is hyperthreading enabled?       | *true*, *false*
**physicalcorecount**        | Number of physical cores         | 
**processorcorethreadcount** | Number of threads per core       |
**processorcorecount**       | Number of cores per socket       |
**processorsocketcount**     | Number of CPU sockets in system  |
**processorl1dsize**         | L1 data cache size               |
**processorl1isize**         | L1 instruction cache size        |
**processorl2size**          | L2 cache size                    |
**processorl3size**          | L3 cache size                    |

# Classes

List:

* [cerit::firewall](#ceritfirewall)
* [cerit::passwd](#ceritpasswd)
* [cerit::puppet](#ceritpuppet)
* [cerit::motd](#ceritmotd)
* [cerit::zenoss](#ceritzenoss)
* [cerit::hack](#cerithack-classes)

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

## cerit::passwd

Set password for privileged user default or based on 
host (group) security level.

```puppet
class { 'cerit::passwd':
  user     => 'root',  # privileged user name
  password => '*',     # default password
  level    => '...',   # host security level
  levels   => { ... }, # hash of security levels and passwords
}
```

Example: 

```puppet
class { 'cerit::passwd':
  password => '*',   # empty default password, if no level specified
  level    => 2,     # take password for security level 2
  levels   => {
    1 => 'password hash X',
    2 => 'password hash Y',
    3 => 'password hash Z'
  },
}
```

## cerit::puppet

Simple Puppet agent boostrap.

```puppet
class { 'cerit::puppet':
  enabled         => false|true,   # enable Puppet
  cron            => false|true,   # Puppet as service or cron
  command         => '...',        # cron command
  packages        => array,        # packages override
  config          => '...',        # configuration file
  service         => 'puppet',     # service name
  server          => '...'.        # Puppet server hostname
  environment     => 'production', # Puppet environment
  runinterval     => 1800,         # run interval
  configtimeout   => 120,          # server timeout
  prerun_command  => '...',        # prerun command
  postrun_command => '...',        # postrun command
}
```

Example:

```puppet
class { 'cerit::puppet':
  server      => 'puppet.example.com',
  environment => 'devel',
  runinterval => 3600, # once per hour
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
  ' ___         ',
  '| __|__  ___ ',
  '| _/ _ \/ _ \',
  '|_|\___/\___/',
]

class { 'cerit::motd':
  message => 'Merry Christmas and Happy New Year',
  logo    => $logo,
}
```

Typical banner looks like:

       ___ ___ ___  _ _____    ___  ___   Hostname:  localhost.localdomain (Brno)
      / __| __| _ \| |_   _|__/ __|/ __|  System:    Debian 6.0.7 on x86_64
     | (__| _||   /| | | ||___\__ \ (__   CPU cores: 80x (80x physical)
      \___|___|_|_\|_| |_|    |___/\___|  Mem./swap: 504.90 GB / 162.71 GB (NUMA)

    <<< custom $message here (if any) >>>

    Last login: Tue Oct  8 11:45:19 2013 from localhost.localdomain


## cerit::zenoss

Create unprivileged Zenoss user for remote monitoring via SSH.

```puppet
class { 'cerit::zenoss':
  enabled         => false|true,      # enable Zenoss user
  user_name       => '...',           # user name
  group_name      => '...',           # group name
  allow_from      => '...',           # restrict access via SSH key from
  key             => '...',           # SSH public key
  type            => '...',           # SSH public key type
  sudo_package    => '...',           # package name with sudo
  sudo_parameters => ['!requiretty'], # list of sudo parameters for user group
  sudo_commands   => [                # list of allowed commands in sudo format
    '(ALL) NOPASSWD: /usr/sbin/dmidecode *',
    '(ALL) NOPASSWD: /usr/bin/ipmitool *',
    '(ALL) NOPASSWD: /usr/sbin/smartctl *'
  ],
}
```

Example:

```puppet
class { 'cerit::zenoss':
  allow_from => 'zenoss.localdomain',
  user_name  => 'zen',
  group_name => 'zen',
}
```

## cerit::hack classes

Various one-time OS hacks

### cerit::hack::asyncmountnfs

Enable/disable asynchronous NFS mounts on Debian.

### cerit::hack::fqdn\_hostname

Write FQDN into machine hostname configuration.

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
