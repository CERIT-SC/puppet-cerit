define cerit::firewall::service (
  $port,
  $proto   = 'tcp',
  $source  = '0.0.0.0/0',
  $seq     = 500,
  $seq_rej = 600,
  $strict  = true,
) {
  validate_bool($strict)

  if is_array($port) {
    $port_str = join($port, ',')
  } else {
    $port_str = $port
  }

  $name_accept = "${seq} Puppet: accept ${port_str}/${proto} (${name})"
  $name_reject = "${seq_rej} Puppet: reject ${port_str}/${proto} (${name})"

  @firewall { $name_accept:
    dport  => $port,
    proto  => $proto,
    source => $source,
    action => 'accept',
  }

  if ($proto == 'tcp') {
    Firewall[$name_accept] {
      state => 'NEW'
    }
  }

  if $strict and $source !~ /^0\.0\.0\.0\// {
    @firewall { $name_reject:
      dport   => $port,
      proto   => $proto,
      action  => 'reject',
      reject  => 'icmp-host-prohibited',
      require => Firewall[$name_accept];
    }
  }
}
