# Fact: city
#
# Purpose: Return machine city.
#
# Resolution:
#   Facts tries to guess machine physical location based
#   on its IP address or domain name.
#
# Caveats:
#   Only CERIT-SC and few MetaCentrum locations are supported.
#
Facter.add("city") do
  setcode do
    value  = nil

    if Facter.value(:interfaces)
      Facter.value(:interfaces).split(',').each do |iface|
        case Facter.value("ipaddress_#{iface}")
        when /^147\.251\.25[45]\./
          value='jihlava'
        end

        break if ! value.nil?
      end
    end

    if value.nil?
      case Facter.value(:domain)
      when 'cerit-sc.cz'
        value='brno'
      when /\.(muni|vutbr)\.cz$/
        value='brno'
      when /\.zcu\.cz$/
        value='plzen'
      end
    end

    value
  end
end
