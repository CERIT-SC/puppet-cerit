class cerit::motd (
  $filename = $cerit::params::motd_filename,
  $message  = $cerit::params::motd_message,
  $logo     = $cerit::params::motd_logo,
  $template = $cerit::params::motd_template,
  $mode     = $cerit::parasm::motd_mode,
) inherits cerit::params {

  if ($::operatingsystem != 'windows') {
    file { '/etc/motd.tail':
      ensure  => absent,
    }
  }

  file { $filename:
    ensure  => file,
    content => template($template),
    mode    => $mode,
  }
}
