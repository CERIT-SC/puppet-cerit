class cerit::zenoss::sudo (
  $enabled,
  $group_name,
  $package,
  $commands,
  $parameters
) {
  validate_bool($enabled)

  if ! defined(Package[$package]) {
    package { $package:
      ensure => present,
    }
  }

  $_ensure = $enabled ? {
    true    => present,
    default => absent
  }

  sudo::defaults { "Defaults:${group_name}":
    ensure     => $_ensure,
    parameters => $parameters,
    require    => Package[$package],
  }

  sudo::spec { 'zenoss':
    ensure   => $_ensure,
    hosts    => 'ALL',
    users    => "%${group_name}",
    commands => $commands,
    require  => Sudo::Defaults["Defaults:${group_name}"],
  }
}
