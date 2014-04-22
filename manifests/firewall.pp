class cerit::firewall (
  $enabled         = $cerit::params::firewall_enabled,
  $purge           = $cerit::params::firewall_purge,
  $strict          = $cerit::params::firewall_strict,
  $source_ssh      = $cerit::params::firewall_source_ssh,
  $source_http     = $cerit::params::firewall_source_http,
  $source_https    = $cerit::params::firewall_source_https,
  $services        = $cerit::params::firewall_services
) inherits cerit::params {

  validate_bool($enabled, $purge, $strict)
  validate_hash($services)

  if $enabled {
    resources { 'firewall':
      purge => $purge,
    }

    Firewall {
      before  => Class['cerit::firewall::post'],
      require => Class['cerit::firewall::pre'],
    }

    include ::firewall
    include cerit::firewall::pre
    class { 'cerit::firewall::post':
      strict => $strict;
    }

    # enable common services
    if $source_ssh {
      cerit::firewall::service { 'ssh':
        port   => 22,
        source => $source_ssh,
        strict => ! $strict,
      }
    }

    if $source_http {
      cerit::firewall::service { 'http':
        port   => 80,
        source => $source_http,
        strict => ! $strict,
      }
    }

    if $source_https {
      cerit::firewall::service { 'https':
        port   => 443,
        source => $source_https,
        strict => ! $strict,
      }
    }

    if $services {
      create_resources(cerit::firewall::service,
        $services,
        {'strict' => ! $strict})
    }

    Firewall<| |>
  }
}
