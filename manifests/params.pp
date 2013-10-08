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

  # motd
  # http://ascii.dtools.net/index1.php
  # (font small)
  $motd_message = ''

  case $::domain {
    'cerit-sc.cz': {
      $motd_logo = [
        '  ___ ___ ___  _ _____    ___  ___ ',
        ' / __| __| _ \| |_   _|__/ __|/ __|',
        '| (__| _||   /| | | ||___\__ \ (__ ',
        ' \___|___|_|_\|_| |_|    |___/\___|']
    }

    'ics.muni.cz': {
      $motd_logo = [
        ' ___ ___ ___     __  __ _   _ ',
        '|_ _/ __/ __|___|  \/  | | | |',
        ' | | (__\__ \___| |\/| | |_| |',
        '|___\___|___/   |_|  |_|\___/ ']
    }

    default: {
      $motd_logo = ['','','','']
    }
  }
}
