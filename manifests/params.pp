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

  # passwd
  $passwd_user = 'root'
  $passwd_password = '*'
  $passwd_level = undef
  $passwd_levels = {}

  # puppet
  $puppet_enabled = true
  $puppet_cron = false
  $puppet_command = '/bin/bash -c "sleep $((RANDOM \%% %i + 20)) && puppet agent --no-daemonize --onetime --ignorecache --no-usecacheonfailure --no-splay -v" >/dev/null 2>&1'
  $puppet_packages = ['puppet']
  $puppet_config = '/etc/puppet/puppet.conf'
  $puppet_service = 'puppet'
  $puppet_server = 'localhost'
  $puppet_environment = 'production'
  $puppet_runinterval = 1800
  $puppet_configtimeout = 120
  $puppet_prerun_command = ''
  $puppet_postrun_command = ''

  # motd
  # http://ascii.dtools.net/index1.php
  # (font small)
  case $::operatingsystem {
    windows: {
      $motd_filename = 'c:/cygwin/etc/motd'
      $motd_mode = '0664'
    }

    default: {
      $motd_filename = '/etc/motd'
      $motd_mode = '0644'
    }
  }

  $motd_message = ''
  $motd_template = 'cerit/motd.erb'

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

  # zenoss
  $zenoss_ssh_enabled = true
  $zenoss_ssh_user_name = 'zenoss'
  $zenoss_ssh_group_name = $zenoss_ssh_user_name
  $zenoss_ssh_allow_from = 'localhost'
  $zenoss_ssh_key = 'AAAAB3NzaC1kc3MAAACBAJEY4rVig1vLLp8fcsBEG9a6mEBNyf3RTWV8iX3pZW6JgcvgyYCR/S8eGZFh4CN4GBtzG0p9aXt6fVVmcyLkbPcrAm37s4tBKC8afg38BE7H+PkRN6WelTfZXbuZ//5ajlvW0l46HLKraSQdlp05nQNly3zFL54YebjLVkoAHYbDAAAAFQCmQRXDbst4gvhkuMjJyqSPzjMUIQAAAIAIv19hnlWge/O/b5jrmlJcHGg3PdPTV2w+kZrFOKDKSHqdULVH7N19uUK+0lEUP3Zz5yk6sDP6uQR6kuusAF380Ztx2NR6AgVeiUvbPbZ0tbsCuAKSHGqht+LG6mHPhTsqXa9Covx8rmi3YDOCdYCJ7eQ/WXZD7xKz1f+o44G5AwAAAIAUtyNPtKQXp1MAYf9cXBhmbHfxCBnxvXrRoko9CkSPaC19htoYUDHDe7LiOyhKy0JLuJUiNbWpKZ2G4b4uKq0RqAyXxP+MUlLjg/DiZKjJHNvG2j0nkHI/dhY5elBctiW7LvY377l8SX/YZj+1J3apuASL/Ga5+a7hzV6nHBNnfg=='
  $zenoss_ssh_type = 'ssh-dss'

  $zenoss_sudo_package = 'sudo'
  $zenoss_sudo_parameters = ['!requiretty']
  $zenoss_sudo_commands = [
    '(ALL) NOPASSWD: /usr/sbin/dmidecode *',
    '(ALL) NOPASSWD: /usr/bin/ipmitool *',
    '(ALL) NOPASSWD: /usr/sbin/smartctl *'
  ]
}
