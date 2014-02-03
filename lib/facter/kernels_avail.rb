# Fact: kernels_avail
#
# Purpose: List all available kernels for installation
#
# Resolution:
#   Returns comma separated list of installable kernel packages.
#
# Caveats:
#   Check only on Debian.
#
Facter.add("kernels_avail") do
  confine :operatingsystem => :Debian
  setcode do
    pkgs = Facter::Util::Resolution.exec('apt-cache pkgnames linux-image')
    if pkgs 
      pkgs.split.sort.join(',')
    else
      nil	
    end
  end
end
