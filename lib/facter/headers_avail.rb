# Fact: headers_avail
#
# Purpose: List all available kernels headers for installation
#
# Resolution:
#   Returns comma separated list of installable kernel header packages.
#
# Caveats:
#   Check only on Debian.
#
Facter.add("headers_avail") do
  confine :operatingsystem => :Debian
  setcode do
    pkgs = Facter::Util::Resolution.exec('apt-cache search "^linux-headers-" | cut -d" " -f1')
    if pkgs 
      pkgs.split.sort.join(',')
    else
      nil	
    end
  end
end
