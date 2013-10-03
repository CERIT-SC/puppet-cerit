# Fact: is_numa
#
# Purpose: NUMA related facts
#
# Resolution:
#   Sets is_numa to true if hardware is NUMA system.
#
# Caveats:
#   'numactl' command is required.
#
Facter.add("is_numa") do
  confine :kernel => :linux
  setcode do
    out = Facter::Util::Resolution.exec('numactl --hardware 2>/dev/null')
    if out =~ /available: (\d+) nodes/
      if ($1.to_i > 1)
        'true'
      else
        'false'
      end
    end
  end
end
