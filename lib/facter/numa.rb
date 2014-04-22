# Fact: is_numa
#
# Purpose: NUMA related facts
#
# Resolution:
#   Sets is_numa to true if hardware is NUMA system.
#
# Caveats:
#   lscpu or numactl command required
#
Facter.add("is_numa") do
  confine :kernel => :linux
  setcode do
    numacount = Facter.value("numacount")
    if numacount
      if numacount.to_i > 1
        "true"
      else
        "false"
      end
    end
  end
end

Facter.add("is_numa") do
  confine :kernel => :linux
  setcode do
    out = Facter::Util::Resolution.exec('numactl --hardware 2>/dev/null')
    if out =~ /available: (\d+) nodes/
      if ($1.to_i > 1)
        "true"
      else
        "false"
      end
    end
  end
end
