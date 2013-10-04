class cerit::params {
  $firewall_enabled = true
  $firewall_purge = true
  $firewall_strict = true
  $firewall_source_ssh = '0.0.0.0/0'
  $firewall_source_http = false
  $firewall_source_https = false
  $firewall_services = {}

  # allow use of insecure NFS mounts
  $mounts_trusted = true
  $mount_enabled_smaug1 = true
  $mount_enabled_plzen1 = true
  $mount_enabled_plzen2 = true
  $mount_enabled_praha2 = true
  $mount_enabled_budejovice1 = true
}
