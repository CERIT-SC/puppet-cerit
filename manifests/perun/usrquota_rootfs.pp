class cerit::perun::usrquota_rootfs (
  $ensure     = $cerit::params::perun_usrquota_rootfs_ensure,
  $block_soft = $cerit::params::perun_usrquota_rootfs_block_soft,
  $block_hard = $cerit::params::perun_usrquota_rootfs_block_hard,
  $inode_soft = $cerit::params::perun_usrquota_rootfs_inode_soft,
  $inode_hard = $cerit::params::perun_usrquota_rootfs_inode_hard
) inherits cerit::params {

  cerit::perun::usrquota { 'rootfs':
    ensure     => $ensure,
    mountpoint => '/',
    block_soft => $block_soft,
    block_hard => $block_hard,
    inode_soft => $inode_soft,
    inode_hard => $inode_hard
  }
}
