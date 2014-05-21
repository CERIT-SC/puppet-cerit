# Fact: has_libnfsidmap2_du
#
# Purpose: Detect patched package libnfsidmap2
#
# Resolution:
#   Returns true/false if we have installed patched libnfsidmap2
#
# Caveats:
#   Check only on Debian.
#
Facter.add("has_libnfsidmap2_du") do
  confine :operatingsystem => :Debian
  setcode do
    require 'puppet'
    pkg = Puppet::Type.type(:package).new(:name => "libnfsidmap2")
    ver = pkg.retrieve[pkg.property(:ensure)]
    unless ['absent','purged'].include?(ver.to_s) 
      if ver =~ /\.du/
        "true"
      else
        "false"
      end
    else
      nil
    end
  end
end
