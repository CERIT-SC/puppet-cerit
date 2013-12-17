class cerit::zenoss (
  $enabled         = $cerit::params::zenoss_ssh_enabled,
  $user_name       = $cerit::params::zenoss_ssh_user_name,
  $group_name      = $cerit::params::zenoss_ssh_group_name,
  $allow_from      = $cerit::params::zenoss_ssh_allow_from,
  $key             = $cerit::params::zenoss_ssh_key,
  $type            = $cerit::params::zenoss_ssh_type,
  $sudo_package    = $cerit::params::zenoss_sudo_package,
  $sudo_commands   = $cerit::params::zenoss_sudo_commands,
  $sudo_parameters = $cerit::params::zenoss_sudo_parameters
) inherits cerit::params {

  class { 'cerit::zenoss::user':
    enabled    => $enabled,
    user_name  => $user_name,
    group_name => $group_name,
    allow_from => $allow_from,
    key        => $key,
    type       => $type,
  }

  class { 'cerit::zenoss::sudo':
    enabled    => $enabled,
    group_name => $group_name,
    package    => $sudo_package,
    commands   => $sudo_commands,
    parameters => $sudo_parameters,
  }

  anchor { 'cerit::zenoss::begin': ; }
    -> Class['cerit::zenoss::user']
    -> Class['cerit::zenoss::sudo']
    -> anchor { 'cerit::zenoss::end': ; }
}
