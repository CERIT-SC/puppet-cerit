class cerit::firewall::pre {
  Firewall {
    require => undef,
  }

  firewall { '000 Puppet: allow packets with valid state':
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }->
  firewall { '001 Puppet: allow icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '002 Puppet: allow all to lo interface':
    iniface => 'lo',
    action  => 'accept';
  }
}
