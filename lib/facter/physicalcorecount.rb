# Fact: physicalcorecount
#
# Purpose: Detect physical CPU cores (no thread cores)
#
# Resolution:
#   Returns number of physical cores
#
# Caveats:
#   Depends on facts processorcorecount, processorsocketcount
#
Facter.add("physicalcorecount") do
  setcode do
    cores = Facter.value("processorcorecount")
    socks = Facter.value("processorsocketcount")

    if cores and socks
      (cores.to_i * socks.to_i).to_s
    end
  end
end
