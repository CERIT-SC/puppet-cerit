# Fact: link_ethX
# Fact: speed_ethX
# Fact: speeds_ethX
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
if ifaces and Facter.value(:kernel) == 'Linux'
  ifaces.split(',').each do |iface|
    out = Facter::Util::Resolution.exec("ethtool #{iface} 2>/dev/null")

    #-----
    # Settings for eth1:
    #     Supported ports: [ TP ]
    #     Supported link modes:   10baseT/Half 10baseT/Full 
    #                             100baseT/Half 100baseT/Full 
    #                             1000baseT/Half 1000baseT/Full 
    #     Supported pause frame use: No
    #     Supports auto-negotiation: Yes
    #     Advertised link modes:  100baseT/Half 100baseT/Full 
    #                             1000baseT/Half 1000baseT/Full 
    #     Advertised pause frame use: No
    #     Advertised auto-negotiation: Yes
    #     Speed: 1000Mb/s
    #     Duplex: Full
    #     Port: Twisted Pair
    #     PHYAD: 0
    #     Transceiver: external
    #     Auto-negotiation: on
    #     MDI-X: Unknown
    #     Supports Wake-on: g
    #     Wake-on: g
    #     Link detected: yes
    #-----

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

      # parse multilined supported linkmodes
      if out =~ /Supported link modes:((\s+\d+base\w+\/\w+)+)/m
        modes = []
        $1.split.each do |mode|
          if mode =~ /^(\d+)/
            modes << $1 
          end 
        end

        if modes
          Facter.add("speeds_#{iface}") do
            setcode do
              modes.uniq.join(',')
            end
          end
        end
      end
    end
  end
end
