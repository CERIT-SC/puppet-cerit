class cerit::hack::hosts_own_ip (
  $enabled      = $cerit::params::hack_hosts_own_ip_enabled,
  $fqdn         = $cerit::params::hack_hosts_own_ip_fqdn,
  $host_aliases = $cerit::params::hack_hosts_own_ip_host_aliases,
  $ip           = $cerit::params::hack_hosts_own_ip_ip
) inherits cerit::params {

  validate_bool($enabled)
  validate_string($fqdn, $ip)
  validate_array($host_aliases)

  if $enabled == true {
    unless is_ip_address($ip) {
      fail("Invalid IP address: ${ip}")
    }

    unless is_domain_name($fqdn) {
      fail("Invalid FQDN: ${fqdn}")
    }

    augeas { 'fix-hosts_own_ip':
      incl    => '/etc/hosts',
      lens    => 'Hosts.lns',
      context => '/files/etc/hosts',
      changes => "set *[canonical = '${fqdn}']/ipaddr ${ip}",
    }

    host { $fqdn:
      ensure       => present,
      ip           => $ip,
      host_aliases => $host_aliases,
      require      => Augeas['fix-hosts_own_ip'],
    }
  }
}
