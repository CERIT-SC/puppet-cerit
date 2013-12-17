class cerit::zenoss::user (
  $enabled,
  $user_name,
  $group_name,
  $allow_from,
  $key,
  $type
) {
  validate_bool($enabled)

  if ! defined(User[$user_name]) {
    $_home = "/var/lib/${user_name}"

    $_ensure = $enabled ? {
      true    => present,
      default => absent
    }

    group { $group_name:
      ensure => $_ensure,
      system => true,
    }

    user { $user_name:
      ensure     => $_ensure,
      gid        => $gropu_name,
      system     => true,
      shell      => '/bin/bash',
      managehome => true,
      home       => $_home,
    }

    file { "${_home}/.ssh/authorized_keys":
      ensure  => $_ensure,
      owner   => $user_name,
      group   => $group_name,
      mode    => '0600',
      seltype => 'ssh_home_t',
      require => Ssh_authorized_key['cerit::zenoss::user'],
    }
  }

  ssh_authorized_key { 'cerit::zenoss::user':
    ensure    => $_ensure,
    require   => User[$user_name],
    key       => $key,
    type      => $type,
    user      => $user_name,
    options   => [ "from=\"${allow_from}\"" ],
  }
}
