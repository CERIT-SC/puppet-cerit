class cerit::hack::asyncmountnfs (
  $enabled = $cerit::params::hack_asyncmountnfs_enabled
) inherits cerit::params {

  validate_bool($enabled)

  if $::operatingsystem != 'Debian' {
    fail("Unsupported OS: ${::operatingsystem}")
  }

  $_enabled = $enabled ? {
    true  => 'yes',
    false => 'no'
  }

  augeas { 'asyncmountnfs':
    incl    => '/etc/default/rcS',
    lens    => 'Shellvars.lns',
    context => '/files/etc/default/rcS',
    changes => "set ASYNCMOUNTNFS ${_enabled}",
  }
}
