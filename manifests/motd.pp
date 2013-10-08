class cerit::motd (
  $message  = $cerit::params::motd_message,
  $logo     = $cerit::params::motd_logo,
  $template = $cerit::params::motd_template
) inherits cerit::params {

  file { '/etc/motd.tail':
    ensure  => absent,
  }

  file { '/etc/motd':
    ensure  => file,
    content => template($template),
  }
}
