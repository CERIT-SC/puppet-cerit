# Fact: has_scratch
# Fact: has_scratchssd
#
# Purpose: Detect available scratch directories.
#
# Resolution:
#   Detects available scratch directories.
#
# Caveats:
#   Doesn't check if scratch is mounted.
#
['/scratch','/scratch.ssd'].each do |dir|
  value='false'
  if File.directory?(dir) and ! File.symlink?(dir)
    value='true'
  end

  key=File.basename(dir).gsub(/[^a-z]/i,'')
  Facter.add("has_#{key}") do
    setcode do
      value
    end
  end
end
