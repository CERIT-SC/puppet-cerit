class cerit::puppet (
  $enabled         = $cerit::params::puppet_enabled,
  $cron            = $cerit::params::puppet_cron,
  $command         = $cerit::params::puppet_command,
  $packages        = $cerit::params::puppet_packages,
  $config          = $cerit::params::puppet_config,
  $service         = $cerit::params::puppet_service,
  $server          = $cerit::params::puppet_server,
  $environment     = $cerit::params::puppet_environment,
  $runinterval     = $cerit::params::puppet_runinterval,
  $configtimeout   = $cerit::params::puppet_configtimeout,
  $prerun_command  = $cerit::params::puppet_prerun_command,
  $postrun_command = $cerit::params::puppet_postrun_command
) {
  validate_bool($enabled, $cron)
  validate_array($packages)
  validate_string($command, $config, $service, $server, $environment)
  validate_string($runinterval, $configtimeout)
  validate_string($prerun_command, $postrun_command)

  if $enabled {
    if $cron {
      $_ensure_srvc = stopped
      $_ensure_cron = present
    } else {
      $_ensure_srvc = running
      $_ensure_cron = absent
    }
  } else {
    $_ensure_srvc = stopped
    $_ensure_cron = absent
  }

  # install and configure
  ensure_packages($packages)

  file { $config:
    ensure  => file,
    content => template('cerit/puppet.conf.erb'),
    notify  => Service[$service],
  }

  file { '/etc/profile.d/puppet.sh':
    ensure  => file,
    content => 'alias puppet-run="puppet agent --no-daemonize --verbose --onetime --ignorecache --no-usecacheonfailure --no-splay -v"',
  }

  # manage service or cronjob
  service { $service:
    ensure  => $_ensure_srvc,
    enable  => $enabled and (! $cron),
    restart => 'killall -HUP puppet || /bin/true',
  }

  $hour = defined(Class['torque::mom']) ? {
    true  => ['0-23/4','1-23/4','2-23/4','3-23/4'],
    false => ['0-23/8','2-23/8','4-23/8','6-23/8']
  }

  cron { 'puppet-on-reboot':
    ensure  => $_ensure_cron,
    user    => root,
    command => sprintf($command,180),
    special => 'reboot';
  }

  cron { 'puppet':
    ensure  => $_ensure_cron,
    user    => root,
    command => sprintf($command,600),
    hour    => $hour[fqdn_rand(size($hour))],
    minute  => fqdn_rand(60),
  }
}
