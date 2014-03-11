# Fact: mounts
#
# Purpose: ...
#
# Resolution:
#   ...
#
# Caveats:
#   Works only on Linux.
#
Facter.add("mounts") do
  confine :kernel => :linux
  setcode do
    mounts = []
    File.readlines('/proc/mounts').each do |m|
      mp = m.split[1]
      mp.chomp!('/') if mp != '/'
      mp.gsub!('\040',' ') #TODO: mooore
      mounts << mp
    end
    mounts.uniq.sort.join(',') #TODO: fix , in mountpoint
  end
end
