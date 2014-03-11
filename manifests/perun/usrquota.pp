define cerit::perun::usrquota (
  $mountpoint,
  $ensure     = present,
  $block_soft = 0,
  $block_hard = 0,
  $inode_soft = 0,
  $inode_hard = 0
) {
  validate_absolute_path($mountpoint)

  if (! is_integer($block_soft)) or
    (! is_integer($block_hard)) or
    (! is_integer($inode_soft)) or
    (! is_integer($inode_hard))
  {
    fail('Quota values must be integer')
  }

  perun::hook { "99_disk_usrquota_${title}":
    ensure  => $ensure,
    type    => 'post',
    service => 'passwd',
    content => "
. /etc/passwd.uid

if grep -F ' ${mountpoint} ' /proc/mounts | grep -q usrquota; then
  getent passwd \\
    | awk -F: -vMIN_UID=\$MIN_UID -vMAX_UID=\$MAX_UID '
      (\$3>MIN_UID && \$3<MAX_UID) {
        print \$1\" ${block_soft} ${block_hard} ${inode_soft} ${inode_hard}\"
      }' \\
    | setquota -u -b -c ${mountpoint}
fi
",
  }
}
