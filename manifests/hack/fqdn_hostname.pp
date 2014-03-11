class cerit::hack::fqdn_hostname (
  $enabled  = $cerit::params::hack_fqdn_hostname_enabled,
  $filename = $cerit::params::hack_fqdn_hostname_filename
) inherits cerit::params {

  validate_bool($enabled)
  validate_absolute_path($filename)

  if $enabled == true {
    file { $filename:
      ensure  => file,
      content => "${::fqdn}\n",
      notify  => Exec["hostname ${::fqdn}"],
    }

    exec { "hostname ${::fqdn}":
      command => "hostname ${::fqdn}",
      unless  => "hostname | grep -qxF '${::fqdn}'",
      path    => '/bin:/usr/bin',
    }
  }
}
