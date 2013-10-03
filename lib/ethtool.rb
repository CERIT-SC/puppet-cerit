# Fact: link_ethX
# Fact: speed_ethX
#
# Purpose: Detect link and speed on interfaces
#
# Resolution:
#   Use ethtool tool to detect link and speed of all
#   available ethernet interfaces.
#
# Caveats:
#   Reliable as ethtool
#
ifaces = Facter.value(:interfaces)
if ifaces
  ifaces.split(',').each do |iface|
    out = Facter::Util::Resolution.exec("ethtool #{iface} 2>/dev/null")
    if out =~ /Link detected: (yes|no)/
      link = ($1 == 'yes') ? 'true' : 'false'

      Facter.add("link_#{iface}") do
        setcode do
          link
        end
      end

      if (link == 'true') and (out =~ /Speed: (\d+)Mb\/s/)
        speed=$1
        Facter.add("speed_#{iface}") do
          setcode do
            speed
          end
        end
      end
    end
  end
end
