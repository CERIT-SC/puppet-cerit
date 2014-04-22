# Fact: has_hyperthreading
#
# Purpose: Detect hyperthreading
#
# Resolution:
#   Returns true/false if hyperthreading is enabled
#
# Caveats:
#   Depends on processorthreadscount fact
#
Facter.add("has_hyperthreading") do
  setcode do
    threads = Facter.value("processorcorethreadcount")
    if threads
      if threads.to_i > 1
        "true"
      else
        "false"
      end
    end
  end
end
