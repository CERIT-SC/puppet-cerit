# Fact: has_kernel_zs
#
# Purpose: Detect patched kernel.
#
# Resolution:
#   Returns true/false if we are running our patched kernel.
#
# Caveats:
#   Check only on Debian.
#
Facter.add("has_kernel_zs") do
  confine :operatingsystem => :Debian
  setcode do
    version = Facter::Util::Resolution.exec('uname -v')
    if version =~ /\+zs\d/
      "true"
    else
      "false"
    end
  end
end
