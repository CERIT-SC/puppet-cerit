class cerit::firewall::post (
  $strict,
) {
  Firewall {
    before => undef,
  }

  if ($strict) {
    firewall { '998 Puppet: drop everything else':
      action => 'reject',
      reject => 'icmp-host-prohibited',
    }->
    firewall { '999 Puppet: drop everything else':
      chain  => 'FORWARD',
      action => 'reject',
      reject => 'icmp-host-prohibited';
    }
  }
}
