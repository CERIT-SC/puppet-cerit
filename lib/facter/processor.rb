# Fact: processorcorethreadcount
# Fact: processorcorecount
# Fact: processorsocketcount
# Fact: numacount
# Fact: processorl1dsize
# Fact: processorl1isize
# Fact: processorl2size
# Fact: processorl3size
#
# Purpose: Detect various processor metrics
#
# Resolution:
#   Use lscpu to get number of CPU threads,
#   cores, sockets, NUMA nodes and cache sizes.
#
# Caveats:
#   lscpu command required
#
lscpu = Facter::Util::Resolution.exec('lscpu 2>/dev/null')
if lscpu 
  lscpu.lines.each do |l|
    k,v  = l.strip().split(/\s*:\s*/,2)
    name = nil

    case k
      when 'Thread(s) per core'
        name = 'processorcorethreadcount'
      when 'Core(s) per socket'
        name = 'processorcorecount'
      when 'CPU socket(s)', 'Socket(s)'
        name = 'processorsocketcount'
      when 'NUMA node(s)'
        name = 'numacount'
      when 'L1d cache'
        name = 'processorl1dsize'
      when 'L1i cache'
        name = 'processorl1isize'
      when 'L2 cache'
        name = 'processorl2size'
      when 'L3 cache'
        name = 'processorl3size'
    end

    if name 
      Facter.add(name) do
        setcode do
          v
        end
      end
    end
  end
end
